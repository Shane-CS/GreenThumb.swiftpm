//
//  File.swift
//  
//
//  Created by Shane Stock on 2023-11-22.
//

import Foundation
import SwiftUI

// App Data Structures

struct PlantCare: Hashable, Codable {
    enum Water: String, Codable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case regularly = "Regularly"
    }
    enum Sunlight: String, Codable {
        case fullSun = "Full Sun"
        case partialSun = "Partial Sun"
        case partialShade = "Partial Shade"
        case fullShade = "Full Shade"
    }
    enum Temperature: String, Codable {
        case cold = "Cold"
        case cool = "Cool"
        case warm = "Warm"
        case hot = "Hot"
    }
    enum Humidity: String, Codable {
        case dry = "Dry"
        case average = "Average"
        case humid = "Humid"
    }
    enum Fertilizer: String, Codable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    enum Soil: String, Codable {
        case clay = "Clay"
        case sandy = "Sandy"
        case loamy = "Loamy"
        case silty = "Silty"
        case peaty = "Peaty"
        case chalky = "Chalky"
    }
    enum Pests: String, Codable {
        case aphids = "Aphids"
        case mealybugs = "Mealybugs"
        case spiderMites = "Spider Mites"
        case thrips = "Thrips"
        case whiteflies = "Whiteflies"
        case carrotFly = "Carrot Fly"
        case squashBugs = "Squash Bugs"
        case cabbageFly = "Cabbage Fly"
        case onionFly = "Onion Fly"
    }
    enum Diseases: String, Codable {
        case powderyMildew = "Powdery Mildew"
        case rootRot = "Root Rot"
        case rust = "Rust"
        case leafSpot = "Leaf Spot"
        case botrytis = "Botrytis"
        case blight = "Blight"
        case mildew = "Mildew"
        case mosaicVirus = "Mosaic Virus"
        case wilt = "Wilt"
        case rot = "Rot"
        case clubroot = "Clubroot"
        case bacterialSpot = "Bacterial Spot"
    }
    enum Harvest: String, Codable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
    }
    enum Pruning: String, Codable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
        case notNeeded = "Not Needed"
    }
    enum Propagation: String, Codable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
    }
    let water: Water
    let sunlight: Sunlight
    let temperature: Temperature
    let humidity: Humidity
    let fertilizer: Fertilizer
    let soil: Soil
    let pests: Pests
    let diseases: Diseases
    let harvest: Harvest
    let pruning: Pruning
    let propagation: Propagation
}

struct Plant: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var image: String
    var care: PlantCare
    var notes: String
}

struct Garden: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var plants: [Plant]
}

struct WaterReminder: Identifiable {
    var id = UUID()
    let plant: UserPlant
    var days_frequency: Int {
        switch plant.plant.care.water {
        case .daily:
            return 1
        case .weekly:
            return 7
        case .monthly:
            return 30
        case .regularly:
            return 3
        }
    }
}

struct WeatherDataStructure: Identifiable {
    var id = UUID()
    var temperature: String
    var condition: String
    var upcoming_temp: [String]
    var upcoming_condition: [String]
    var currentIcon: String {
        switch condition {
        case "Sunny":
            return "sun.max.fill"
        case "Cloudy":
            return "cloud.fill"
        case "Rainy":
            return "cloud.rain.fill"
        case "Snowy":
            return "snow"
        default:
            return "sun.max.fill"
        }
    }
    var upcomingIcons: [String] {
        var icons: [String] = []
        for condition in upcoming_condition {
            switch condition {
            case "Sunny":
                icons.append("sun.max.fill")
            case "Cloudy":
                icons.append("cloud.fill")
            case "Rainy":
                icons.append("cloud.rain.fill")
            case "Snowy":
                icons.append("snow")
            default:
                icons.append("sun.max.fill")
            }
        }
        return icons
    }
}

struct GardeningTipsDataTipStructure: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let tip: String
}

struct UserPlant: Identifiable, Codable {
    var id = UUID()
    let plant: Plant
    let plantDate: Date
    var waterReminder = false

    // Don't try to encode or decode daysWaterFrequency
    enum CodingKeys: CodingKey {
        case id, plant, plantDate, waterReminder
    }

    // Computed property for water frequency
    var daysWaterFrequency: Int {
        switch plant.care.water {
        case .daily:
            return 1
        case .weekly:
            return 7
        case .monthly:
            return 30
        case .regularly:
            return 3
        }
    }
}

// App Data

