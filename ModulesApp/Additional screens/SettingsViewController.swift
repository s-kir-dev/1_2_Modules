//
//  SettingsViewController.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 17.05.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var boxView2: UIView!
    @IBOutlet weak var boxView3: UIView!
    
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var systemSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boxView.layer.cornerRadius = 20
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.systemGray.cgColor
        
        boxView2.layer.cornerRadius = 20
        boxView2.layer.borderWidth = 1
        boxView2.layer.borderColor = UIColor.systemGray.cgColor
        
        boxView3.layer.cornerRadius = 20
        boxView3.layer.borderWidth = 1
        boxView3.layer.borderColor = UIColor.systemGray.cgColor
        
        setupMenu()
    }
    
    func setupMenu() {
        let russianLanguage = UIAction(title: "Русский") { _ in
            //self.languageButton.setTitle( "Русский", for: .normal)
            self.setLanguage("ru")
        }
        
        let englishLanguage = UIAction(title: "English") { _ in
            //self.languageButton.setTitle( "English", for: .normal)
            self.setLanguage("en")
        }
        
        let menu = UIMenu(title: "Choose language", children: [russianLanguage, englishLanguage])
        
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
    }
    
    func setLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: "Language changed", message: "Restart app to apply changes", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
