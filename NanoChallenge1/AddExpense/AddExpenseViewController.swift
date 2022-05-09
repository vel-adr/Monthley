//
//  AddExpenseViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 28/04/22.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    let formatter = ViewController.formatter
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: TextFieldWithPadding!
    @IBOutlet weak var amountTextField: TextFieldWithPadding!
    
    var lastSelectedRowIndexPath: IndexPath? = nil
    var isCategoriesSelected = [false, false, false]
    let categories = ["Daily Needs", "Non-Essentials", "Saving"]
    let categoriesImage = ["house", "cup.and.saucer", "dollarsign.circle"]
    
    //var to be passed back to main screen
    var name: String? = ""
    var amount: Int? = -1
    var selectedCategoryIndex: Int? = -1
    
    //var received from main screen
    var expense: Expense? = nil
    var receivedSelectedCategories: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Set textField value if mainScreen passes data to this controller
        if expense != nil {
            nameTextField.text = expense?.name
            
            let formattedAmount = formatter.string(from: NSNumber(value: expense?.amount ?? 0))
            amountTextField.text = formattedAmount
        }
        
        setModalHeight()
    }
    
    func setModalHeight() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //Get value of textField and selectedCategory
        name = nameTextField.text ?? ""
        selectedCategoryIndex = isCategoriesSelected.firstIndex(where: { $0 == true }) ?? -1
        
        let separator = formatter.groupingSeparator ?? ""
        let extractedString = amountTextField.text?.replacingOccurrences(of: separator, with: "") ?? "-1"
        amount = Int(extractedString) ?? -1

        //Check if there are empty textField
        if name?.isEmpty == true || amountTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Input Is Not Valid", message: "All text fields must be filled in order to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        
        //Check amountTextField value
        if amount ?? -1 <= 0 || amount ?? -1 > 999999999 {
            let alert = UIAlertController(title: "Amount Is Not Valid", message: "The amount must be in range of 1 to 999.999.999", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        
        //Check if there is selected category
        if selectedCategoryIndex ?? -1 < 0 || selectedCategoryIndex ?? -1 > categories.count-1 {
            let alert = UIAlertController(title: "Category Is Not Valid", message: "You should pick one of the categories in order to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //Replace inputted value to formatted string
    @IBAction func textFieldOnChange(_ sender: Any) {
        //Get extracted value of entered input
        let textFromTextField = amountTextField.text ?? ""
        let separator = formatter.groupingSeparator ?? ""
        let extractedValue = Int(textFromTextField.replacingOccurrences(of: separator, with: ""))
        
        //Re-format and replace input text with new formatted string
        let formattedString = formatter.string(from: NSNumber(value: extractedValue ?? 0))
        amountTextField.text = formattedString
    }
}

extension AddExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CustomCategoryTableViewCell
        
        cell.categoryNameLabel.text = categories[indexPath.row]
        cell.categoryImage.image = UIImage(systemName: categoriesImage[indexPath.row])?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if !isCategoriesSelected[indexPath.row] {
            cell.categoryCheckmark.isHidden = true
        } else {
            lastSelectedRowIndexPath = indexPath
            cell.backgroundColor = UIColor.systemGray6
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CustomCategoryTableViewCell

        //Cek jika udah ada yg di select
        if isCategoriesSelected.contains(where: { $0 == true }) {
            if let selectedIndex = isCategoriesSelected.firstIndex(where: { $0 == true }) {
                let prevCell = tableView.cellForRow(at: lastSelectedRowIndexPath!) as! CustomCategoryTableViewCell
                prevCell.categoryCheckmark.isHidden = true
                prevCell.backgroundColor = UIColor.clear
                isCategoriesSelected[selectedIndex] = false

                if indexPath.row != selectedIndex {
                    selectedCell.categoryCheckmark.isHidden = !selectedCell.categoryCheckmark.isHidden
                    selectedCell.backgroundColor = UIColor.systemGray6
                    isCategoriesSelected[indexPath.row] = !isCategoriesSelected[indexPath.row]
                    lastSelectedRowIndexPath = indexPath
                }
            }
            else {return}
        }
        else {
            selectedCell.categoryCheckmark.isHidden = !selectedCell.categoryCheckmark.isHidden
            selectedCell.backgroundColor = UIColor.systemGray6
            isCategoriesSelected[indexPath.row] = !isCategoriesSelected[indexPath.row]
            lastSelectedRowIndexPath = indexPath
        }
    }
}
