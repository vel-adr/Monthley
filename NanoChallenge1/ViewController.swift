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
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.formatter.numberStyle = .currency
        ViewController.formatter.currencySymbol = ""
        ViewController.formatter.maximumFractionDigits = 0
        ViewController.formatter.locale = Locale.current
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isNewUser() {
            let sb1 = UIStoryboard(name: "MainScreenStoryboard", bundle: nil)
            let vc1 = sb1.instantiateViewController(withIdentifier: "mainScreenStoryboard")
            present(vc1, animated: true)
        }
    }
    
    func isNewUser() -> Bool {
        return !userDefault.bool(forKey: "isNewUser")
    }
}

