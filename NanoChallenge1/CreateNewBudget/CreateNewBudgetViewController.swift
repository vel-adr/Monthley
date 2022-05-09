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
        }
    }
}
