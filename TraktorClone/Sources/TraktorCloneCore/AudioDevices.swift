import Foundation
import CoreAudio

/// Ein CoreAudio-Gerät (nur Output-fähige werden gelistet).
public struct AudioDeviceInfo: Equatable {
    public let id: UInt32
    public let name: String
    public init(id: UInt32, name: String) {
        self.id = id
        self.name = name
    }
}

/// CoreAudio-Treiberzugriff: Geräte listen + System-Ausgang umschalten.
/// Bewusst System-weit (macOS-Default-Output) — pro-Deck-Routing bräuchte
/// Aggregate-Devices und ist ein eigenes Ticket.
public enum AudioDevices {
    /// Alle Output-Geräte (Name + Geräte-ID), in HAL-Reihenfolge.
    public static func list() -> [AudioDeviceInfo] {
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)
        var size: UInt32 = 0
        let sys = AudioObjectID(kAudioObjectSystemObject)
        guard AudioObjectGetPropertyDataSize(sys, &addr, 0, nil, &size) == noErr, size > 0 else { return [] }
        var ids = [AudioObjectID](repeating: 0, count: Int(size) / MemoryLayout<AudioObjectID>.size)
        guard AudioObjectGetPropertyData(sys, &addr, 0, nil, &size, &ids) == noErr else { return [] }

        var out: [AudioDeviceInfo] = []
        for dev in ids {
            var sAddr = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyStreams,
                mScope: kAudioObjectPropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain)
            var sSize: UInt32 = 0
            guard AudioObjectGetPropertyDataSize(dev, &sAddr, 0, nil, &sSize) == noErr, sSize > 0 else { continue }
            out.append(AudioDeviceInfo(id: dev, name: deviceName(dev)))
        }
        return out
    }

    /// Name des Geräts (lokalisiert, Fallback auf ID).
    public static func deviceName(_ dev: AudioObjectID) -> String {
        var nameAddr = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)
        var name: CFString? = nil
        var nSize = UInt32(MemoryLayout<CFString?>.size)
        let status = withUnsafeMutablePointer(to: &name) { ptr in
            AudioObjectGetPropertyData(dev, &nameAddr, 0, nil, &nSize, ptr)
        }
        if status == noErr, let n = name as String?, !n.isEmpty { return n }
        return "Device \(dev)"
    }

    /// Aktuelle System-Ausgabe (Geräte-ID) oder nil.
    public static func defaultOutputID() -> UInt32? {
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)
        var dev = AudioObjectID(0)
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &size, &dev)
        guard status == noErr, dev != 0 else { return nil }
        return dev
    }

    /// Setzt den System-Ausgang (macOS-weit). `true` bei Erfolg.
    @discardableResult
    public static func setDefaultOutput(id: UInt32) -> Bool {
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)
        var dev = AudioObjectID(id)
        let status = AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil,
                                                UInt32(MemoryLayout<AudioObjectID>.size), &dev)
        return status == noErr
    }
}
