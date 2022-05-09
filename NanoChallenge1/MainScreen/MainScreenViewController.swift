//
//  MainScreenViewController.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalBudgetLabel: UILabel!
    @IBOutlet weak var emptyMessageView: UIView!
    @IBOutlet weak var backgroundRectangle: UIView!
    @IBOutlet weak var moneyLeftToSpendLabel: UILabel!
    @IBOutlet weak var currentSpentMoneyLabel: UILabel!
    
    //Received or passed var
    let formatter = ViewController.formatter
    var totalBudget: Int = 0
    
    //Local var
    var totalSpending: Int = 0
    var expenseCategory = [
        Category(name: "Daily Needs", image: "house"),
        Category(name: "Non-Essentials", image: "cup.and.saucer"),
        Category(name: "Saving", image: "dollarsign.circle")
    ]
    var expenses: [Expense]?
    var budget: Budget?
    var disabledCellIndexPath = [IndexPath]()
    
    
    
    // --- FUNCTIONS ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setBgRectangleShadow()
        tableView.register(UINib(nibName: "CustomTableHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomTableHeader")
        tableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyTableViewCell")
        
        fetchExpenses()
        fetchBudget()
        updateAllData()
    }
    
    func fetchExpenses() {
        do {
            self.expenses = try context.fetch(Expense.fetchRequest())
            
//            DispatchQueue.main.async {
                self.tableView.reloadData()
//            }
        }
        catch {
            print("Error fetching expenses")
        }
    }
    
    func fetchBudget() {
        do {
            budget = try context.fetch(Budget.fetchRequest())[0] //careful might cause error
        }
        catch {
            print("Error fetching budget")
        }
    }
    
    func getExpensesWithCategory(categoryName: String) -> [Expense] {
        let request = Expense.fetchRequest() as NSFetchRequest<Expense>
        let pred = NSPredicate(format: "category CONTAINS '" + categoryName + "'")
        request.predicate = pred
        
        var expenses = [Expense]()
        
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Error getting expenses")
        }
        
        return expenses
    }
    
    func updateAllData() {
        updateTotalBudget()
        updateTotalSpending()
        updateMoneyLeftToSpend()
    }
    
    func updateTotalBudget() {
        totalBudget = Int(budget!.amount)
        totalBudgetLabel.text = "\(formatted(amount: totalBudget))"
    }
    
    //Calculate difference between totalBudget and currentSpending
    func updateMoneyLeftToSpend() {
        let diff = totalBudget - totalSpending
        moneyLeftToSpendLabel.text = "\(formatted(amount: diff))"
        
        //Set text color based on difference value
        if diff >= 0 {
            moneyLeftToSpendLabel.textColor = UIColor.systemGreen
        } else {
            moneyLeftToSpendLabel.textColor = .red
        }
    }
    
    func updateTotalSpending() {
        totalSpending = 0
        
        var expenses = [Expense]()

        //Fetching all expenses
        do {
            expenses = try context.fetch(Expense.fetchRequest())
        }
        catch {
            print("Error fetching expenses")
        }
        
        //Calculate totalSpending
        for expense in expenses {
            totalSpending += Int(expense.amount)
        }

        //Set text of currentSpendingLabel
        currentSpentMoneyLabel.text = "\(formatted(amount: totalSpending))"

        //Set color of text based on totalSpending value
        if totalSpending <= totalBudget {
            currentSpentMoneyLabel.textColor = UIColor.systemGreen
        } else {
            currentSpentMoneyLabel.textColor = .red
        }
    }
    
    //Return formatted string of int amount
    func formatted(amount: Int) -> String {
        return formatter.string(from: NSNumber(value: amount)) ?? "-"
    }
    
    //Set shadow for rounded rectangle
    func setBgRectangleShadow() {
        backgroundRectangle.layer.shadowColor = UIColor.black.cgColor
        backgroundRectangle.layer.shadowOpacity = 0.1
        backgroundRectangle.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundRectangle.layer.shadowRadius = 4
        backgroundRectangle.layer.shouldRasterize = true
        backgroundRectangle.layer.rasterizationScale = UIScreen.main.scale
    }
    
    //Send current totalBudget to editBudget page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditBudget" {
            let destinationVC = segue.destination as? EditBudgetViewController
            destinationVC?.budget = budget
        }
    }
    
    //Creating/Updating expenses
    @IBAction func unwindFromAddExpense(_ sender: UIStoryboardSegue) {
        if sender.source is AddExpenseViewController {
            if let sourceVC = sender.source as? AddExpenseViewController {
                
                //For create new expense
                if sourceVC.expense == nil {
                    
                    //Create new expense object
                    let newExpense = Expense(context: context)
                    newExpense.name = sourceVC.name
                    newExpense.amount = Int64(sourceVC.amount ?? 0)
                    newExpense.category = sourceVC.categories[sourceVC.selectedCategoryIndex ?? 0]
                    
                    //Save it
                    do {
                        try context.save()
                    }
                    catch {
                        print("Error saving data")
                    }
                    
                    //Reload data
                    fetchExpenses()
                }
                
                //For edit
                else {
                    //Set expense new value
                    sourceVC.expense?.name = sourceVC.name
                    sourceVC.expense?.amount = Int64(sourceVC.amount!)
                    sourceVC.expense?.category = sourceVC.categories[sourceVC.selectedCategoryIndex!]
                    
                    //Save it
                    do {
                        try context.save()
                    }
                    catch {
                        print("Error updating expense")
                    }
                    
                    //Reload data
                    fetchExpenses()
                }
                
                //Update UI
                updateAllData()
            }
        }
    }
    
    
    //Update totalBudget value after editing
    @IBAction func unwindFromEditBudget(_ sender: UIStoryboardSegue) {
        fetchBudget()
        updateAllData()
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    //Get number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseCategory.count
    }
    
    //Get number of expenses for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let expenses = getExpensesWithCategory(categoryName: expenseCategory[section].name)
        
