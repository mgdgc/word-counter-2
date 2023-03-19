//
//  Writing+CoreDataProperties.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//
//

import Foundation
import CoreData


extension Writing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Writing> {
        return NSFetchRequest<Writing>(entityName: "Writing")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?

}

extension Writing : Identifiable {

}
