import Testing
import Foundation
@testable import TraktorCloneCore

// MARK: - Rest-1: Beat-Offset-Schätzung

@Suite("Beatgrid-Offset")
struct BeatgridOffsetTests {
    @Test func offsetWirdAusOnsetPhaseGeschätzt() {
        // Onset-Kurve 10 fps, 120 BPM → 5 Frames pro Beat; Peaks bei Phase 3.
        var onsets = [Float](repeating: 0, count: 40)
        for i in stride(from: 3, to: 40, by: 5) { onsets[i] = 1 }
        let offset = BeatGrid.estimateFirstBeatOffset(onsets: onsets, framesPerSecond: 10, bpm: 120)
        #expect(offset == 0.3)   // Frame 3 / 10 fps
    }

    @Test func zuKurzeKurveGibtNull() {
        #expect(BeatGrid.estimateFirstBeatOffset(onsets: [0, 1], framesPerSecond: 10, bpm: 120) == 0)
        #expect(BeatGrid.estimateFirstBeatOffset(onsets: [], framesPerSecond: 10, bpm: 120) == 0)
    }

    @Test func memoryRoundtripMitOffset() throws {
        let entry = TrackMemoryEntry(path: "/x.mp3", cue: 1.5, hotcues: ["1": 2.0],
                                     bpm: 128, key: "Am", beatgridOffset: 0.21)
        let data = try JSONEncoder().encode(entry)
        let back = try JSONDecoder().decode(TrackMemoryEntry.self, from: data)
        #expect(back.beatgridOffset == 0.21)
    }

    @Test func altesMemoryJSONOhneOffsetLädt() throws {
        // Ältere gespeicherte Dateien haben das Feld nicht — darf nicht werfen.
        let json = #"{"path":"/x.mp3","hotcues":{},"bpm":120}"#
        let e = try JSONDecoder().decode(TrackMemoryEntry.self, from: Data(json.utf8))
        #expect(e.beatgridOffset == nil)
        #expect(e.bpm == 120)
    }
}

// MARK: - Rest-2: Sync-Phase-Nudge

@Suite("Sync-Phase-Nudge")
struct SyncNudgeTests {
    @Test func slaveSpringtAufKürzestenWegZurMasterPhase() {
        let sync = SyncEngine()
        let g = BeatGrid(bpm: 120, firstBeatOffset: 0)   // 0.5 s pro Beat
        // Master: 0.9 s = Beat 1 + Phase 0.8 · Slave: 0.1 s = Beat 0.2
        // Kandidaten mit Ziel-Phase 0.8: 0.4 (d 0.3) und 0.9 (d 0.8); −0.1 ungültig → 0.4
        let target = sync.nudgeTarget(masterTime: 0.9, master: g, slaveTime: 0.1, slave: g)
        #expect(abs(target - 0.4) < 0.0001)
    }

    @Test func offsetsWerdenBeruecksichtigt() {
        let sync = SyncEngine()
        let master = BeatGrid(bpm: 120, firstBeatOffset: 0.0)
        let slave = BeatGrid(bpm: 120, firstBeatOffset: 0.25)
        // Master 1.0 s → Phase 0; Slave 0.5 s → Beats (0.5-0.25)/0.5 = 0.5 → floor 0 → Ziel 0.25 + 0 = 0.25
        let target = sync.nudgeTarget(masterTime: 1.0, master: master, slaveTime: 0.5, slave: slave)
        #expect(abs(target - 0.25) < 0.0001)
    }

    @Test func bpmUnterschiedNutztSlaveBeatlaenge() {
        let sync = SyncEngine()
        let master = BeatGrid(bpm: 120, firstBeatOffset: 0)     // 0.5 s
        let slave = BeatGrid(bpm: 100, firstBeatOffset: 0)      // 0.6 s
        // Master 0.6 s → Phase 0.2; Slave 0.9 s → floor(1.5) = 1 → Ziel 0.6 + 0.2*0.6 = 0.72
        let target = sync.nudgeTarget(masterTime: 0.6, master: master, slaveTime: 0.9, slave: slave)
        #expect(abs(target - 0.72) < 0.0001)
    }
}

// MARK: - Rest-4: Waveform-Fenster

@Suite("Waveform-Fenster")
struct WaveWindowTests {
    @Test func zoomEinsZeigtAlles() {
        let w = WaveWindow.visible(playheadFraction: 0.7, zoom: 1, buckets: 400)
        #expect(w.offset == 0 && w.width == 1)
    }

