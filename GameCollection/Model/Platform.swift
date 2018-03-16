//
//  Platform.swift
//  GameCollection
//
//  Created by Cinq Technologies on 16/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData

class Platform: Hashable {
    
    var hashValue: Int {
        return self.id.hashValue
    }
    
    static func ==(lhs: Platform, rhs: Platform) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var abbreviation: String
    var name: String
    var id: Int
    
    init(id:Int, abbreviation: String, name: String) {
        self.abbreviation = abbreviation
        self.name = name
        self.id = id
        
    }
    
    init(from managedPlatform:PlatformManagedObject) {
        self.abbreviation = managedPlatform.abbreviation!
        self.name = managedPlatform.name!
        self.id = Int(managedPlatform.id)
    }
    
    func insert(to context: NSManagedObjectContext) -> PlatformManagedObject {
    
        let managedPlatform = NSEntityDescription.insertNewObject(forEntityName: "Platform", into: context) as! PlatformManagedObject
        
        managedPlatform.abbreviation = self.abbreviation
        managedPlatform.name = self.name
        managedPlatform.id = Int64(self.id)
        
        return managedPlatform
    }
    
    class func fetchWith(id:Int, context:NSManagedObjectContext) -> Platform? {
        if let managedPlatform = Platform.fetchManagedWith(id: id, context: context) {
            return Platform(from: managedPlatform)
        }
        
        return nil
        
    }
    
    class func fetchManagedWith(id:Int, context:NSManagedObjectContext) -> PlatformManagedObject? {
        let fetchRequest = NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
        let searchFilter = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [PlatformManagedObject]
        
        if let managedPlatform = results?.first {
            return managedPlatform
        }
        
        return nil
        
    }
}
