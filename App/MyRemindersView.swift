//
//  SwiftUIView.swift
//  
//
//  Created by Shane Stock on 2023-11-22.
//

import SwiftUI

struct MyRemindersView: View {
    @State private var showingSheet = false
    // @EnvironmentObject var wViewModel: WaterRemindersViewModel
    // @State private var selectedPlantId: UUID = MyRemindersView.initialPlantId()
    @EnvironmentObject var viewModel: UserPlantsViewModel
    @State private var selectedPlantId: UUID?
    @State private var selectedPlantIdString: String = ""

    static func initialPlantId() -> UUID {
        return plants.first!.id
    }

    static func initialUserPlantNoNotification(viewModel: UserPlantsViewModel) -> UUID? {
        for i in viewModel.userPlants {
            if i.waterReminder == false {
                return i.id
            }
        }
        return nil
    }

    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            VStack {
                Text("My Reminders")
                    .font(.title)
                    .foregroundStyle(.white)
                Button("Request Permission") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
                Button("Cancel All Notifs") {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
                List {
                    ForEach(viewModel.userPlants) { userPlant in
                        if userPlant.waterReminder == true {
                            HStack {
                                Image(userPlant.plant.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                Text(userPlant.plant.name)
                                Spacer()
                                Button(action: {
                                    if let index = viewModel.userPlants.firstIndex(where: { $0.id == userPlant.id }) {
                                        viewModel.userPlants[index].waterReminder = false
                                    } else {
                                        print("Plant not found")
                                    }
                                }) {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                if MyRemindersView.initialUserPlantNoNotification(viewModel: viewModel) != nil {
                    Button(action: {
                        selectedPlantId = MyRemindersView.initialUserPlantNoNotification(viewModel: viewModel)
                        selectedPlantIdString = selectedPlantId!.uuidString
                        self.showingSheet = true
                    }) {
                        Text("Add Reminder")
                            .foregroundColor(Color("Content"))
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                NavigationView {
                    VStack {
                        Text("Select a plant to create a reminder for")
                            .font(.title)
                            .foregroundColor(Color("Content"))
                        if viewModel.userPlants.count != 0 {
                            Picker("Your Plants", selection: $selectedPlantIdString) {
                                ForEach(viewModel.userPlants) { userPlant in
                                    if userPlant.waterReminder == false {
                                        Text(userPlant.plant.name).tag(userPlant.id.uuidString)
                                    }
                                }
                            }
                            Button("Add") {
                                if let index = viewModel.userPlants.firstIndex(where: { $0.id.uuidString == selectedPlantIdString }) {
                                    viewModel.userPlants[index].waterReminder = true

                                    let content = UNMutableNotificationContent()
                                    content.title = "Water your \(viewModel.userPlants[index].plant.name)"
                                    content.subtitle = "It's time to water your \(viewModel.userPlants[index].plant.name)"
                                    content.sound = UNNotificationSound.default

                                    // show this notification five seconds from now
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((viewModel.userPlants[index].daysWaterFrequency * 60)), repeats: true)

                                    // choose a random identifier
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                    // add our notification request
                                    UNUserNotificationCenter.current().add(request)

                                    showingSheet = false
                                } else {
                                    print("Plant not found")
                                }

                            }
                        }
                        else {
                            Text("You have no plants to create a reminder for")
                                .foregroundColor(Color("Content"))
                        }

                        Button("Cancel") {
                            showingSheet = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyRemindersView()
}
