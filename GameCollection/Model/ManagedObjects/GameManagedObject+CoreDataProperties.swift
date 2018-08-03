//
//  GameManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 22/03/18.
//
//

import Foundation
import CoreData


extension GameManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameManagedObject> {
        return NSFetchRequest<GameManagedObject>(entityName: "Game")
    }

    @NSManaged public var boxart: String?
    @NSManaged public var boxartData: NSData?
    @NSManaged public var guid: String?
    @NSManaged public var notes: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var status: Int64
    @NSManaged public var title: String?
    @NSManaged public var allPlatforms: NSSet?
    @NSManaged public var ownedPlatforms: NSSet?

}

// MARK: Generated accessors for allPlatforms
extension GameManagedObject {

    @objc(addAllPlatformsObject:)
    @NSManaged public func addToAllPlatforms(_ value: PlatformManagedObject)

    @objc(removeAllPlatformsObject:)
    @NSManaged public func removeFromAllPlatforms(_ value: PlatformManagedObject)

    @objc(addAllPlatforms:)
    @NSManaged public func addToAllPlatforms(_ values: NSSet)

    @objc(removeAllPlatforms:)
    @NSManaged public func removeFromAllPlatforms(_ values: NSSet)

}

// MARK: Generated accessors for ownedPlatforms
extension GameManagedObject {

    @objc(addOwnedPlatformsObject:)
    @NSManaged public func addToOwnedPlatforms(_ value: PlatformManagedObject)

    @objc(removeOwnedPlatformsObject:)
    @NSManaged public func removeFromOwnedPlatforms(_ value: PlatformManagedObject)

    @objc(addOwnedPlatforms:)
    @NSManaged public func addToOwnedPlatforms(_ values: NSSet)

    @objc(removeOwnedPlatforms:)
    @NSManaged public func removeFromOwnedPlatforms(_ values: NSSet)

}
