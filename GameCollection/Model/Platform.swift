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

class Platform: Hashable {
    
    var hashValue: Int {
        return self.id.hashValue
    }
    
    static func ==(lhs: Platform, rhs: Platform) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    // TODO: Aggregate related platforms. i.e. 3DS eShop -> 3DS; PlayStation Network (PS3) -> PS3
    //    let unsupportedPlatforms = [
    //        "3DSE": "3DS",
    //    ]
    
    // TODO: Display platform with color depending on family of systems
    var color:UIColor {
        if let company = self.company?.name {
            switch(company) {
            case "Nintendo":
                return .red
            case "Sony Interactive Entertainment":
                return .blue
            case "Microsoft Studios":
                return .green
            default:
                return .black
            }
        }
        return .black
    }
    
    let abbreviation: String
    let name: String
    let id: Int
    var games: [Game]
    var company: Company?
    
    init(id:Int, abbreviation: String, name: String) {
        self.abbreviation = abbreviation
        self.name = name
        self.id = id
        self.games = []
        
    }
    
    init(from managedPlatform:PlatformManagedObject) {
        self.abbreviation = managedPlatform.abbreviation!
        self.name = managedPlatform.name!
        self.id = Int(managedPlatform.id)
        if let company = managedPlatform.company {
            self.company = Company(from: company)
        }
        
        self.games = []
        for game in managedPlatform.games as! Set<GameManagedObject> {
            self.games.append(Game(with: game))
        }
    }
    
    // To avoid infinite recursion with Game(from:)
    // There might be a better solution to this...
    init(with managedPlatform:PlatformManagedObject) {
        self.abbreviation = managedPlatform.abbreviation!
        self.name = managedPlatform.name!
        self.id = Int(managedPlatform.id)
        if let company = managedPlatform.company {
            self.company = Company(from: company)
        }
        
        self.games = []
    }
    
    func insert() -> PlatformManagedObject {
    
        let managedPlatform = NSEntityDescription.insertNewObject(forEntityName: "Platform", into: context) as! PlatformManagedObject
        
        managedPlatform.abbreviation = self.abbreviation
        managedPlatform.name = self.name
        managedPlatform.id = Int64(self.id)
        
        // Asynchronously request company that owns the platform
        let gameGrabber = GameGrabber()
        gameGrabber.findCompanyForPlatformWith(id: self.id) {
            company, error in
            
            if let company = company {
                self.company = company
                
                if let managedCompany = Company.fetchManagedWith(id: company.id) {
                    managedPlatform.company = managedCompany
                } else {
                    managedPlatform.company = company.insert()
                }
                
            }
        }
        
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
