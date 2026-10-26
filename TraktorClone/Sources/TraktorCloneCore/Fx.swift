import AVFoundation

/// Effekt-Units pro Deck (Verkabelung macht AudioEngine): EQ-Filter, Delay, Reverb.
public final class FxChain {
    public let eq: AVAudioUnitEQ
    public let delay: AVAudioUnitDelay
    public let reverb: AVAudioUnitReverb

    public init() {
        eq = AVAudioUnitEQ(numberOfBands: 2)
        // Band 0: HighPass (Achtung: default bypass), Band 1: LowPass
        eq.bands[0].filterType = .highPass
        eq.bands[0].frequency = 20
        eq.bands[0].bypass = true
        eq.bands[1].filterType = .lowPass
        eq.bands[1].frequency = 20000
        eq.bands[1].bypass = true
        delay = AVAudioUnitDelay()
        delay.wetDryMix = 0
        reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 0
        reverb.loadFactoryPreset(.smallRoom)
    }

    /// Filter ein/aus: highPass schaltet Band 0, sonst Band 1 (LowPass).
    public func setFilter(cutoffHz: Double, highPass: Bool, enabled: Bool) {
        let f = Self.clamp(cutoffHz, 20, 20000)
        let band = highPass ? eq.bands[0] : eq.bands[1]
        band.frequency = Float(f)
        band.bypass = !enabled
    }

    /// Delay: Zeit ms, Feedback %, Wet % (0 = trocken/bypass).
    public func setDelay(timeMs: Double, feedbackPct: Double, wetPct: Double) {
        delay.delayTime = TimeInterval(Self.clamp(timeMs, 0, 2000) / 1000)
        delay.feedback = Float(Self.clamp(feedbackPct, 0, 100))
        delay.wetDryMix = Float(Self.clamp(wetPct, 0, 100))
    }

    private var reverbIsSmall = true

    /// Reverb: Wet % + Raum-Größe (Preset nur bei Wechsel laden — kein Audio-Glitch).
    public func setReverb(wetPct: Double, preset small: Bool) {
        if small != reverbIsSmall {
            reverb.loadFactoryPreset(small ? .smallRoom : .largeHall)
            reverbIsSmall = small
        }
        reverb.wetDryMix = Float(Self.clamp(wetPct, 0, 100))
    }

    /// Alles trocken (Bypass).
    public func bypassAll() {
        setDelay(timeMs: 0, feedbackPct: 0, wetPct: 0)
        setReverb(wetPct: 0, preset: true)
        setFilter(cutoffHz: 20, highPass: true, enabled: false)
        setFilter(cutoffHz: 20000, highPass: false, enabled: false)
    }

    public static func clamp(_ v: Double, _ lo: Double, _ hi: Double) -> Double {
        min(max(v, lo), hi)
    }
}
