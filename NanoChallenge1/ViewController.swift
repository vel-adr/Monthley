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
        // Do any additional setup after loading the view.
        ViewController.formatter.numberStyle = .currency
        ViewController.formatter.currencySymbol = ""
        ViewController.formatter.maximumFractionDigits = 0
        ViewController.formatter.locale = Locale.current
    }
    
    override func viewDidLayoutSubviews() {
        if !isNewUser() {
            let vc = UIStoryboard(name: "MainScreenStoryboard", bundle: nil).instantiateViewController(withIdentifier: "mainScreenStoryboard") as? MainScreenViewController
            present(vc!, animated: true)
        } else {
            setIsNotNewUser()
        }
    }
    
    @IBAction func getStartedButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateBudget", sender: self)
    }
    
    func isNewUser() -> Bool {
        return !userDefault.bool(forKey: "isNewUser")
    }
        
    func setIsNotNewUser() {
        userDefault.set(true, forKey: "isNewUser")
    }
}

