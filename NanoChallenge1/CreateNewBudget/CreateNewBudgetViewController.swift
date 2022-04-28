//
//  CreateNewBudgetViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit

class CreateNewBudgetViewController: UIViewController {
    
    let formatter = ViewController.formatter
    var amount = 0
    
    @IBOutlet weak var budgetTextField: TextFieldWithPadding!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set placeholder of textfield
        budgetTextField.placeholder = formatter.string(from: NSNumber(value: 2000000)) ?? "-"
        
        //Set presentation height
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMainScreen", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainScreen" {
            let destinationVC = segue.destination as? MainScreenViewController
            let budget = budgetTextField.text
            destinationVC?.totalBudget = Int(CFStringGetIntValue(budget as CFString?))
        }
    }
}

extension CreateNewBudgetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var amountTyped = 0
        
        if string.count > 0 {
            amountTyped = Int(string) ?? 0
            let newAmount = formatter.string(from: NSNumber(value: amountTyped))
            textField.text = newAmount
        }
        
        return false
    }
}

//Cara 3 nambahin bottom border TextField (https://stackoverflow.com/a/41291113)

//extension TextFieldWithPadding {
//  func setBottomBorder() {
//    self.borderStyle = .none
//    self.layer.backgroundColor = UIColor.white.cgColor
//
//    self.layer.masksToBounds = false
//    self.layer.shadowColor = UIColor.gray.cgColor
//    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//    self.layer.shadowOpacity = 1.0
//    self.layer.shadowRadius = 0.0
//  }
//}

//    budgetTextField.setBottomBorder() <---------------------- cara 3 dipanggil disini
