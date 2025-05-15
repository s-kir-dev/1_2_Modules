//
//  AuthViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incorrectEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var incorrectPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var changeAuth: UIButton!
    @IBOutlet weak var dontHaveAccount: UILabel!
    
    var signUp: Bool = false {
        didSet {
            authButton.setTitle(signUp ? "Sign Up" : "Login" , for: .normal)
            changeAuth.isHidden = true
            dontHaveAccount.isHidden = true
            incorrectEmailLabel.isHidden = true
            incorrectPasswordLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incorrectEmailLabel.isHidden = true
        incorrectPasswordLabel.isHidden = true

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        changeAuth.addTarget(self, action: #selector(changeAuthTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
    }
    
    @objc func authButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if validateEmail() && validatePassword() {
            if signUp {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let _ = error {
                        self.showAlert(title: "Ошибка!", message: "Такой пользователь уже существует.")
                    } else if let result = result {
                        db.child("users").child(result.user.uid).setValue([
                            "email": email,
                            "password": password,
                            "name": "name"
                        ])
                        //загружать фавориты
                        //загружать награды
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let _ = error {
                        self.showAlert(title: "Ошибка!", message: "Такого аккаунта еще не существует.")
                    } else if let _ = result {
                        //загружать фавориты
                        //загружать награды
                    }
                }
            }
        }
        if !validateEmail() {
            incorrectEmailLabel.isHidden = false
        } else {
            incorrectEmailLabel.isHidden = true
        }
        
        if !validatePassword() {
            incorrectPasswordLabel.isHidden = false
        } else {
            incorrectPasswordLabel.isHidden = true
        }
    }
    
    @objc func forgotPasswordTapped() {
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    
    @objc func changeAuthTapped() {
        signUp.toggle()
    }

    func validateEmail() -> Bool {
       guard let email = emailTextField.text else { return false }
        let emailRegex = "^[A-Za-z0-9._%+-]+@[a-z0-9]+\\.[a-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword() -> Bool {
        guard let password = passwordTextField.text else { return false }
        return password.count >= 6
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Oк", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgotPassword" {
            guard let destination = segue.destination as? ForgotPasswordViewController else { return }
            destination.email = emailTextField.text!
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
