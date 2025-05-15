//
//  HomeViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recommendedCollection: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var sortedPlaces: [Place] = Places.locations
    var selectedPlace: Place = Places.locations[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find things to do"
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        recommendedCollection.delegate = self
        recommendedCollection.dataSource = self
        
        seeAllButton.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            sortedPlaces = Places.locations
        case 1:
            sortedPlaces = Places.hotels
        case 2:
            sortedPlaces = Places.food
        case 3:
            sortedPlaces = Places.adventure
        default:
            sortedPlaces = Places.locations
        }
        collectionView.reloadData()
    }
    
    @objc func seeAllTapped() {
        performSegue(withIdentifier: "seeAll", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlace" {
            guard let destination = segue.destination as? PlaceViewController else { return }
            destination.place = selectedPlace
        } else if segue.identifier == "seeAll" {
            guard let destination = segue.destination as? AllViewController else { return }
            destination.sortedPlaces = sortedPlaces
        }
    }

}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlace = sortedPlaces[indexPath.row]
        performSegue(withIdentifier: "showPlace", sender: self)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return sortedPlaces.count
        } else {
            return recommended.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
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
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendedCollectionViewCell
            
            let recommended = recommended[indexPath.row]
            
            cell.layer.cornerRadius = 20
            cell.image.layer.cornerRadius = 20
            cell.image.clipsToBounds = true
            
            cell.image.image = UIImage(named: recommended.image)
            cell.imageType.image = UIImage(named: recommended.imageType)
            cell.nameLabel.text = recommended.name
            cell.typeLabel.text = recommended.type
            
            return cell
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 210, height: 273)
        } else {
            return CGSize(width: 200, height: 160)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty {
            sortedPlaces = sortedPlaces.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                sortedPlaces = Places.locations
            case 1:
                sortedPlaces = Places.hotels
            case 2:
                sortedPlaces = Places.food
            case 3:
                sortedPlaces = Places.adventure
            default:
                sortedPlaces = Places.locations
            }
        }
        collectionView.reloadData()
    }
}
