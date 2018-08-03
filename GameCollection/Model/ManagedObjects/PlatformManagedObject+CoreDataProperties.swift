//
//  PlatformManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 22/03/18.
//
//

import Foundation
import CoreData


extension PlatformManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlatformManagedObject> {
        return NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var company: Int64
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var ownedGames: NSSet?
    @NSManaged public var allGames: NSSet?

}

// MARK: Generated accessors for ownedGames
extension PlatformManagedObject {

    @objc(addOwnedGamesObject:)
    @NSManaged public func addToOwnedGames(_ value: GameManagedObject)

    @objc(removeOwnedGamesObject:)
    @NSManaged public func removeFromOwnedGames(_ value: GameManagedObject)

    @objc(addOwnedGames:)
    @NSManaged public func addToOwnedGames(_ values: NSSet)

    @objc(removeOwnedGames:)
    @NSManaged public func removeFromOwnedGames(_ values: NSSet)

}

// MARK: Generated accessors for allGames
extension PlatformManagedObject {

    @objc(addAllGamesObject:)
    @NSManaged public func addToAllGames(_ value: GameManagedObject)

    @objc(removeAllGamesObject:)
    @NSManaged public func removeFromAllGames(_ value: GameManagedObject)

    @objc(addAllGames:)
    @NSManaged public func addToAllGames(_ values: NSSet)

    @objc(removeAllGames:)
    @NSManaged public func removeFromAllGames(_ values: NSSet)

}