    @Test func zoomZweiZentriertAufPlayhead() {
        let w = WaveWindow.visible(playheadFraction: 0.5, zoom: 2, buckets: 400)
        // Fenster = 200 Buckets, Mitte auf 200 → Start 100
        #expect(abs(w.offset - 0.25) < 0.0001)
        #expect(abs(w.width - 0.5) < 0.0001)
    }

    @Test func fensterWirdAnGrenzenGeklemmt() {
        let end = WaveWindow.visible(playheadFraction: 0.95, zoom: 2, buckets: 400)
        #expect(abs(end.offset - 0.5) < 0.0001)   // Start max = 400-200 = 200
        let empty = WaveWindow.visible(playheadFraction: 0.5, zoom: 4, buckets: 0)
        #expect(empty.offset == 0 && empty.width == 1)
    }
}

// MARK: - Rest-5: Playlists

@Suite("PlaylistStore")
struct PlaylistStoreTests {
    @Test func roundtripUeberTempDatei() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("tc-test-\(UUID().uuidString).json")
        defer { try? FileManager.default.removeItem(at: url) }
        let list = [
            Playlist(name: "Warm-Up", trackPaths: ["/a.mp3", "/b.mp3"]),
            Playlist(name: "Peak", trackPaths: []),
        ]
        try PlaylistStore.save(list, to: url)
        let back = PlaylistStore.load(from: url)
        #expect(back == list)
    }

    @Test func fehlendeDateiGibtLeer() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("tc-gibts-nicht-\(UUID().uuidString).json")
        #expect(PlaylistStore.load(from: url).isEmpty)
    }
}

// MARK: - Rest-7: Spotify (Parsing + Match, kein Netz im Test)

@Suite("Spotify-Import")
struct SpotifyImportTests {
    @Test func playlistURLsWerdenErkannt() {
        #expect(SpotifyClient.playlistID(from: "https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M?si=abc") == "37i9dQZF1DXcBWIGoYBM5M")
        #expect(SpotifyClient.playlistID(from: "spotify:playlist:5Y5bO4w12aBcD3eF4gHi5J") == "5Y5bO4w12aBcD3eF4gHi5J")
        #expect(SpotifyClient.playlistID(from: "37i9dQZF1DXcBWIGoYBM5M") == "37i9dQZF1DXcBWIGoYBM5M")
    }

    @Test func nonsensWirdAbgelehnt() {
        #expect(SpotifyClient.playlistID(from: "nutzi") == nil)
        #expect(SpotifyClient.playlistID(from: "https://example.com/x; rm -rf /") == nil)
        #expect(SpotifyClient.playlistID(from: "") == nil)
    }

    @Test func idOhneSonderzeichenKeinInjectionFenster() {
        // Pattern erlaubt nur [A-Za-z0-9] → Request-Pfad bleibt sicher.
        let id = SpotifyClient.playlistID(from: "https://open.spotify.com/playlist/abcDEF123?x=../../etc")
        #expect(id == "abcDEF123")
    }

    @Test func matchPriorisiertExaktenTitel() {
        var a = NMLTrack(); a.title = "Blinding Lights"; a.artist = "The Weeknd"
        var b = NMLTrack(); b.title = "Lights"; b.artist = "Ellie Goulding"
        let hit = PlaylistMatch.match(spotify: SpotifyTrack(name: "Blinding Lights", artist: "The Weeknd"),
                                      in: [b, a])
        #expect(hit?.title == "Blinding Lights")
    }

    @Test func matchOhneTrefferIstNil() {
        var a = NMLTrack(); a.title = "Anderer Song"
        #expect(PlaylistMatch.match(spotify: SpotifyTrack(name: "Nicht vorhanden", artist: "X"), in: [a]) == nil)
    }
}

// MARK: - Rest-6: Audio-Treiber (nur Lesen — kein System-Umschalten im Test)

@Suite("Audio-Geräte")
struct AudioDevicesTests {
    @Test func macHatMindestensEinenOutput() {
        let devices = AudioDevices.list()
        #expect(!devices.isEmpty)
        #expect(AudioDevices.defaultOutputID() != nil)
    }

    @Test func defaultOutputIstInListe() {
        if let def = AudioDevices.defaultOutputID() {
            #expect(AudioDevices.list().contains { $0.id == def })
        }
    }
}
