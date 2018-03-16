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

enum Fields:String {
    case guid = "guid"
    case image = "image"
    case imageScale = "small_url"
    case title = "name"
    case releaseDate = "original_release_date"
    case platforms =  "platforms"
    case platformAbbrev = "abbreviation"
    case id = "id"
}

class Game: Hashable {
    
    
    var hashValue: Int {
        return self.guid.hashValue
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return (lhs.guid == rhs.guid)
    }
    
    var title: String
    var guid: String
    var boxart: String
    var boxartImage: UIImage?
    var platforms: [Platform]
    var releaseDate: Date?
    
    init(with data:[String: Any]) {
        if let title = data[Fields.title.rawValue] as? String {
            self.title = title
        } else {
            self.title = ""
        }
        
        if let guid = data[Fields.guid.rawValue] as? String {
            self.guid = guid
        } else {
            self.guid = ""
        }
        
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
        
        self.platforms = []
        if let platforms = data[Fields.platforms.rawValue] as? [[String: Any]] {
            for platform in platforms {
                if let abbreviation = platform[Fields.platformAbbrev.rawValue] as? String,
                   let platformName = platform[Fields.title.rawValue] as? String,
                   let platformId = platform[Fields.id.rawValue] as? Int {
                    
                    let platform = Platform(id: platformId, abbreviation: abbreviation, name: platformName)
                    self.platforms.append(platform)
                }
            }
            
        }
    }
    
    init(from managedGame:GameManagedObject) {
        self.title = managedGame.title!
        self.guid = managedGame.guid!
        self.boxart = managedGame.boxart!
        
        if let imageData = managedGame.boxartData as Data? {
            self.boxartImage = UIImage(data: imageData)
        }
        
        if let date = managedGame.releaseDate as Date? {
            self.releaseDate = date
        }
        
        self.platforms = []
        for platform in managedGame.platforms as! Set<PlatformManagedObject> {
            self.platforms.append(Platform(from: platform))
        }
        
    }
    
    func insert(platform: Platform, to context:NSManagedObjectContext) {
        
        let managedPlatform:PlatformManagedObject
        if let p = Platform.fetchManagedWith(id: platform.id, context: context) {
            managedPlatform = p
        } else {
            managedPlatform = platform.insert(to: context)
        }
        
        if let game = Game.fetchManagedWith(guid: self.guid, context: context) {
            // Game already exists in database. Include new platform.
            
            var platformSet = game.platforms as! Set<PlatformManagedObject>
            platformSet.insert(managedPlatform)
            game.platforms = platformSet as NSSet
            
        } else {
            // Game does not exist in database. Add it.
            
            let game = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context) as! GameManagedObject
            
            game.title = self.title
            game.guid = self.guid
            game.releaseDate = self.releaseDate
            game.boxart = self.boxart
            
            if let image = self.boxartImage {
                game.boxartData = UIImagePNGRepresentation(image)
            }
            
            var platformSet = Set<PlatformManagedObject>()
            platformSet.insert(managedPlatform)
            game.platforms = platformSet as NSSet

        }
    
    }
    
    func remove(platform: Platform, to context:NSManagedObjectContext) {
        
        if  let managedPlatform = Platform.fetchManagedWith(id: platform.id, context: context),
            let game = Game.fetchManagedWith(guid: self.guid, context: context) {
            // Both game and platform are in database. Remove relationship.
            
            var platformSet = game.platforms as! Set<PlatformManagedObject>
            platformSet.remove(managedPlatform)
            game.platforms = platformSet as NSSet
        }
        
    }
    
    func save(image: UIImage, to context:NSManagedObjectContext) {
        self.boxartImage = image

        if let game = Game.fetchManagedWith(guid: self.guid, context: context) {
            // Game already exists in database. Save image.
            
            game.boxartData = UIImagePNGRepresentation(image)
        }
    }
    
    class func fetchOne(from context:NSManagedObjectContext) -> Game? {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")

        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject]

        if let managedGame = results?.first {
            return Game(from: managedGame)
        } else {
            return nil
        }
    }
    
    class func fetchWith(guid:String, context:NSManagedObjectContext) -> Game? {
        if let managedGame = Game.fetchManagedWith(guid: guid, context: context) {
            return Game(from: managedGame)
        }
        
        return nil
    }
    
    class func fetchManagedWith(guid:String, context:NSManagedObjectContext) -> GameManagedObject? {
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
    
    class func fetchAll(from context:NSManagedObjectContext) -> [String: [Game]] {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
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

}