let plants = [
    Plant(name: "Aloe Vera", description: "Aloe vera is a succulent plant species of the genus Aloe. An evergreen perennial, it originates from the Arabian Peninsula, but grows wild in tropical, semi-tropical, and arid climates around the world. It is cultivated for agricultural and medicinal uses.", image: "AloeVera", care: PlantCare(water: .weekly, sunlight: .fullSun, temperature: .warm, humidity: .dry, fertilizer: .monthly, soil: .sandy, pests: .mealybugs, diseases: .rootRot, harvest: .summer, pruning: .spring, propagation: .spring), notes: "Notes"),
    Plant(name: "Basil", description: "Basil, also called great basil, is a culinary herb of the family Lamiaceae. Basil is native to tropical regions from central Africa to Southeast Asia. It is a tender plant, and is used in cuisines worldwide.", image: "Basil", care: PlantCare(water: .daily, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .weekly, soil: .sandy, pests: .aphids, diseases: .powderyMildew, harvest: .summer, pruning: .summer, propagation: .summer), notes: "Notes"),
    Plant(name: "Cactus", description: "A cactus is a member of the plant family Cactaceae, a family comprising about 127 genera with some 1750 known species of the order Caryophyllales. The word cactus derives, through Latin, from the Ancient Greek κάκτος, kaktos, a name originally used by Theophrastus for a spiny plant whose identity is now not certain.", image: "Cactus", care: PlantCare(water: .monthly, sunlight: .fullSun, temperature: .hot, humidity: .dry, fertilizer: .monthly, soil: .sandy, pests: .mealybugs, diseases: .rootRot, harvest: .summer, pruning: .spring, propagation: .spring), notes: "Notes"),
    Plant(name: "Tomato", description: "The tomato is the edible berry of the plant Solanum lycopersicum, commonly known as a tomato plant. The species originated in western South America and Central America.", image: "Tomato", care: PlantCare(water: .daily, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .weekly, soil: .loamy, pests: .aphids, diseases: .blight, harvest: .summer, pruning: .summer, propagation: .spring), notes: "Notes"),
    Plant(name: "Cucumber", description: "Cucumbers are a type of edible plant that belongs to the gourd family. They are high in water and low in calories, fat, cholesterol, and sodium.", image: "Cucumber", care: PlantCare(water: .daily, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .weekly, soil: .loamy, pests: .aphids, diseases: .mildew, harvest: .summer, pruning: .summer, propagation: .spring), notes: "Notes"),
    Plant(name: "Lettuce", description: "Lettuce is an annual plant of the daisy family, Asteraceae. It is most often grown as a leaf vegetable, but sometimes for its stem and seeds.", image: "Lettuce", care: PlantCare(water: .daily, sunlight: .partialSun, temperature: .cool, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .aphids, diseases: .rot, harvest: .spring, pruning: .spring, propagation: .spring), notes: "Notes"),
    Plant(name: "Spinach", description: "Spinach is a leafy green flowering plant native to central and western Asia. It is of the order Caryophyllales, family Amaranthaceae, subfamily Chenopodioideae.", image: "Spinach", care: PlantCare(water: .daily, sunlight: .partialSun, temperature: .cool, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .aphids, diseases: .mildew, harvest: .spring, pruning: .spring, propagation: .spring), notes: "Notes"),
    Plant(name: "Carrots", description: "Carrots are root vegetables, usually orange in color, though purple, black, red, white, and yellow cultivars exist. They are a domesticated form of the wild carrot, Daucus carota, native to Europe and southwestern Asia.", image: "Carrots", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .cool, humidity: .average, fertilizer: .monthly, soil: .sandy, pests: .carrotFly, diseases: .rootRot, harvest: .fall, pruning: .notNeeded, propagation: .spring), notes: "Notes"),
    Plant(name: "Zucchini", description: "Zucchini, also known as courgette, is a summer squash in the Cucurbitaceae plant family, which includes melons, spaghetti squash, and cucumbers. It can grow to more than 1 metre (40 inches), but is usually harvested when still immature at about 15 to 25 cm (6 to 10 in).", image: "Zucchini", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .squashBugs, diseases: .powderyMildew, harvest: .summer, pruning: .summer, propagation: .spring), notes: "Notes"),
    Plant(name: "Peppers", description: "Peppers are members of the nightshade family. They are closely related to tomatoes and come in a variety of colors, including green, red, yellow, and orange. They are grown worldwide and are commonly used in cooking.", image: "Peppers", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .aphids, diseases: .bacterialSpot, harvest: .summer, pruning: .summer, propagation: .spring), notes: "Notes"),
    Plant(name: "Beans", description: "Beans are a type of pulse, a term used to describe the edible seeds of leguminous plants. They are one of the longest-cultivated plants in the world, and are high in protein, fiber, and various vitamins and minerals.", image: "Beans", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .warm, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .aphids, diseases: .rust, harvest: .summer, pruning: .summer, propagation: .spring), notes: "Notes"),
    Plant(name: "Radishes", description: "Radishes are a group of root vegetables with sharp, pungent flavors. They come in a variety of colors including white, red, purple, and black. They are eaten raw, cooked or pickled.", image: "Radishes", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .cool, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .cabbageFly, diseases: .clubroot, harvest: .spring, pruning: .notNeeded, propagation: .spring), notes: "Notes"),
    Plant(name: "Onions", description: "Onions are a staple in many kitchens and have been used for thousands of years for their therapeutic properties. They are easy to grow and can be grown in a variety of climates.", image: "Onions", care: PlantCare(water: .regularly, sunlight: .fullSun, temperature: .cool, humidity: .average, fertilizer: .monthly, soil: .loamy, pests: .onionFly, diseases: .blight, harvest: .summer, pruning: .notNeeded, propagation: .spring), notes: "Notes")
]

