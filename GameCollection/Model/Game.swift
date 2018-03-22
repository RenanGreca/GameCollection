//
//  Game.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// Abstraction layer for GameManagedObject.
class Game: Hashable {
    
    var hashValue: Int {
        return self.guid.hashValue
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return (lhs.guid == rhs.guid)
    }
    
    // Possible statuses for games.
    enum Status:Int {
        case notInCollection
        case backlog
        case playing
        case completed
        case abandoned
        case wishlist
        
        var string:String {
            switch(self) {
            case .notInCollection:
                return "Not in collection"
            case .backlog:
                return "Backlog"
            case .playing:
                return "Playing"
            case .completed:
                return "Completed"
            case .abandoned:
                return "Abandoned"
            case .wishlist:
                return "Wishlist"
            }
        }
        
        // This MUST be manually updated if the number of cases changes (it is used elsewhere for iteration).
        static let count:Int = 6
    }
    
    let title: String
    let guid: String
    var boxart: String
    var notes: String {
        didSet {
            // Save notes if game is in database.
            if let game = Game.fetchManagedWith(guid: self.guid) {
                game.notes = self.notes
            }
        }
    }
    var status: Status {
        didSet {
            // Save status if game is in database.
            if let game = Game.fetchManagedWith(guid: self.guid) {
                game.status = Int64(self.status.rawValue)
                
                // If new status is "Not in Collection", remove game from database
                if self.status == .notInCollection {
                    for platform in self.ownedPlatforms {
                        if  let managedPlatform = Platform.fetchManagedWith(id: platform.id) {
                            game.removeFromOwnedPlatforms(managedPlatform)
                        }
                    }
                    context.delete(game)
                    self.ownedPlatforms = []
                }
            }
        }
    }
    var boxartImage: UIImage? {
        didSet {
            // Save boxart if game is in database.
            if let game = Game.fetchManagedWith(guid: self.guid) {
                game.boxartData = UIImagePNGRepresentation(self.boxartImage!)
            }
        }
    }
    var allPlatforms: [Platform]
    var ownedPlatforms: [Platform]
    var releaseDate: Date?
    
    
    init(with data:[String: Any]) {
        
        self.ownedPlatforms = []
        
        if let guid = data[Fields.guid.rawValue] as? String {
            self.guid = guid
            
            if let managedGame = Game.fetchWith(guid: guid) {
                self.ownedPlatforms = managedGame.ownedPlatforms
            }
            
        } else {
            self.guid = ""
        }
        
        if let title = data[Fields.name.rawValue] as? String {
            self.title = title
        } else {
            self.title = ""
        }
        
        self.notes = ""
        
        if  let imageList = data[Fields.image.rawValue] as? [String:String],
            let boxartURL = imageList[Fields.imageScale.rawValue] {
            
            self.boxart = boxartURL
        } else {
            self.boxart = ""
        }
        
        if let date = data[Fields.releaseDate.rawValue] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.releaseDate = formatter.date(from: date)
        }
        
        self.status = Status.notInCollection
        
