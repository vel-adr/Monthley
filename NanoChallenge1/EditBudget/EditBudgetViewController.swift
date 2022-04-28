//
//  EditBudgetViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 28/04/22.
//

import UIKit

class EditBudgetViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var textField: TextFieldWithPadding!
    
    var budget: Budget?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
        
        textField.text = "\(budget?.amount ?? 0)"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if textField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be filled to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        else {
            let budgetFromLabel = Int(textField.text ?? "") ?? -1
            
            if budgetFromLabel < 0 || budgetFromLabel > 999999999 {
                let alert = UIAlertController(title: "Budget Is Not Valid", message: "The budget must be in range of 0 to 999.999.999", preferredStyle: .alert)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        budget?.amount = Int64(Int(textField.text ?? "0") ?? 0)
        do {
            try context.save()
        } catch {
            print("Error updating budget")
        }
    }
    
    @IBAction func cancelButtonClicked() {
        dismiss(animated: true)
    }
}
