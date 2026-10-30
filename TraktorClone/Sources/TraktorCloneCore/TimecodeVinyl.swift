import Foundation

/// DVS-Timecode-Decoder: liest Position, Richtung und Geschwindigkeit aus dem
/// Stereo-Signal eines Timecode-Vinyls (z. B. Traktor Scratch).
///
/// Eigenständige Implementierung des öffentlich dokumentierten Signalformats:
/// Das Vinyl trägt ein LFSR-codiertes Steuerwort; Seed/Taps/Bits sind die
/// Interop-Spezifikation des Signals (kein fremder Code übernommen). Grundlage:
/// Reverse Engineering für Interoperabilität (Art. 6 RL 2009/24/EG = § 40e UrhG).
public struct TimecodeDefinition: Equatable, Sendable {
    public let name: String
    public let resolution: Int        // Carrier-Hz bei Referenzgeschwindigkeit 1.0
    public let bits: Int
    public let seed: UInt32
    public let taps: UInt32
    public let length: UInt32         // Anzahl gültiger Codes (eine Platten-Seite)
    public let safe: UInt32           // davon gefahrlos nutzbar
    public let switchPrimary: Bool    // links statt rechts als Primärkanal
    public let switchPolarity: Bool   // Bitwerte negativ lesen
    public let switchPhase: Bool      // Kanäle um 270° statt 90° verschoben

    public init(name: String, resolution: Int, bits: Int, seed: UInt32, taps: UInt32,
                length: UInt32, safe: UInt32,
                switchPrimary: Bool = false, switchPolarity: Bool = false, switchPhase: Bool = false) {
        self.name = name; self.resolution = resolution; self.bits = bits
        self.seed = seed; self.taps = taps; self.length = length; self.safe = safe
        self.switchPrimary = switchPrimary; self.switchPolarity = switchPolarity; self.switchPhase = switchPhase
    }

    /// Traktor Scratch, Seite A (2-kHz-Träger, 23 Bit).
    public static let traktorA = TimecodeDefinition(
        name: "traktor_a", resolution: 2000, bits: 23,
        seed: 0x134503, taps: 0x041040, length: 1_500_000, safe: 1_480_000,
        switchPrimary: true, switchPolarity: true, switchPhase: true)

    /// Traktor Scratch, Seite B.
    public static let traktorB = TimecodeDefinition(
        name: "traktor_b", resolution: 2000, bits: 23,
        seed: 0x32066c, taps: 0x041040, length: 2_110_000, safe: 2_090_000,
        switchPrimary: true, switchPolarity: true, switchPhase: true)

    /// Serato 2nd Edition, Seite A (1-kHz-Träger, 20 Bit).
    public static let serato2A = TimecodeDefinition(
        name: "serato_2a", resolution: 1000, bits: 20,
        seed: 0x59017, taps: 0x361e4, length: 712_000, safe: 707_000)
}

/// LFSR-Positionstabelle: Code → Position auf der Platte.
final class TimecodeLUT {
    private var table: [Int32]
    let def: TimecodeDefinition

    init(def: TimecodeDefinition) {
        self.def = def
        table = [Int32](repeating: -1, count: 1 << def.bits)
        var code = def.seed
        var position: UInt32 = 0
        while position < def.length {
            table[Int(code)] = Int32(position)
            code = TimecodeLUT.fwd(code, def: def)
            if code == def.seed { break }   // LFSR-Periode erreicht
            position += 1
        }
    }

    func lookup(_ code: UInt32) -> Int32 {
        guard Int(code) < table.count else { return -1 }   // Code größer als LFSR-Raum
        return table[Int(code)]
    }

    /// LFSR vorwärts: neues Bit an MSB (Parität von code & taps).
    static func fwd(_ code: UInt32, def: TimecodeDefinition) -> UInt32 {
        let parity = (code & (def.taps | 1)).nonzeroBitCount & 1
        return (code >> 1) | (UInt32(parity) << (def.bits - 1))
    }

    /// LFSR rückwärts: neues Bit an LSB.
    static func rev(_ code: UInt32, def: TimecodeDefinition) -> UInt32 {
        let mask: UInt32 = (1 << def.bits) - 1
        let parity = (code & ((def.taps >> 1) | (1 << (def.bits - 1)))).nonzeroBitCount & 1
        return ((code << 1) & mask) | UInt32(parity)
    }
}

/// Stream-Decoder: frisst Stereo-Samples (±1.0), hält validierte Position +
/// Geschwindigkeit. Nicht Sendable-fähig — je Input-Kanal ein Decoder.
public final class TimecodeDecoder {
    public let def: TimecodeDefinition
    public let sampleRate: Double
    private let lut: TimecodeLUT

    private struct Channel {
        var positive = false
        var zero = 0.0                 // RC-gefilterte Nulllinie (Rumble-Unterdrückung)
        var swapped = false
        var ticker = 0                 // Samples seit letztem Crossing
    }
    private var primary = Channel()
    private var secondary = Channel()

    private var zeroAlpha: Double
    private var threshold: Double
    private var refLevel = -1.0        // Kalibrierung: erster Peak setzt Referenz
    private var lpAlpha: Double        // Tonearm-Tiefpass (dämpft breitbandiges Rauschen)
    private var lpP = 0.0
    private var lpS = 0.0

