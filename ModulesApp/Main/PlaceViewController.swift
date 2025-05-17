//
//  PlaceViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit
import FirebaseAuth

class PlaceViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var floatLabel: UILabel!
    @IBOutlet weak var floatLabelValue: UILabel!
    @IBOutlet weak var facilitiesView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var firstStar: UIButton!
    @IBOutlet weak var secondStar: UIButton!
    @IBOutlet weak var thirdStar: UIButton!
    @IBOutlet weak var fourthStar: UIButton!
    @IBOutlet weak var fifthStar: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var beenButton: UIButton!
    
    var stars: [UIButton] = []
    
    var place: Place = Places.locations[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        stars = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        
        for star in stars {
            star.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
        }
        
        setupUI(place: place)
                
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        beenButton.addTarget(self, action: #selector(beenButtonTapped), for: .touchUpInside)
        
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func beenButtonTapped() {
        db.child("places").child(place.name).observeSingleEvent(of: .value, with: { snapshot in
            var visitors = 0
            
            if let value = snapshot.value as? [String: Any],
               let visitorsCount = value["visitors"] as? Int {
                visitors = visitorsCount
            }
            
            if beenPlaces.contains(self.place) {
                self.beenButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
                if let index = beenPlaces.firstIndex(of: self.place) {
                    beenPlaces.remove(at: index)
                }
                visitors -= 1
            } else {
                if !rewards.contains("traiblazer") {
                    rewards.append("traiblazer")
                    self.showAlert(title: "Horray!".localize(), message: "You have achieved a new reward: Traiblazer!".localize())
                }
                
                beenPlaces.append(self.place)
                visitors += 1
                
                let summa = Places.adventure.count + Places.locations.count + Places.food.count + Places.hotels.count
                if beenPlaces.count == summa && !rewards.contains("maven") {
                    rewards.append("maven")
                    self.showAlert(title: "Horray!".localize(), message: "You have achieved a new reward: Minsk Maven! You are really cool person!".localize())
                }
                
                self.beenButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            }

            db.child("places").child(self.place.name).updateChildValues([
                "visitors": visitors
            ])

            uploadBeenPlaces()
            print(beenPlaces.count)
        })
    }
    
    @objc func readMoreButtonTapped() {
        let url = URL(string: "https://www.google.com/search?q=\(place.name)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не могу открыть ссылку", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oк", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    @objc func starTapped(_ sender: UIButton) {
        if let selectedIndex = stars.firstIndex(of: sender) {
            fillStars(int: selectedIndex)
        }
    }
    
    @objc func favoriteButtonTapped() {
        if favorites.contains(place) {
            favorites.remove(at: favorites.firstIndex(of: place)!)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favorites.append(place)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        if favorites.count > 4 && !rewards.contains( "wanderList") {
            rewards.append("wanderList")
            
            showAlert(title: "Horray!".localize(), message: "You have achieved a new reward: Wander List!".localize())
        }
    }
    
    @objc func rateButtonTapped() {
        countRating(place: place, showReviews: true, completion: { rating in
            self.placeRating.text = "\(rating)"
        })
        
        db.child("ratings").child(place.name).child(Auth.auth().currentUser!.uid).setValue([
            "myRate": place.myRate
        ])
    }
    
    func fillStars(int: Int) {
        var myRate = 0
        for (index, star) in stars.enumerated() {
            if index <= int {
                star.setImage(UIImage(systemName: "star.fill"), for: .normal)
                myRate += 1
            } else {
                star.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        place.myRate = myRate
    }
    
    func setMyRate() {
        db.child("ratings").child(place.name).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snaphot in
            guard let value = snaphot.value as? [String: Any], let myRate = value["myRate"] as? Int else { return }
            self.place.myRate = myRate
            self.fillStars(int: myRate - 1)
        })
    }
    

    func setupUI(place: Place) {
        image.image = UIImage(named: place.image)
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        
        if place.placeType == .hotels {
            infoView.isHidden = true
            facilitiesView.isHidden = false
        } else {
            infoView.isHidden = false
            facilitiesView.isHidden = true
        }
        
        if favorites.contains(place) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        placeName.text = place.name
        placeDescription.text = place.description
        
        countRating(place: place, showReviews: true, completion: { rating in
            self.placeRating.text = "\(rating)"
        })
        setMyRate()
        
        if beenPlaces.contains(place) {
            beenButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        } else {
            beenButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oк", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension PlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place.facilities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FacilityCollectionViewCell
        
        let facility = place.facilities[indexPath.row]
        
        cell.image.image = UIImage(systemName: "wifi")
        cell.name.text = facility.rawValue
        
        return cell
    }
    
    
}

extension PlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
}
