import SwiftUI
import UserNotifications

@main
struct GreenThumbApp: App {
    @StateObject private var viewModel = UserPlantsViewModel()
    // @StateObject private var wViewModel = WaterRemindersViewModel()

    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "BG")
        UITabBar.appearance().isTranslucent = false
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                // .environmentObject(wViewModel)
        }
    }
}