        self.allPlatforms = []
        if let platforms = data[Fields.platforms.rawValue] as? [[String: Any]] {
            for platform in platforms {
                if let abbreviation = platform[Fields.abbreviation.rawValue] as? String,
                   let platformName = platform[Fields.name.rawValue] as? String,
                   let platformId = platform[Fields.id.rawValue] as? Int {
                    
                    let platform = Platform(id: platformId, abbreviation: abbreviation, name: platformName)
                    
                    if !self.allPlatforms.contains(platform) {
                        self.allPlatforms.append(platform)
                    }
                }
            }
        }
        
    }
    
    init(from managedGame:GameManagedObject) {
        self.title = managedGame.title!
        self.guid = managedGame.guid!
        self.notes = managedGame.notes!
        
        self.boxart = managedGame.boxart!
        
        if let imageData = managedGame.boxartData as Data?,
           let image = UIImage(data: imageData) {
            self.boxartImage = image
        }
        
        if let date = managedGame.releaseDate as Date? {
            self.releaseDate = date
        }
        
        if let status = Status(rawValue: Int(managedGame.status)) {
            self.status = status
        } else {
            self.status = Status.notInCollection
        }
        
        self.allPlatforms = []
        for platform in managedGame.allPlatforms as! Set<PlatformManagedObject> {
            self.allPlatforms.append(Platform(with: platform))
        }
        
        self.ownedPlatforms = []
        for platform in managedGame.ownedPlatforms as! Set<PlatformManagedObject> {
            self.ownedPlatforms.append(Platform(with: platform))
        }
        
    }
    
    // To avoid infinite recursion with Platform(from:)
    // There might be a better solution to this...
    init(with managedGame:GameManagedObject) {
        self.title = managedGame.title!
        self.guid = managedGame.guid!
        self.notes = managedGame.notes!
        
        self.boxart = managedGame.boxart!
        
        if let imageData = managedGame.boxartData as Data?,
            let image = UIImage(data: imageData) {
            self.boxartImage = image
        }
        
        if let date = managedGame.releaseDate as Date? {
            self.releaseDate = date
        }
        
        if let status = Status(rawValue: Int(managedGame.status)) {
            self.status = status
        } else {
            self.status = Status.notInCollection
        }
        
        self.allPlatforms = []
        self.ownedPlatforms = []
    }
    
    func insert(platform: Platform) {
        
        let managedPlatform:PlatformManagedObject
        if let p = Platform.fetchManagedWith(id: platform.id) {
            managedPlatform = p
        } else {
            managedPlatform = platform.insert()
        }
        
        let game:GameManagedObject
        if let managedGame = Game.fetchManagedWith(guid: self.guid) {
            // Game already exists in database. Include new platform.
            game = managedGame
            
        } else {
            // Game does not exist in database. Add it.
            
            let managedGame = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context) as! GameManagedObject
            game = managedGame
            
            self.status = .backlog
            
            game.title = self.title
            game.guid = self.guid
            game.notes = self.notes
            game.releaseDate = self.releaseDate
            game.boxart = self.boxart
            game.status = Int64(self.status.rawValue)
            
            if let image = self.boxartImage {
                game.boxartData = UIImagePNGRepresentation(image)
            }

        }
        
        game.addToOwnedPlatforms(managedPlatform)
        
        if !self.ownedPlatforms.contains(platform) {
            self.ownedPlatforms.append(platform)
        }
        
        for platform in self.allPlatforms {
            // Update all platforms list
            
            let managedPlatform:PlatformManagedObject
            if let p = Platform.fetchManagedWith(id: platform.id) {
                managedPlatform = p
            } else {
                managedPlatform = platform.insert()
            }
            
            game.addToAllPlatforms(managedPlatform)
        }
        
    
    }
    
    func remove(platform: Platform) {

        // If both game and platform are in database, remove relationship.
        if  let managedPlatform = Platform.fetchManagedWith(id: platform.id),
            let game = Game.fetchManagedWith(guid: self.guid) {
            
            game.removeFromOwnedPlatforms(managedPlatform)
            
            // Ideally, the game should be removed from the collection if it has no more platforms.
            // This has been removed because it was causing a bug in the TableView coming from Search.
            // TODO: Think of a way to do this avoiding the bug.
            
            if let i = self.ownedPlatforms.index(of: platform) {
                self.ownedPlatforms.remove(at: i)
            }

            if  self.ownedPlatforms.count == 0,
                let game = Game.fetchManagedWith(guid: self.guid) {

                context.delete(game)
                self.status = .notInCollection
            }

        }
        
    }
    
    class func fetchOne() -> Game? {        
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")

        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject]

        if let managedGame = results?.first {
            return Game(from: managedGame)
        } else {
            return nil
        }
    }
    
    class func fetchWith(guid:String) -> Game? {
        
        if let managedGame = Game.fetchManagedWith(guid: guid) {
            return Game(from: managedGame)
        }
        
        return nil
    }
    
    class func fetchManagedWith(guid:String) -> GameManagedObject? {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        let searchFilter = NSPredicate(format: "guid = %@", guid)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject]
        
        if let managedGame = results?.first {
            return managedGame
        } else {
            return nil
        }
    }
    
    // Collection is formed by all games without status .notInCollection or .wishlist
    class func fetchAllInCollection() -> [String: [Game]] {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        
        let searchFilter = NSPredicate(format: "status != %d && status != %d", Status.wishlist.rawValue, Status.notInCollection.rawValue)
        fetchRequest.predicate = searchFilter
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var games = [String: [Game]]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject] {
            for result in results {
                let game = Game(from: result)
                if let char = game.title.first {
                    let charIndex = String(describing: char)
                    if let _ = games[charIndex] {
                        games[charIndex]!.append(game)
                    } else {
                        games[charIndex] = [Game]()
                        games[charIndex]!.append(game)
                    }
                }
            }
        }
        
        return games
    }
    
    class func fetchAll(with status: Status) -> [String: [Game]] {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        
        let searchFilter = NSPredicate(format: "status == %d", status.rawValue)
        fetchRequest.predicate = searchFilter
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var games = [String: [Game]]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject] {
            for result in results {
                let game = Game(from: result)
                if let char = game.title.first {
                    let charIndex = String(describing: char)
                    if let _ = games[charIndex] {
                        games[charIndex]!.append(game)
                    } else {
                        games[charIndex] = [Game]()
                        games[charIndex]!.append(game)
                    }
                }
            }
        }
        
        return games
    }
    
    class func fetchAll(with platform: Platform) -> [String: [Game]] {
        let managedPlatform = Platform.fetchManagedWith(id: platform.id)!
        
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        
        let searchFilter = NSPredicate(format: "ANY ownedPlatforms == %@", managedPlatform)
        let statusFilter = NSPredicate(format: "status != %d && status != %d", Status.wishlist.rawValue, Status.notInCollection.rawValue)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchFilter, statusFilter])
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var games = [String: [Game]]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject] {
            for result in results {
                let game = Game(from: result)
                if let char = game.title.first {
                    let charIndex = String(describing: char)
                    if let _ = games[charIndex] {
                        games[charIndex]!.append(game)
                    } else {
                        games[charIndex] = [Game]()
                        games[charIndex]!.append(game)
                    }
                }
            }
        }
        
        return games
    }
    
    class func deleteAll() {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
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
            print("Error deleting all data in Game : \(error) \(error.userInfo)")
        }
    }

}
