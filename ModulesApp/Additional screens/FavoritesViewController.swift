//
//  FavoritesViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 16.05.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sorryLabel: UILabel!
    @IBOutlet weak var learnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        tableIsEmpty()
    }
    
    
    func tableIsEmpty() {
        if favorites.isEmpty {
            sorryLabel.isHidden = false
            learnLabel.isHidden = false
        } else {
            sorryLabel.isHidden = true
            learnLabel.isHidden = true
        }
    }

}


extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceTableViewCell
        
        let place = favorites[indexPath.row]
        
        cell.placeImage.image = UIImage(named: place.image)
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.placeType.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            favorites.remove(at: indexPath.row)
            uploadFavorites()
            self.tableIsEmpty()
            tableView.reloadData()
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
