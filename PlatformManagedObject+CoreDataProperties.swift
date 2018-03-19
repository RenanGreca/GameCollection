//
//  PlatformManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 19/03/18.
//
//

import Foundation
import CoreData
import GameCollection

extension PlatformManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlatformManagedObject> {
        return NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var company: CompanyManagedObject?
    @NSManaged public var games: NSSet?

}

// MARK: Generated accessors for games
extension PlatformManagedObject {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: GameManagedObject)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: GameManagedObject)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}
