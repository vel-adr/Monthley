//
//  ViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    static let formatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewController.formatter.numberStyle = .currency
        ViewController.formatter.currencySymbol = ""
        ViewController.formatter.maximumFractionDigits = 0
        ViewController.formatter.locale = Locale.current
        
    }


}

