//
//  ViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    
    static let formatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewController.formatter.numberStyle = .currency
        ViewController.formatter.currencySymbol = ""
        ViewController.formatter.maximumFractionDigits = 0
        ViewController.formatter.locale = Locale.current
    
        if !isNewUser() {
            performSegue(withIdentifier: "toMainScreen", sender: self)
        } else {
            setIsNotNewUser()
        }
    }
    
    func isNewUser() -> Bool {
        return !userDefault.bool(forKey: "isNewUser")
    }
        
    func setIsNotNewUser() {
        userDefault.set(true, forKey: "isNewUser")
    }
}

