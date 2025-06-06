//
//  AllViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit

class AllViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sortedPlaces: [Place] = Places.locations
    var selectedPlace: Place = Places.locations[0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = sortedPlaces[0].placeType.rawValue
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceType" {
            let destinationVC = segue.destination as! PlaceViewController
            destinationVC.place = selectedPlace
        }
    }
}

extension AllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlace = sortedPlaces[indexPath.row]
        performSegue(withIdentifier: "showPlaceType", sender: self)
    }
}

extension AllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCollectionViewCell
        
        let place = sortedPlaces[indexPath.row]
        
        cell.layer.cornerRadius = 20
        cell.placeName.layer.cornerRadius = cell.placeName.frame.height / 2
        cell.placeRating.layer.cornerRadius = cell.placeRating.frame.height / 2
        cell.placeName.clipsToBounds = true
        cell.placeRating.clipsToBounds = true
        
        cell.placeImage.image = UIImage(named: place.image)
        cell.placeName.text = place.name
        countRating(place: place, showReviews: false, completion: { rating in
            cell.placeRating.text = rating
        })
        
        if favorites.contains(place) {
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            cell.favoriteAction = {
                favorites.remove(at: favorites.firstIndex(of: place)!)
                collectionView.reloadData()
            }
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.favoriteAction = {
                favorites.append(place)
                collectionView.reloadData()
                if favorites.count > 4 && !rewards.contains( "wanderList") {
                    rewards.append("wanderList")
                    
                    self.showAlert(title: "Horray!", message: "You have achieved a new reward: Wander List!")
                }
            }
        }
        
        return cell
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension AllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 191, height: 250)
    }
}
