//
//  Platform.swift
//  GameCollection
//
//  Created by Cinq Technologies on 16/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias PlatformTuple = (name: String, abbreviation: String)

class Platform: Hashable {
    
    var hashValue: Int {
        return self.abbreviation.hashValue
    }
    
    static func ==(lhs: Platform, rhs: Platform) -> Bool {
        return (lhs.abbreviation == rhs.abbreviation)
    }
    
    // TODO: Aggregate related platforms. i.e. 3DS eShop -> 3DS; PlayStation Network (PS3) -> PS3
    static let relatedPlatforms:[String:PlatformTuple] = [
        "FDS" : (name: "Nintendo Entertainment System", abbreviation: "NES"),
        
        "XBGS": (name: "Xbox 360", abbreviation: "X360"),
        "PS3N": (name: "PlayStation 3", abbreviation: "PS3"),
        "WSHP": (name: "Wii", abbreviation: "Wii"),
        "DSI" : (name: "Nintendo DS", abbreviation: "DS"),
        "PSPN": (name: "PlayStation Portable", abbreviation: "PSP"),
        
        "IPOD": (name: "iOS", abbreviation: "iOS"),
        "IPHN": (name: "iOS", abbreviation: "iOS"),
        "IPAD": (name: "iOS", abbreviation: "iOS"),
        
        "3DSE": (name: "Nintendo 3DS", abbreviation: "3DS"),
        "N3DS": (name: "Nintendo 3DS", abbreviation: "3DS"),
        "PSNV": (name: "PlayStation Vita", abbreviation: "PSV"),
        "VITA": (name: "PlayStation Vita", abbreviation: "PSV"),
        
        "MAC" : (name: "PC", abbreviation: "PC"),
        "LIN" : (name: "PC", abbreviation: "PC")
        
    ]
    
    let abbreviation: String
    let name: String
    let id: Int
    var games: [Game]
    var company: Company
    
    init(id:Int, abbreviation: String, name: String) {
        if let platformTuple = Platform.relatedPlatforms[abbreviation] {
            // Added platform is one of the related platforms

            self.abbreviation = platformTuple.abbreviation
            self.name = platformTuple.name
            
            if let fetchedPlatform = Platform.fetchWith(abbreviation: platformTuple.abbreviation) {
                self.id = fetchedPlatform.id
            } else {
                self.id = id
            }
            
        } else {
            self.abbreviation = abbreviation
            self.name = name
            self.id = id
            
        }
        
        self.games = []
        
        self.company = Company.from(platformName: name)
        
    }
    
    init(from managedPlatform:PlatformManagedObject) {
        self.abbreviation = managedPlatform.abbreviation!
        self.name = managedPlatform.name!
        self.id = Int(managedPlatform.id)
        self.company = Company.from(platformName: name)
        managedPlatform.company = Int64(self.company.rawValue)
        
//        if let company = managedPlatform.company {
//            self.company = Company.from(name: company.name)
//        }
        
        self.games = []
        for game in managedPlatform.ownedGames as! Set<GameManagedObject> {
            self.games.append(Game(with: game))
        }
    }
    
    // To avoid infinite recursion with Game(from:)
    // There might be a better solution to this...
    init(with managedPlatform:PlatformManagedObject) {
        self.abbreviation = managedPlatform.abbreviation!
        self.name = managedPlatform.name!
        self.id = Int(managedPlatform.id)
        self.company = Company.from(platformName: name)
        managedPlatform.company = Int64(self.company.rawValue)
        
//        if let company = managedPlatform.company {
//            self.company = Company.from(name: company.name)
//        }
        
        self.games = []
    }
    
    func insert() -> PlatformManagedObject {
        
        if let managedPlatform = Platform.fetchManagedWith(abbreviation: self.abbreviation) {
            return managedPlatform
        }
    
        let managedPlatform = NSEntityDescription.insertNewObject(forEntityName: "Platform", into: context) as! PlatformManagedObject
        
        managedPlatform.abbreviation = self.abbreviation
        managedPlatform.name = self.name
        managedPlatform.id = Int64(self.id)
        managedPlatform.company = Int64(self.company.rawValue)
        
        // Asynchronously request company that owns the platform
//        let gameGrabber = GameGrabber()
//        gameGrabber.findCompanyForPlatformWith(id: self.id) {
//            company, error in
//
//            if let company = company {
//                self.company = company
//                managedPlatform.company = Int64(company.rawValue)
//
////                if let managedCompany = Company.fetchManagedWith(id: company.id) {
////                    managedPlatform.company = managedCompany
////                } else {
////                    managedPlatform.company = company.insert()
////                }
//
//            }
//        }
        
        return managedPlatform
    }
    
    class func fetchWith(id:Int) -> Platform? {
        if let managedPlatform = Platform.fetchManagedWith(id: id) {
            return Platform(from: managedPlatform)
        }
        
        return nil
    }
    
    class func fetchManagedWith(id:Int) -> PlatformManagedObject? {
        let fetchRequest = NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
        let searchFilter = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [PlatformManagedObject]
        
        if let managedPlatform = results?.first {
            return managedPlatform
        }
        
        return nil
    }
    
    class func fetchWith(abbreviation:String) -> Platform? {
        if let managedPlatform = Platform.fetchManagedWith(abbreviation: abbreviation) {
            return Platform(from: managedPlatform)
        }
        
        return nil
    }
    
    class func fetchManagedWith(abbreviation:String) -> PlatformManagedObject? {
        let fetchRequest = NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
        let searchFilter = NSPredicate(format: "abbreviation = %@", abbreviation)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [PlatformManagedObject]
        
        if let managedPlatform = results?.first {
            return managedPlatform
        }
        
        return nil
    }
    
    class func fetchAllInCollection() -> [Platform] {
        let fetchRequest = NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
        
//        let searchFilter = NSPredicate(format: "status != %d && status != %d", Status.wishlist.rawValue, Status.notInCollection.rawValue)
//        fetchRequest.predicate = searchFilter
        
        let companySort = NSSortDescriptor(key: "company", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [companySort, nameSort]
        
        var platforms = [Platform]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [PlatformManagedObject] {
            for result in results {
                let platform = Platform(from: result)
                if platform.games.count > 0 {
                    platforms.append(Platform(from: result))
                }
            }
        }
        
        return platforms
    }
    
    class func deleteAll() {        
        let fetchRequest = NSFetchRequest<PlatformManagedObject>(entityName: "Platform")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Error deleting all data in Platform : \(error) \(error.userInfo)")
        }
    }
}
