//
//  SwiftUIView.swift
//  
//
//  Created by Shane Stock on 2023-11-22.
//

import SwiftUI

struct GardenView: View {
    @State private var selectedItem: String? // Replace String with your item type
    @State private var showingSheet = false
    @State private var selectedPlantId: UUID = GardenView.initialPlantId()
    @EnvironmentObject var viewModel: UserPlantsViewModel

    static func initialPlantId() -> UUID {
        return plants.first!.id
    }

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        ZStack {
            Color("BG")
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Image("GBed")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 375, height: 300)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .opacity(0.5)
                        )
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.userPlants) { userPlant in
                            Button(action: {
                                selectedItem = userPlant.id.uuidString
                            }) {
                                ZStack {
                                    Image(userPlant.plant.image)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                    Circle()
                                        .stroke(lineWidth: 4)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color("ContentS2"))
                                }
                            }
                        }
                        if viewModel.userPlants.count < 6 {
                            Button(action: {
                                selectedPlantId = GardenView.initialPlantId()
                                self.showingSheet = true
                            }) {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 4)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color("ContentS2"))
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("ContentS2"))
                                }
                            }
                        }
                    }
                    .padding()
                }
                List {
                    Text("Selected item: " + (viewModel.userPlants.first(where: { $0.id.uuidString == selectedItem})?.plant.name ?? "No item selected"))
                    Text("Planted on: " + (viewModel.userPlants.first(where: { $0.id.uuidString == selectedItem})?.plantDate.formatted(.dateTime.day().month().year()) ?? "No item selected"))
                    Text(viewModel.userPlants.first(where: { $0.id.uuidString == selectedItem})?.plant.description ?? "No item selected")
                    Button(action: {
                        viewModel.userPlants.removeAll(where: { $0.id.uuidString == selectedItem })
                    }) {
                        Text("Remove")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .sheet(isPresented: $showingSheet) {
                NavigationView {
                    VStack {
                        Text("Select a plant to add")
                        Picker("Plants", selection: $selectedPlantId) {
                            ForEach(plants) { Plant in
                                Text(Plant.name).tag(Plant.id)
                            }
                        }
                        Button("Add") {
                            viewModel.userPlants.append(UserPlant(plant: plants.first(where: { $0.id == selectedPlantId })!, plantDate: Date()))
                            showingSheet = false
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
    GardenView()
}