//        DispatchQueue.main.async {    // Recommended
//           if expenses.count == 0 {
//               tableView.isHidden = true
//               self.emptyMessageView.isHidden = false
//           }
//           else {
//               self.emptyMessageView.isHidden = true
//               tableView.isHidden = false
//           }
//        }
//        print(expenses)
        return expenses.isEmpty ? 1 : expenses.count
    }
    
    //Setup tableView cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var emptyCell: EmptyTableViewCell
        var cell: CustomExpenseTableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableCell", for: indexPath) as! CustomExpenseTableViewCell
        emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
        
        //Get category name of that section
        let category = self.expenseCategory[indexPath.section].name
        
        //Get expenses for that category
        let expenses = self.getExpensesWithCategory(categoryName: category)
        
//        print(category + ": \(expenses.count) - Index path: \(indexPath) - Section: \(indexPath.section)")
        
        
        
        if expenses.count == 0 {
            disabledCellIndexPath.append(indexPath)
            return emptyCell
        }
        else {
            //Delete indexPath from disabledCellIndexPath
            let indexToRemove = self.disabledCellIndexPath.firstIndex(where: { $0 == indexPath })
            if indexToRemove ?? -1 >= 0 {
                self.disabledCellIndexPath.remove(at: indexToRemove!)
            }
            
            //Set label text value
            cell.nameLabel.text = expenses[indexPath.row].name
            let expenseAmount = expenses[indexPath.row].amount
            cell.amountLabel.text = "\(self.formatted(amount: Int(expenseAmount)))"
        }
        
        return cell
    }
    
    //Show modal to edit expense when user click on tableView's row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if !disabledCellIndexPath.contains(indexPath) {
            //Get category name
            let category = expenseCategory[indexPath.section].name
            
            //Get expenses in that category
            let expensesInCategory = self.getExpensesWithCategory(categoryName: category)
            
            //Get expense at selected row
            let expense = expensesInCategory[indexPath.row]

            //Instantiate destination VC
            let vc = UIStoryboard(name: "AddExpense", bundle: nil).instantiateViewController(withIdentifier: "addExpense") as! AddExpenseViewController
            
            //Get category index of that expense
            let categoryIndex = vc.categories.firstIndex(where: { $0 == category })
            
            //Set destination VC variables' value
            vc.expense = expense
            vc.receivedSelectedCategories = categoryIndex
            vc.isCategoriesSelected[categoryIndex!] = true

            //Show destination VC (modally)
            present(vc, animated: true)
        }
    }

    //Add delete action to each row in tableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            //Get category name
            let categoryName = self.expenseCategory[indexPath.section].name
            
            //Get expenses in that category
            let expensesInCategory = self.getExpensesWithCategory(categoryName: categoryName)
            
            //Get expense at selected index
            let expenseToRemove = expensesInCategory[indexPath.row]
            
            
            //Delete that expense and save
            self.context.delete(expenseToRemove)
            do {
                try self.context.save()
            }
            catch {
                print("Error deleting expense")
            }
            
            //Reload data
            self.fetchExpenses()
            self.updateAllData()
        }
        //Set image for action
        action.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Setup tableViewHeader for each section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomTableHeader") as! CustomTableHeader
        
        headerView.titleLabel.text = expenseCategory[section].name
        headerView.headerImage.image = UIImage(systemName: expenseCategory[section].image)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        return headerView
    }
    
    
    //Set tableViewHeader height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !disabledCellIndexPath.contains(indexPath)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height: CGFloat = 50
//        if tableView.cellForRow(at: indexPath) is EmptyTableViewCell {
//            height = 30
//        }
//        return height
//    }
}
