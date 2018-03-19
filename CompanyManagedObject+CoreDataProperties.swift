//
//  CompanyManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 19/03/18.
//
//

import Foundation
import CoreData


extension CompanyManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyManagedObject> {
        return NSFetchRequest<CompanyManagedObject>(entityName: "Company")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var platforms: NSSet?

}

// MARK: Generated accessors for platforms
extension CompanyManagedObject {

    @objc(addPlatformsObject:)
    @NSManaged public func addToPlatforms(_ value: PlatformManagedObject)

    @objc(removePlatformsObject:)
    @NSManaged public func removeFromPlatforms(_ value: PlatformManagedObject)

    @objc(addPlatforms:)
    @NSManaged public func addToPlatforms(_ values: NSSet)

    @objc(removePlatforms:)
    @NSManaged public func removeFromPlatforms(_ values: NSSet)

}
