//
//  EditProfileViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 16.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var name: String = ""
    var email: String = ""
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        profileImage.image = image
        nameTextField.text = name
        emailTextField.text = email
        
        nameTextField.delegate = self
        
        saveChangesButton.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(changeImageButtonTapped), for: .touchUpInside)
    }
    

    @objc func saveChangesButtonTapped() {
        if let name = nameTextField.text {
            db.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["name": name])
        }
        saveImageLocally(profileImage.image!)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeImageButtonTapped() {
        present(imagePicker, animated: true)
    }
    
    func saveImageLocally(_ image: UIImage) {
        guard let data = image.pngData(), let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let path = directory.appendingPathComponent("image-\(Auth.auth().currentUser!.uid).png")
        
        do {
            try data.write(to: path)
        } catch {
            print("Ошибка записи картинки: \(error)")
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage.image = selectedImage
        self.dismiss(animated: true)
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