    private var bitstream: UInt32 = 0
    private var running: UInt32 = 0
    private var validCounter = 0
    private var ticker = 0
    private var isForwards = true
    private var speedEMA = 0.0

    /// Mindestanzahl korrekter Bits, bevor die Position als gültig gilt.
    public static let validBits = 24

    public init(def: TimecodeDefinition, sampleRate: Double, phono: Bool = true) {
        self.def = def
        self.sampleRate = sampleRate
        self.lut = TimecodeLUT(def: def)
        let dt = 1.0 / sampleRate
        zeroAlpha = dt / (0.001 + dt)
        // Grenzfrequenz ~2× Carrier (Signal bis 2 kHz, Rauschen darüber wird gedämpft)
        let rc = 1.0 / (2.0 * Double.pi * 2.0 * Double(def.resolution))
        lpAlpha = dt / (rc + dt)
        threshold = 128.0 / 32768.0
        if phono { threshold /= 32.0 }
    }

    /// Letzte gültige Position auf der Platte (in Codes) oder nil.
    public var position: Int32? {
        let p = lut.lookup(bitstream)
        guard validCounter > Self.validBits, p >= 0 else { return nil }
        return p
    }

    /// Beobachtete Geschwindigkeit (1.0 = Referenz, negativ = rückwärts), EMA-geglättet.
    public var speed: Double { speedEMA }

    /// Sekunden seit dem letzten empfangenen Code-Symbol.
    public var positionAgeSeconds: Double { Double(ticker) / sampleRate }

    private func detectCrossing(_ ch: inout Channel, _ v: Double) {
        ch.ticker += 1
        ch.swapped = false
        if v > ch.zero + threshold && !ch.positive {
            ch.swapped = true; ch.positive = true; ch.ticker = 0
        } else if v < ch.zero - threshold && ch.positive {
            ch.swapped = true; ch.positive = false; ch.ticker = 0
        }
        ch.zero += zeroAlpha * (v - ch.zero)
    }

    private func readBit(primaryValue: Double) {
        let m = abs(primaryValue - primary.zero)
        if refLevel < 0 { refLevel = m }                      // erste Kalibrierung
        let bit: UInt32 = m > refLevel ? 1 : 0

        let mask: UInt32 = (1 << def.bits) - 1
        if isForwards {
            bitstream = (bitstream >> 1) | (bit << (def.bits - 1))
            timecodeRunning = TimecodeLUT.fwd(timecodeRunning, def: def)
        } else {
            bitstream = ((bitstream << 1) & mask) | bit
            timecodeRunning = TimecodeLUT.rev(timecodeRunning, def: def)
        }

        if timecodeRunning == bitstream {
            validCounter += 1
        } else {
            timecodeRunning = bitstream
            validCounter = 0
        }

        // Gleitende Referenz (Peak-Mittel über ~48 Symbole)
        refLevel -= refLevel / 48
        refLevel += m / 48
    }

    private var timecodeRunning: UInt32 = 0

    /// Ein Stereo-Sample einspeisen (Werte ±1.0).
    public func submit(left: Double, right: Double) {
        lpP += lpAlpha * (left - lpP)
        lpS += lpAlpha * (right - lpS)
        let p = def.switchPrimary ? lpP : lpS
        let s = def.switchPrimary ? lpS : lpP
        detectCrossing(&primary, p)
        detectCrossing(&secondary, s)

        if primary.swapped || secondary.swapped {
            let forwardsNow: Bool
            if primary.swapped {
                forwardsNow = primary.positive != secondary.positive
            } else {
                forwardsNow = primary.positive == secondary.positive
            }
            let f = def.switchPhase ? !forwardsNow : forwardsNow

            // Geschwindigkeit aus Crossing-Intervall: ein Kadrant = 1/(4·Auflösung)
            let interval = Double(max(primary.ticker, secondary.ticker)) / sampleRate
            if interval > 0 {
                let inst = (f ? 1.0 : -1.0) * (1.0 / Double(def.resolution) / 4.0) / interval
                if inst.isFinite, abs(inst) < 8 {
                    speedEMA = speedEMA == 0 ? inst : speedEMA * 0.95 + inst * 0.05
                }
            }

            if f != isForwards {
                isForwards = f
                validCounter = 0     // Richtungswechsel → neu validieren
            }
        }
        ticker += 1

        // Ein Bit lesen, wenn der Sekundärkanal kreuzt und die Primärpolarität stimmt
        if secondary.swapped, primary.positive == !def.switchPolarity {
            readBit(primaryValue: p)
        }
    }

    /// Sample-Block einspeisen.
    public func submit(pcmL: [Float], pcmR: [Float]) {
        let n = min(pcmL.count, pcmR.count)
        for i in 0..<n { submit(left: Double(pcmL[i]), right: Double(pcmR[i])) }
    }

    /// Position inkl. Alter (Sekunden seit letzter gültiger Angabe) oder nil.
    public func currentPosition() -> (position: Int32, age: Double)? {
        guard let p = position else { return nil }
        return (p, positionAgeSeconds)
    }

    /// Effektive Abspielposition in Codes (Position + Extrapolation mit speed).
    public var extrapolatedPosition: Double? {
        guard let cur = currentPosition() else { return nil }
        return Double(cur.position) + speed * cur.age * Double(def.resolution)
    }
}
