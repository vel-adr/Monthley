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
