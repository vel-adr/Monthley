//
//  CreateNewBudgetViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit

class CreateNewBudgetViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let formatter = ViewController.formatter
    var separator: String?
    
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
        performSegue(withIdentifier: "toMainScreenFromBudget", sender: self)
    }
    
    //Replace inputted value to formatted string
    @IBAction func textFieldOnChange(_ sender: Any) {
        //Get extracted value of entered input
        let textFromTextField = budgetTextField.text ?? ""
        let separator = formatter.groupingSeparator ?? ""
        let extractedValue = Int(textFromTextField.replacingOccurrences(of: separator, with: ""))
        
        //Re-format and replace input text with new formatted string
        let formattedString = formatter.string(from: NSNumber(value: extractedValue ?? 0))
        budgetTextField.text = formattedString
    }
    
    //Validation before segueing to another view
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toMainScreenFromBudget" {
            //Check if textField is empty
            if budgetTextField.text?.isEmpty == true {
                let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be filled to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true)
                }))
                present(alert, animated: true, completion: nil)
                
                return false
            } else {
                let separator = formatter.groupingSeparator ?? ""
                let extractedString = budgetTextField.text?.replacingOccurrences(of: separator, with: "") ?? "-1"
                let budget = Int(extractedString) ?? -1
                
                //Check if inputted amount value is in range
                if budget <= 0 || budget > 999999999 {
                    let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be between 0 to 999.999.999", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true)
                    }))
                    present(alert, animated: true, completion: nil)
                    
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainScreenFromBudget" {
            let budget = Budget(context: context)
            
            //Extract value from formatted textfield string
            let formattedAmount = budgetTextField.text ?? ""
            let separator = formatter.groupingSeparator ?? ""
            let extractedString = formattedAmount.replacingOccurrences(of: separator, with: "")

            budget.amount = Int64(extractedString) ?? -1
            
            do {
                try context.save()
            }
            catch {
                print("Error creating budget")
            }
            
            userDefault.set(true, forKey: "isNewUser")
//            let destinationVC = segue.destination as? MainScreenViewController
//            let budget = budgetTextField.text
//            destinationVC?.totalBudget = Int(CFStringGetIntValue(budget as CFString?))
        }
    }
}

//extension CreateNewBudgetViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var amountTyped = 0
//
//        if string.count > 0 {
//            amountTyped = Int(string) ?? 0
//            let newAmount = formatter.string(from: NSNumber(value: amountTyped))
//            textField.text = newAmount
//        }
//
//        return false
//    }
//}

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
