//
//  GameCollectionTests.swift
//  GameCollectionTests
//
//  Created by Cinq Technologies on 14/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import XCTest
import CoreData
//import SwiftyJSON
@testable import GameCollection

enum TestError: Error {
    case fetchFail
}

class GameCollectionTests: XCTestCase {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var gameCount = 0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deleteAllGames()
        
        super.tearDown()
    }
    
    func test00InsertGameAndFetch() {
        
        let guid = "3030-56733"
        let data: [String: Any] = [
            Fields.title.rawValue: "Super Mario Odyssey",
            Fields.guid.rawValue: guid,
            Fields.image.rawValue: [
                Fields.imageScale.rawValue: "https://www.giantbomb.com/api/image/scale_avatar/2972168-smoboxartfinal.jpg"
            ],
            Fields.releaseDate.rawValue: "2017-10-27 00:00:00",
            Fields.platforms.rawValue: [
                Fields.title.rawValue: "Nintendo Switch",
                Fields.platformAbbrev.rawValue: "NSW"
            ]
        ]
        
        let game = Game(with: data)
        
        game.insert(to: context)
        gameCount += 1
        
        if let fetchedGame = Game.fetchOne(from: context) {
            XCTAssertEqual(guid, fetchedGame.guid, "Values are not equal!")
        } else {
            XCTAssertTrue(false, "Not able to fetch object!")
        }
        
    }
    
    func test01InsertMultipleGamesAndFetch() {
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "TLoZ", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if let json = jsonObj {
                    if let results = json["results"] as? [[String: Any]] {
                        for result in results {
                            let game = Game(with: result)
                            game.insert(to: context)
                            gameCount += 1
                        }
                    }
                } else {
                    XCTAssertTrue(false, "Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                XCTAssertTrue(false, error.localizedDescription)
            }
        } else {
            XCTAssertTrue(false, "Invalid filename/path.")
        }
        
        let games = Game.fetchAll(from: context)
        
        XCTAssertEqual(games.count, gameCount, "Incorrect number of games!")
        
    }
    
    func test10GetGamesFromAPIWithQuery() {
        let promise = expectation(description: "List of games")
        
        let query = "The Legend of Zelda"
        let gameGrabber = GameGrabber()
        
        gameGrabber.searchForGamesWith(query: query) {
            error in
            
            if let e = error {
                XCTAssertTrue(false, e.localizedDescription)
            }
            
            XCTAssert(gameGrabber.count > 0, "Did not get games from API!")
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test11GameTitleSplit() {
        var title = "The Legend of Zelda: Breath of the Wild"
        
        var gameTitleArray = title.split(separator: ":", maxSplits: 1)
        
        var firstTitle = String(describing: gameTitleArray.first!)
        XCTAssertEqual("The Legend of Zelda", firstTitle)

        if let secondTitle = gameTitleArray.last {
            let subtitle = String(describing: secondTitle).trimmingCharacters(in: CharacterSet.whitespaces)
            XCTAssertEqual("Breath of the Wild", subtitle)
        }
        
        title = "Phoenix Wright: Ace Attorney: Justice for All"
        
        gameTitleArray = title.split(separator: ":", maxSplits: 1)
        
        firstTitle = String(describing: gameTitleArray.first!)
        XCTAssertEqual("Phoenix Wright", firstTitle)
        
        if let secondTitle = gameTitleArray.last {
            let subtitle = String(describing: secondTitle).trimmingCharacters(in: CharacterSet.whitespaces)
            XCTAssertEqual("Ace Attorney: Justice for All", subtitle)
        }

    }
    
    func deleteAllGames()
    {
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
            print("Detele all data in Game error : \(error) \(error.userInfo)")
        }
    }
    
}
