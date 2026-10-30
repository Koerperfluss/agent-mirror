import SwiftUI
import LokiCanvasCore

@main
struct LokiCanvasApp: App {
    @StateObject private var model = CanvasModel()

    var body: some Scene {
        WindowGroup("LokiCanvas") {
            ContentView()
                .environmentObject(model)
                .frame(width: 1200, height: 800)
        }
    }
}
