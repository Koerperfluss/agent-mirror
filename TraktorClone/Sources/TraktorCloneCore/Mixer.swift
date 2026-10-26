import Foundation

/// 2-Kanal-Mixer mit Equal-Power-Crossfader (Traktor/Industrie-Standard).
public struct Mixer {
    public struct ChannelStrip {
        public var gain: Double = 1.0      // 0...2
        public var fader: Double = 1.0     // 0...1
        public init() {}
    }

    public var channelA = ChannelStrip()
    public var channelB = ChannelStrip()
    /// 0 = ganz links (A), 1 = ganz rechts (B), 0.5 = Mitte (beide −3 dB).
    public var crossfader: Double = 0.5

    public init() {}

    /// Equal-Power-Kurve: Mitte = cos²/sin² → beide −3 dB, Summe konstant ~1.
    /// Extremwerte werden gesnappt (cos(π/2) ist in Double nicht exakt 0).
    public static func equalPowerGains(x: Double) -> (a: Double, b: Double) {
        let t = min(max(x, 0), 1)
        if t <= 0 { return (1, 0) }
        if t >= 1 { return (0, 1) }
        let rad = t * .pi / 2
        return (cos(rad) * cos(rad), sin(rad) * sin(rad))
    }

    /// Effektiver Ausgangs-Gain eines Kanals.
    public func outputGain(channel: Int) -> Double {
        let strip = channel == 0 ? channelA : channelB
        let (ga, gb) = Mixer.equalPowerGains(x: crossfader)
        let xf = channel == 0 ? ga : gb
        return strip.gain * strip.fader * xf
    }
}