// Demo Data

let GardeningTipsData: [GardeningTipsDataTipStructure] = [
    GardeningTipsDataTipStructure(title: "Water Lots!", tip: "Water your plants as much as you can!"),
    GardeningTipsDataTipStructure(title: "Pick the Right Soil", tip: "Make sure you pick the right soil for your plants!"),
    GardeningTipsDataTipStructure(title: "Prune Your Plants", tip: "Prune your plants to keep them healthy!"),
    GardeningTipsDataTipStructure(title: "Fertilize Your Plants", tip: "Fertilize your plants to keep them healthy!"),
    GardeningTipsDataTipStructure(title: "Keep Your Plants Warm", tip: "Keep your plants warm to keep them healthy!"),
    GardeningTipsDataTipStructure(title: "Keep Your Plants Cool", tip: "Keep your plants cool to keep them healthy!"),
    GardeningTipsDataTipStructure(title: "Keep Your Plants in the Sun", tip: "Keep your plants in the sun to keep them healthy!"),
    GardeningTipsDataTipStructure(title: "Compost Regularly", tip: "Composting can provide valuable nutrients for your plants!"),
    GardeningTipsDataTipStructure(title: "Choose Native Plants", tip: "Native plants are more likely to thrive in your garden!"),
    GardeningTipsDataTipStructure(title: "Rotate Your Crops", tip: "Crop rotation can help prevent soil depletion and pests!"),
    GardeningTipsDataTipStructure(title: "Use Mulch", tip: "Mulch can help retain soil moisture and suppress weeds!"),
    GardeningTipsDataTipStructure(title: "Avoid Overwatering", tip: "Too much water can be as harmful as too little!"),
    GardeningTipsDataTipStructure(title: "Plant in Raised Beds", tip: "Raised beds can improve drainage and ease back strain!"),
    GardeningTipsDataTipStructure(title: "Use Natural Pesticides", tip: "Natural pesticides can be less harmful to the environment!"),
    GardeningTipsDataTipStructure(title: "Plant Perennials", tip: "Perennials can provide beauty year after year!"),
    GardeningTipsDataTipStructure(title: "Group Similar Plants", tip: "Grouping plants with similar needs can make care easier!"),
    GardeningTipsDataTipStructure(title: "Use Quality Tools", tip: "Quality gardening tools can make your work easier and more efficient!"),
    GardeningTipsDataTipStructure(title: "Plant in Succession", tip: "Succession planting can ensure a steady harvest!"),
    GardeningTipsDataTipStructure(title: "Attract Beneficial Insects", tip: "Certain plants can attract insects that help control pests!"),
    GardeningTipsDataTipStructure(title: "Test Your Soil", tip: "Knowing your soil type can help you choose the right plants!"),
    GardeningTipsDataTipStructure(title: "Provide Support for Climbing Plants", tip: "Trellises or stakes can help climbing plants grow better!"),
    GardeningTipsDataTipStructure(title: "Use Organic Fertilizer", tip: "Organic fertilizers can enrich your soil without harmful chemicals!"),
    GardeningTipsDataTipStructure(title: "Practice Crop Rotation", tip: "Crop rotation can help prevent soil-borne diseases and pests!"),
    GardeningTipsDataTipStructure(title: "Control Weeds", tip: "Regular weeding can prevent competition for resources!"),
    GardeningTipsDataTipStructure(title: "Harvest Regularly", tip: "Regular harvesting can encourage further production!"),
    GardeningTipsDataTipStructure(title: "Use Companion Planting", tip: "Companion planting can help deter pests and improve growth!"),
    GardeningTipsDataTipStructure(title: "Water in the Morning", tip: "Watering in the morning can prevent fungal diseases!"),
    GardeningTipsDataTipStructure(title: "Use Vertical Space", tip: "Vertical gardening can save space and increase yield!"),
    GardeningTipsDataTipStructure(title: "Plant in Containers", tip: "Container gardening can be a great option for small spaces!"),
    GardeningTipsDataTipStructure(title: "Protect from Frost", tip: "Protecting plants from frost can extend your growing season!")
]

// let WeatherData = WeatherDataStructure(temperature: "20", condition: "Sunny", upcoming_temp: ["20", "21", "22"], upcoming_condition: ["Sunny", "Sunny", "Sunny"])
let WeatherData = WeatherDataStructure(temperature: "10", condition: "Cloudy", upcoming_temp: ["10", "11", "12"], upcoming_condition: ["Cloudy", "Cloudy", "Cloudy"])

class UserPlantsViewModel: ObservableObject {
    @Published var userPlants: [UserPlant] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(userPlants) {
                UserDefaults.standard.set(encoded, forKey: "UserPlants")
            }
        }
    }

    init() {
        if let userPlants = UserDefaults.standard.data(forKey: "UserPlants") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([UserPlant].self, from: userPlants) {
                self.userPlants = decoded
                return
            }
        }
        self.userPlants = []
    }
}

// class WaterRemindersViewModel: ObservableObject {
//     @Published var waterReminders: [WaterReminder] = []
// }
