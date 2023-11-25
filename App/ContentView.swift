import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var viewModel: UserPlantsViewModel
    // @EnvironmentObject var wViewModel: WaterRemindersViewModel
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "BG")
        UITabBar.appearance().isTranslucent = false
    }

    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            VStack {
                HeaderView()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color("Content"))
                TabView {
                    Group {
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "person")
                            }
                            

                        GardenView()
                            .tabItem {
                                Label("My Garden", systemImage: "book")
                            }

                        MyRemindersView()
                            .tabItem {
                                Label("My Reminders", systemImage: "star")
                            }
                    }
                }
                .accentColor(Color("Feature"))
                
            }
        }
    }
}