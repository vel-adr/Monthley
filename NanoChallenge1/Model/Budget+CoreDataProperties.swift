//
//  Budget+CoreDataProperties.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 29/04/22.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var amount: Int64

}

extension Budget : Identifiable {

}
