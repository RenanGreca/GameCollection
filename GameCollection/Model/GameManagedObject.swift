//
//  GameManagedObject.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData

class GameManagedObject: NSManagedObject {
    
    @NSManaged public var boxart: NSData?
    @NSManaged public var guid: String?
    @NSManaged public var platforms: NSObject?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var title: String?

}
