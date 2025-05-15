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
    }
    
    @objc func starTapped(_ sender: UIButton) {
        if let selectedIndex = stars.firstIndex(of: sender) {
            fillStars(int: selectedIndex)
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
        
        placeName.text = place.name
        countRating(place: place, showReviews: true, completion: { rating in
            self.placeRating.text = "\(rating)"
        })
        setMyRate()
        
        placeRating.text = place.description
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
