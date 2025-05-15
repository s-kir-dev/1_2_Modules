//
//  Helper.swift
//  ModulesApp
//
//  Created by Кирилл Сысоев on 15.05.2025.
//

import Foundation
import UIKit
import FirebaseDatabase

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let startVC = storyboard.instantiateViewController(withIdentifier: "startVC") as! UIViewController
let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController

let db = Database.database().reference()
