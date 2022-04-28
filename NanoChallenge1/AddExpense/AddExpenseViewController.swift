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
    let categories = ["Essential", "Optional", "Saving"]
    let categoriesImage = ["house", "gamecontroller", "dollarsign.circle"]
    
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
        
        if expense != nil {
            nameTextField.text = expense?.name
            amountTextField.text = "\(expense?.amount ?? -1)"
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
        name = nameTextField.text ?? ""
        amount = Int(amountTextField.text ?? "") ?? -1
        selectedCategoryIndex = isCategoriesSelected.firstIndex(where: { $0 == true }) ?? -1
        
        if name?.isEmpty == true || amountTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Input Is Not Valid", message: "All text fields must be filled in order to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        
        if amount ?? -1 < 0 || amount ?? -1 > 999999999 {
            let alert = UIAlertController(title: "Amount Is Not Valid", message: "The amount must be in range of 1 to 999.999.999", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //cari ganti warna waktu cell diselect
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CustomCategoryTableViewCell

        //Cek jika udah ada yg di select
        if isCategoriesSelected.contains(where: { $0 == true }) {
            if let selectedIndex = isCategoriesSelected.firstIndex(where: { $0 == true }) {
                let prevCell = tableView.cellForRow(at: lastSelectedRowIndexPath!) as! CustomCategoryTableViewCell
                prevCell.categoryCheckmark.isHidden = true
                isCategoriesSelected[selectedIndex] = false

                if indexPath.row != selectedIndex {
                    selectedCell.categoryCheckmark.isHidden = !selectedCell.categoryCheckmark.isHidden
                    isCategoriesSelected[indexPath.row] = !isCategoriesSelected[indexPath.row]
                    lastSelectedRowIndexPath = indexPath
                }
            }
            else {return}
        }
        else {
            selectedCell.categoryCheckmark.isHidden = !selectedCell.categoryCheckmark.isHidden
            isCategoriesSelected[indexPath.row] = !isCategoriesSelected[indexPath.row]
            lastSelectedRowIndexPath = indexPath
        }
    }
}
