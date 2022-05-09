//
//  EditBudgetViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 28/04/22.
//

import UIKit

class EditBudgetViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let formatter = ViewController.formatter
    
    @IBOutlet weak var textField: TextFieldWithPadding!
    
    var budget: Budget?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set modal height
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
        
        //Set textfield's text to formatted budget amount
        let formattedAmount = formatter.string(from: NSNumber(value: budget?.amount ?? 0))
        textField.text = formattedAmount
    }
    
    
    //Validation before segueing to another view
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //Check if textfield is empty
        if textField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be filled to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        else {
            let extractedString = textField.text?.replacingOccurrences(of: ",", with: "") ?? "-1"
            let budgetFromLabel = Int(extractedString) ?? -1
            
            //Check value of entered input
            if budgetFromLabel <= 0 || budgetFromLabel > 999999999 {
                let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be in range of 0 to 999.999.999", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true)
                }))
                present(alert, animated: true, completion: nil)
                
                return false
            }
            else {
                return true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Extract value of formatted string
        let separator = formatter.groupingSeparator ?? ""
        let extractedValue = textField.text?.replacingOccurrences(of: separator, with: "")
        
        //Set new value for budget
        budget?.amount = Int64(Int(extractedValue ?? "0") ?? 0)
        
        //Save it
        do {
            try context.save()
        } catch {
            print("Error updating budget")
        }
    }
    
    @IBAction func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    //Replace inputted value to formatted string
    @IBAction func textFieldOnChange(_ sender: Any) {
        //Get extracted value of entered input
        let textFromTextField = textField.text ?? ""
        let separator = formatter.groupingSeparator ?? ""
        let extractedValue = Int(textFromTextField.replacingOccurrences(of: separator, with: ""))
        
        //Re-format and replace input text with new formatted string
        let formattedString = formatter.string(from: NSNumber(value: extractedValue ?? 0))
        textField.text = formattedString
    }
}
