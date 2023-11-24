//
//  SwiftUIView.swift
//  
//
//  Created by Shane Stock on 2023-11-22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: UserPlantsViewModel
    @State private var showingTipSheet = false
    @State private var selectedTipNums: [Int] = Array(0...(GardeningTipsData.count-1)).shuffled().prefix(3).sorted()
    @State private var selectedTipId: UUID?
    @State private var selectedTip: GardeningTipsDataTipStructure?

    static func numReminders(viewModel: UserPlantsViewModel) -> Int {
        var numReminders = 0
        for i in viewModel.userPlants {
            if i.waterReminder == true {
                numReminders += 1
            }
        }
        return numReminders
    }

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        ScrollView {
            VStack {
                ZStack {
                    Image("GBed")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .opacity(0.5)
                        )
                    VStack {
                        Text("My Plants")
                        .font(.title)
                        .foregroundStyle(.white)
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.userPlants) { userPlant in
                                ZStack {
                                    Image(userPlant.plant.image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    Circle()
                                        .stroke(lineWidth: 4)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color("ContentS2"))
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(width: 350, height: 200) // Adjust the size to your needs
                    // .background(RoundedRectangle(cornerRadius: 4).fill(Color.blue))
                }
                VStack {
                    Text("My Reminders")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("ContentS1"))
                    if HomeView.numReminders(viewModel: viewModel) > 0 {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.userPlants) { userPlant in
                                if userPlant.waterReminder == true {
                                    VStack {
                                        ZStack {
                                            Image(userPlant.plant.image)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                            Circle()
                                                .stroke(lineWidth: 4)
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(Color("ContentS2"))
                                        }
                                        Text("Every \(userPlant.daysWaterFrequency) Days")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    else {
                        Text("No Reminders")
                    }
                }
                .frame(width: 350, height: 250)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("Feature")))
                HStack {
                    VStack {
                        Text("Current Weather")
                        Text("Temperature: \(WeatherData.temperature)") // Replace with your actual data
                        Text("Condition: \(WeatherData.condition)") // Replace with your actual data
                    }
                    Image(systemName: WeatherData.currentIcon)
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .frame(width: 350, height: 100) // Adjust the size to your needs
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("Feature")))

                VStack {
                    Text("Gardening Tips")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("ContentS1"))
                    VStack {
                        ForEach(selectedTipNums, id: \.self) { i in
                            Button(action: {
                                print(selectedTipNums)
                                selectedTipId = GardeningTipsData[i].id
                                showingTipSheet = true
                            }) {
                                Text(GardeningTipsData[i].title)
                                .font(Font.headline.weight(.medium))
                                Image(systemName: "info.circle")
                            }
                            .frame(width: 300, height: 20)
                            .foregroundColor(Color("ContentS2"))
                        }
                    }
                }
                .frame(width: 350, height: 150) // Adjust the size to your needs
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("Feature")))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Rectangle()
            .foregroundColor(Color("BG")))
        .sheet(isPresented: $showingTipSheet) {
            NavigationView {
                VStack {
                    Text("Tip")
                    Text(selectedTip?.title ?? "No tip selected")
                    Text(selectedTip?.tip ?? "No tip selected")
                    Button("Close") {
                        showingTipSheet = false
                    }
                }
            }
            .onAppear {
                if let tipId = selectedTipId {
                    selectedTip = GardeningTipsData.first(where: {$0.id == tipId})
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
