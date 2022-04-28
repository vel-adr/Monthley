//
//  MainScreenViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit

class MainScreenViewController: UIViewController {
    //Received or passed var
    let formatter = ViewController.formatter
    var totalBudget: Int = 0
    
    @IBOutlet weak var backgroundRectangle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalBudgetLabel: UILabel!
    @IBOutlet weak var currentSpentMoneyLabel: UILabel!
    @IBOutlet weak var moneyLeftToSpendLabel: UILabel!
    
    var totalSpending: Int = 0
    
    var expenseCategory = [
        Category(name: "Essential", image: "house", expenses: []),
        Category(name: "Optional", image: "gamecontroller", expenses: []),
        Category(name: "Saving", image: "dollarsign.circle", expenses: [])
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setBgRectangleShadow()
        tableView.register(UINib(nibName: "CustomTableHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomTableHeader")
        
        expenseCategory[0].expenses.append(Expense(name: "Kos", amount: 1000000))
        expenseCategory[1].expenses.append(Expense(name: "Jajan", amount: 150000))
        expenseCategory[2].expenses.append(Expense(name: "Bibit", amount: 500000))
        
        updateAllData()
    }
    
    func updateAllData() {
        totalBudgetLabel.text = "\(formatted(amount: totalBudget))"
        updateTotalSpending()
        updateMoneyLeftToSpend()
        tableView.reloadData()
    }
    
    func updateMoneyLeftToSpend() {
        let diff = totalBudget - totalSpending
        moneyLeftToSpendLabel.text = "\(formatted(amount: diff))"
        
        if diff >= 0 {
            moneyLeftToSpendLabel.textColor = UIColor.systemGreen
        } else {
            moneyLeftToSpendLabel.textColor = .red
        }
    }
    
    func updateTotalSpending() {
        totalSpending = 0
        
        for category in expenseCategory {
            for expense in category.expenses {
                totalSpending += expense.amount
            }
        }
        
        currentSpentMoneyLabel.text = "\(formatted(amount: totalSpending))"
        
        if totalSpending <= totalBudget {
            currentSpentMoneyLabel.textColor = UIColor.systemGreen
        } else {
            currentSpentMoneyLabel.textColor = .red
        }
    }
    
    func formatted(amount: Int) -> String {
        return formatter.string(from: NSNumber(value: amount)) ?? "-"
    }
    
    func setBgRectangleShadow() {
        backgroundRectangle.layer.shadowColor = UIColor.black.cgColor
        backgroundRectangle.layer.shadowOpacity = 0.1
        backgroundRectangle.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundRectangle.layer.shadowRadius = 4
        backgroundRectangle.layer.shouldRasterize = true
        backgroundRectangle.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditBudget" {
            let destinationVC = segue.destination as? EditBudgetViewController
            destinationVC?.budget = totalBudget
        }
    }
    
    @IBAction func unwindFromAddExpense(_ sender: UIStoryboardSegue) {
        if sender.source is AddExpenseViewController {
            if let sourceVC = sender.source as? AddExpenseViewController {
                //For create new expense
                if sourceVC.expense == nil {
                    let newExpense = Expense(name: sourceVC.name!, amount: sourceVC.amount!)
                    self.expenseCategory[sourceVC.selectedCategoryIndex!].expenses.append(newExpense)
                }
                
                //For edit
                else {
                    //If user change category
                    if sourceVC.selectedCategoryIndex != sourceVC.receivedSelectedCategories {
                        //Remove expense from old category
                        let toBeRemovedIndex: Int = expenseCategory[sourceVC.receivedSelectedCategories!].expenses.firstIndex(where: { $0.name == sourceVC.expense?.name && $0.amount == sourceVC.expense?.amount })!
                        expenseCategory[sourceVC.receivedSelectedCategories!].expenses.remove(at: toBeRemovedIndex)

                        
                        //Add new expense to new selected category
                        sourceVC.expense?.name = sourceVC.name!
                        sourceVC.expense?.amount = sourceVC.amount!
                        expenseCategory[sourceVC.selectedCategoryIndex!].expenses.append(sourceVC.expense!)
                    }
                    else {
                        sourceVC.expense?.name = sourceVC.name!
                        sourceVC.expense?.amount = sourceVC.amount!
                    }
                }
                updateAllData()
            }
        }
    }
    
    @IBAction func unwindFromEditBudget(_ sender: UIStoryboardSegue) {
        if sender.source is EditBudgetViewController {
            if let sourceVC = sender.source as? EditBudgetViewController {
                totalBudget = sourceVC.budget ?? 0
                updateAllData()
            }
        }
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategory[section].expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableCell", for: indexPath) as! CustomExpenseTableViewCell
        
        cell.nameLabel.text = expenseCategory[indexPath.section].expenses[indexPath.row].name
        let expenseAmount = expenseCategory[indexPath.section].expenses[indexPath.row].amount
        cell.amountLabel.text = "\(formatted(amount: expenseAmount))"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = expenseCategory[indexPath.section]
        let expense = category.expenses[indexPath.row]
        
        let vc = UIStoryboard(name: "AddExpense", bundle: nil).instantiateViewController(withIdentifier: "addExpense") as! AddExpenseViewController
        
        let categoryIndex = vc.categories.firstIndex(where: { $0 == category.name })
        vc.expense = expense
        vc.receivedSelectedCategories = categoryIndex
//        vc.name = expense.name
//        vc.amount = expense.amount
        vc.isCategoriesSelected[categoryIndex!] = true
        
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            let expenseNameToRemove = self.expenseCategory[indexPath.section].expenses[indexPath.row].name
            let expenseAmountToRemove = self.expenseCategory[indexPath.section].expenses[indexPath.row].amount
            
            let indexToRemove = self.expenseCategory[indexPath.section].expenses.firstIndex(where: { $0.name == expenseNameToRemove && $0.amount == expenseAmountToRemove })
            
            self.expenseCategory[indexPath.section].expenses.remove(at: indexToRemove!)
            
            self.updateAllData()
        }
        
        action.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomTableHeader") as! CustomTableHeader
        
        headerView.titleLabel.text = expenseCategory[section].name
        headerView.headerImage.image = UIImage(systemName: expenseCategory[section].image)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
