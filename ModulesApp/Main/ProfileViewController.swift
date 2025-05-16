//
//  ProfileViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = loadImage()
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        

        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImage.image = loadImage()
        
        collectionView.reloadData()
        
        guard let user = Auth.auth().currentUser else { return }
        db.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snaphot in
            
            guard let value = snaphot.value as? [String: Any], let name = value["name"] as? String, let email = value["email"] as? String else { return }
            self.profileName.text = name
            self.profileEmail.text = email
        })
    }
    

    @objc func signOutButtonTapped() {
        do {
           try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    
    @objc func editProfileButtonTapped() {
        performSegue(withIdentifier: "editProfileVC", sender: self)
    }
    
    func loadImage() -> UIImage {
        guard let user = Auth.auth().currentUser, let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "person.crop.circle")!}
        
        let path = directory.appendingPathComponent("image-\(user.uid).png")
        
        if FileManager.default.fileExists(atPath: path.path), let data = try? Data(contentsOf: path), let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(systemName: "person.crop.circle")!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileVC" {
            let destinationVC = segue.destination as! EditProfileViewController
            if let name = profileName.text, let email = profileEmail.text, let image = profileImage.image {
                destinationVC.email = email
                destinationVC.name = name
                destinationVC.image = image
            }
        }
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2 , height: collectionView.frame.width / 2.2)
    }
}


extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RewardsCollectionViewCell
        
        cell.rewardImage.image = UIImage(named: rewards[indexPath.row])
        
        return cell
    }
    
    
}
