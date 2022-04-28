//
//  Expense.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 28/04/22.
//

import Foundation

struct Category {
    var name: String
    var image: String
    var expenses: [Expense]
}

class Expense {
    var name: String = ""
    var amount: Int = 0
    
    init(name: String, amount: Int) {
        self.name = name
        self.amount = amount
    }
}


