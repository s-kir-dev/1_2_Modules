//
//  Helper.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let startVC = storyboard.instantiateViewController(withIdentifier: "startVC") as! UIViewController
let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController

let db = Database.database().reference()


enum PlaceType: String, Codable {
    case locations = "Locations"
    case hotels = "Hotels"
    case food = "Food"
    case adventure = "Adventure"
}


enum Facilities: String, Codable {
    case wifi = "Wi-Fi"
    case parking = "Parking"
    case pool = "Pool"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case fitnessCenter = "Fitness center"
    case laundry = "Laundry"
    case parkingGarage = "Parking garage"
    case parkingLot = "Parking lot"
    case parkingOnSite = "Parking on-site"
    case parkingValet = "Parking valet"
}

struct Place: Codable, Equatable {
    let name: String
    let image: String
    let description: String
    let placeType: PlaceType
    let recommendedTime: String
    let address: String
    let phone: String
    let facilities: [Facilities]
    let budget: Int
    let openTime: String
    var rating: Double
    var myRate: Int
    let userID: String
    let documentID: String
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name
    }
}


struct Places: Codable {
    static var locations: [Place] = [
        Place(name: "Troitskoe suburb", image: "троицкое", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: "") ,
        Place(name: "National library", image: "библиотека", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Museum of the Great Patriotic War History", image: "музей ВОВ", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Bolshoy Theater of Belarus", image: "театр", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "National Art Museum", image: "музей искусства", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Komarovsky market", image: "комаровка", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", placeType: .locations, recommendedTime: "1-2 hours", address: "Lenina Street 20", phone: "+375-17-3970163", facilities: [], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: "")
    ]
    static var hotels: [Place] = [
        Place(name: "Mariott", image: "мариотт", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "DoubleTree by Hilton Hotel", image: "хилтон", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Minsk Hotel", image: "минск отель", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "President Hotel", image: "президент", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Hotel Victoria", image: "виктория", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Hotel Pekin", image: "пекин", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", placeType: .hotels, recommendedTime: "", address: "", phone: "", facilities: [.wifi, .bar, .fitnessCenter, .laundry], budget: 0, openTime: "", rating: 0, myRate: 0, userID: "", documentID: "")
    ]
    static var food: [Place] = [
        Place(name: "Zolotoy Grebeshok", image: "гребешок", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 29, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Ember", image: "эмбер", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 30, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Grand Cafe", image: "гранд", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 31, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Chainyi P", image: "чайный", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 28, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Pena Dney", image: "пена", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 32, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Restaurant Malevich", image: "малевич", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", placeType: .food, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phone: "+375-29-16-11-888", facilities: [], budget: 33, openTime: "", rating: 0, myRate: 0, userID: "", documentID: ""),
    ]
    static var adventure: [Place] = [
        Place(name: "Adventure Park", image: "парк развлечений", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Minsk Zoo", image: "зоопарк", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "ZipLine", image: "зиплайн", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Ninja Park", image: "ниндзя парк", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Avalon VR", image: "авалон", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: ""),
        Place(name: "Neurobox", image: "нейробокс", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", placeType: .adventure, recommendedTime: "", address: "Tashkentskaya St., 40", phone: "+375-17-345-32-65", facilities: [], budget: 0, openTime: "10:00-20:00", rating: 0, myRate: 0, userID: "", documentID: "")
    ]
}

struct Recommended {
    let name: String
    let image: String
    let imageType: String
    let type: String
}

var favorites: [Place] = []
var beenPlaces: [Place] = []
var recommended: [Recommended] = [
    Recommended(name: "Explore Minsk", image: "вокзал", imageType: "arrow", type: "Hot Deal"),
    Recommended(name: "Luxurious Minsk", image: "раубичи", imageType: "arrow", type: "Hot Deal"),
    Recommended(name: "Explore Minsk", image: "вокзал", imageType: "arrow", type: "Hot Deal"),
    Recommended(name: "Luxurious Minsk", image: "раубичи", imageType: "arrow", type: "Hot Deal")
]

func uploadFavorites() {
    if let encodedData = try? JSONEncoder().encode(favorites) {
        UserDefaults.standard.set(encodedData, forKey: "favorites-\(Auth.auth().currentUser!.uid)")
    }
}

func downloadFavorites() {
    if let data = UserDefaults.standard.data(forKey: "favorites-\(Auth.auth().currentUser!.uid)") {
        favorites = try! JSONDecoder().decode([Place].self, from: data)
    }
}


func uploadBeenPlaces() {
    if let encodedData = try? JSONEncoder().encode(beenPlaces) {
        UserDefaults.standard.set(encodedData, forKey: "beenPlaces-\(Auth.auth().currentUser!.uid)")
    }
}

func downloadBeenPlaces() {
    if let data = UserDefaults.standard.data(forKey: "beenPlaces-\(Auth.auth().currentUser!.uid)") {
        beenPlaces = try! JSONDecoder().decode([Place].self, from: data)
    }
}

func countRating(place: Place, showReviews: Bool, completion: @escaping((String)-> Void)) {
    var kolvo = 0
    var summa = 0
    
    db.child("ratings").child(place.name).observeSingleEvent(of: .value, with: { snaphot in
        
        let group = DispatchGroup()
        kolvo = Int(snaphot.childrenCount)
        
        for child in snaphot.children {
            group.enter()
            
            guard let childSnapshot = child as? DataSnapshot else { continue }
            db.child("ratings").child(place.name).child(childSnapshot.key).observeSingleEvent(of: .value, with: { snaphot in
                
                defer { group.leave() }
                
                guard let value = snaphot.value as? [String: Any], let myRate = value["myRate"] as? Int else { return }
                summa += myRate
            })
        }
        
        group.notify(queue: .main) {
            if kolvo > 0 {
                let rating = Double(summa)/Double(kolvo)
                let roundedRating = Double(rating*100).rounded()/100
                if showReviews {
                    completion("⭐️\(roundedRating) (\(kolvo)K Reviews)")
                } else {
                    completion("⭐️\(roundedRating)")
                }
            } else {
                if showReviews {
                    completion("⭐️0 (0K Reviews)")
                } else {
                    completion("⭐️0")
                }
            }
        }
    })
}


var rewards: [String] = [] {
    didSet {
        uploadRewards()
    }
}


func uploadRewards() {
    if let user = Auth.auth().currentUser {
        UserDefaults.standard.set(rewards, forKey: "rewards-\(user.uid)")
    }
}

func downloadRewards() {
    if let user = Auth.auth().currentUser {
        if let downloadedRewards = UserDefaults.standard.array(forKey: "rewards-\(user.uid)") as? [String] {
            rewards = downloadedRewards
        }
    }
}
