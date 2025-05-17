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
        
        lightSwitch.addTarget(self, action: #selector(lightSwitchValueChanged), for: .valueChanged)
        darkSwitch.addTarget(self, action: #selector(darkSwitchValueChanged), for: .valueChanged)
        systemSwitch.addTarget(self, action: #selector(systemSwitchValueChanged), for: .valueChanged)
        
        if let savedTheme = UserDefaults.standard.value(forKey: "AppTheme") as? Int {
            changeTheme(UIUserInterfaceStyle(rawValue: savedTheme) ?? .unspecified)
        }
    }
    
    @objc func lightSwitchValueChanged() {
        changeTheme(.light)
    }
    
    @objc func darkSwitchValueChanged() {
        changeTheme(.dark)
    }
    
    @objc func systemSwitchValueChanged() {
        changeTheme(.unspecified)
    }
    
    func changeTheme(_ theme: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme
        }
        
        
        lightSwitch.setOn(theme == .light, animated: true)
        darkSwitch.setOn(theme == .dark, animated: true)
        systemSwitch.setOn(theme == .unspecified, animated: true)
        
        UserDefaults.standard.set(theme.rawValue, forKey: "AppTheme")
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
