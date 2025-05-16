//
//  ForgotPasswordViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incorrectEmailLabel: UILabel!
    @IBOutlet weak var sendEmail: UIButton!
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = email
        emailTextField.delegate = self
        
        incorrectEmailLabel.isHidden = true
        
        sendEmail.addTarget(self, action: #selector(sendEmailAction), for: .touchUpInside)
    }
    
    @objc func sendEmailAction() {
        guard validateEmail(), let email = emailTextField.text else {
            incorrectEmailLabel.isHidden = false
            print("Не отправил")
            return
        }
        incorrectEmailLabel.isHidden = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Не отправил")
                print("Ошибка: \(error)")
            } else {
                print("Отправил")
                self.dismiss(animated: true)
            }
        }
    }

    func validateEmail() -> Bool {
       guard let email = emailTextField.text else { return false }
        let emailRegex = "^[A-Za-z0-9.]+\\@[a-z]+\\.[a-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
