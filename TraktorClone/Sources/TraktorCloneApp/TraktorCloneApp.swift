import SwiftUI

@main
struct TraktorCloneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var midi = MIDIController()

    var body: some Scene {
        WindowGroup("TraktorClone") {
            ContentView()
                .environmentObject(midi)
                .frame(minWidth: 1000, minHeight: 560)
        }
        .windowToolbarStyle(.unified)
    }
}

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
