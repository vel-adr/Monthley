//
//  Expense+CoreDataProperties.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 29/04/22.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var name: String?
    @NSManaged public var category: String?

}

extension Expense : Identifiable {

}
