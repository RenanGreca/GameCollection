//
//  PlatformManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 16/03/18.
//
//

import Foundation
import CoreData


extension PlatformManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlatformManagedObject> {
        return NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
    }

    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    @NSManaged public var id: Int64

}
