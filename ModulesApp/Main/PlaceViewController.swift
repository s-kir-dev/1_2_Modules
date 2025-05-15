//
//  PlaceViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    var place: Place = Places.locations[0] 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = UIImage(named: place.image)
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
