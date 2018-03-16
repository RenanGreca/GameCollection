//
//  GameManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 16/03/18.
//
//

import Foundation
import CoreData


extension GameManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameManagedObject> {
        return NSFetchRequest<GameManagedObject>(entityName: "Game")
    }

    @NSManaged public var boxart: String?
    @NSManaged public var guid: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var boxartData: NSData?
    @NSManaged public var platforms: NSSet?

}

// MARK: Generated accessors for platforms
extension GameManagedObject {

    @objc(addPlatformsObject:)
    @NSManaged public func addToPlatforms(_ value: PlatformManagedObject)

    @objc(removePlatformsObject:)
    @NSManaged public func removeFromPlatforms(_ value: PlatformManagedObject)

    @objc(addPlatforms:)
    @NSManaged public func addToPlatforms(_ values: NSSet)

    @objc(removePlatforms:)
    @NSManaged public func removeFromPlatforms(_ values: NSSet)

}
