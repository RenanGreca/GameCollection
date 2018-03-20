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
    
    var gameCount = 0
    var platformCounts = [String: Int]()
    
    override func setUp() {
        super.setUp()
        
        Game.deleteAll()
        Platform.deleteAll()
        Company.deleteAll()
    }
    
    override func tearDown() {
        Game.deleteAll()
        Platform.deleteAll()
        Company.deleteAll()
        
        super.tearDown()
    }
    
    func test00InsertGameAndFetch() {
        
        let guid = "3030-56733"
        let platforms = [
            [
                Fields.name.rawValue: "Nintendo Switch",
                Fields.abbreviation.rawValue: "NSW",
                Fields.id.rawValue: 157
            ]
        ]
        let data: [String: Any] = [
            Fields.name.rawValue: "Super Mario Odyssey",
            Fields.guid.rawValue: guid,
            Fields.image.rawValue: [
                Fields.imageScale.rawValue: "https://www.giantbomb.com/api/image/scale_avatar/2972168-smoboxartfinal.jpg"
            ],
            Fields.releaseDate.rawValue: "2017-10-27 00:00:00",
            Fields.platforms.rawValue: platforms
        ]
        
        let game = Game(with: data)
        var platformCount = 0
        for platform in game.platforms {
            game.insert(platform: platform)
            platformCount += 1
        }
        gameCount += 1
        platformCounts[game.guid] = platformCount
        
        sleep(10)
        
        if let fetchedGame = Game.fetchOne() {
            XCTAssertEqual(guid, fetchedGame.guid, "Values are not equal!")
            
            print(fetchedGame.platforms)
            print(fetchedGame.platforms.first!.company!.name)
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
                            var platformCount = 0
                            for platform in game.platforms {
                                game.insert(platform: platform)
                                platformCount += 1
                            }
                            gameCount += 1
                            platformCounts[game.guid] = platformCount
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
        
        let gamesLetters = [[Game]](Game.fetchAllInCollection().values)
        
        var gamesCount = 0
        for games in gamesLetters {
            gamesCount += games.count
            for game in games {
                XCTAssertEqual(game.platforms.count, platformCounts[game.guid], "Incorrect number of platforms for game \(game.title)!")
            }
        }
        
        XCTAssertEqual(gamesCount, gameCount, "Incorrect number of games!")
        
    }
    
    func test12RemovePlatformFromGame() {
        let guid = "3030-56733"
        let platforms = [
            [
                Fields.name.rawValue: "Nintendo Switch",
                Fields.abbreviation.rawValue: "NSW",
                Fields.id.rawValue: 0
            ],
            [
                Fields.name.rawValue: "Wii U",
                Fields.abbreviation.rawValue: "WiiU",
                Fields.id.rawValue: 1
            ]
        ]
        let data: [String: Any] = [
            Fields.name.rawValue: "The Legend of Zelda: Breath of the Wild",
            Fields.guid.rawValue: guid,
            Fields.image.rawValue: [
                Fields.imageScale.rawValue: "https://www.giantbomb.com/api/image/scale_avatar/2972168-smoboxartfinal.jpg"
            ],
            Fields.releaseDate.rawValue: "2017-10-27 00:00:00",
            Fields.platforms.rawValue: platforms
        ]
        
        let game = Game(with: data)
        var platformCount = 0
        for platform in game.platforms {
            game.insert(platform: platform)
            platformCount += 1
        }
        gameCount += 1
        platformCounts[game.guid] = platformCount
        
        if let fetchedGame = Game.fetchOne(),
            let platform = fetchedGame.platforms.first {
                
            fetchedGame.remove(platform: platform)
            
            XCTAssertEqual(fetchedGame.platforms.count, platformCount - 1)
        } else {
            XCTAssertTrue(false)
        }
        
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
    
    func test11GetCompanyForPlatform() {
        let promise = expectation(description: "A company")
        
        let platform = Platform(id: 32, abbreviation: "XBOX", name: "Xbox")
        
        let gameGrabber = GameGrabber()
        
        gameGrabber.findCompanyForPlatformWith(id: platform.id) {
            company, error in
            
            if let company = company {
                XCTAssertEqual(company.id, 340)
                platform.company = company
                promise.fulfill()
            } else {
                XCTAssertTrue(false)
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func test12SetCompanyForPlatform() {
        let platform = Platform(id: 32, abbreviation: "XBOX", name: "Xbox")
        
        let managedPlatform = platform.insert()
        sleep(10)
        XCTAssertEqual(managedPlatform.company!.id, 340)
    }
    
    func test20GameTitleSplit() {
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
    
}
