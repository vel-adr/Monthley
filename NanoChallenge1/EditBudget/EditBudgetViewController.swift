//
//  EditBudgetViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 28/04/22.
//

import UIKit

class EditBudgetViewController: UIViewController {
    
    @IBOutlet weak var textField: TextFieldWithPadding!
    
    var budget: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
        
        textField.text = "\(budget ?? 0)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        budget = Int(textField.text ?? "0") ?? 0
    }
    
    @IBAction func cancelButtonClicked() {
        dismiss(animated: true)
    }
}
