//
//  GameManagedObject+CoreDataProperties.swift
//  
//
//  Created by Cinq Technologies on 15/03/18.
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
    @NSManaged public var platforms: NSObject?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var title: String?

}
