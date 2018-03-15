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
}

class Game {
    
    var title: String
    var guid: String
    var boxart: String
    var platforms: [[String: String]]
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
                   let platformName = platform[Fields.title.rawValue] as? String {
                    self.platforms.append([
                        Fields.platformAbbrev.rawValue: abbreviation,
                        Fields.title.rawValue: platformName
                        ])
                }
            }
            
        }
    }
    
    init(from managedGame:GameManagedObject) {
        self.title = managedGame.title!
        self.guid = managedGame.guid!
        self.boxart = managedGame.boxart!
        
        if let date = managedGame.releaseDate as Date? {
            self.releaseDate = date
        }
        
        self.platforms = managedGame.platforms as! [[String: String]]
        
    }
    
    func insert(to context:NSManagedObjectContext) {
        let game = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context) as! GameManagedObject
        
        game.title = self.title
        game.guid = self.guid
        game.releaseDate = self.releaseDate// as NSDate?
        game.boxart = self.boxart// as NSData?
        game.platforms = self.platforms as NSObject
    
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
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        let searchFilter = NSPredicate(format: "guid = %@", guid)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject]
        
        if let managedGame = results?.first {
            return Game(from: managedGame)
        } else {
            return nil
        }
    }
    
    class func fetchAll(from context:NSManagedObjectContext) -> [Game] {
        let fetchRequest = NSFetchRequest<GameManagedObject>(entityName: "Game")
        
        var game = [Game]()
        
        if let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [GameManagedObject] {
            for result in results {
                game.append(Game(from: result))
            }
        }
        
        return game

    }

}
