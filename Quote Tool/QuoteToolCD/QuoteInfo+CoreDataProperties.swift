//
//  QuoteInfo+CoreDataProperties.swift
//  Quote Tool
//
//  Created by Jorge Munoz on 2/14/24.
//
//

import Foundation
import CoreData


extension QuoteInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuoteInfo> {
        return NSFetchRequest<QuoteInfo>(entityName: "QuoteInfo")
    }

    @NSManaged public var productName: String?
    @NSManaged public var upfrontCost: Double
    @NSManaged public var monthlyCost: Double

}

//extension QuoteInfo : Identifiable {
//
//}
