//
//  GameGrabber.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import SwiftHTTP

typealias CompletionClosure = (_ error: Error?) -> Void

class GameGrabber {
    
    private var games:[Game] = []
    
    var count:Int {
        return self.games.count
    }
    
    var list:[Game] {
        return self.games
    }
    
    func clear() {
        self.games = []
    }
    
    func searchForGamesWith(query: String, _ completion: CompletionClosure? ) {
        self.games = []
        
        var storedError: Error?
     
//        let params:[String: String] = [
//            "api_key": apiKey,
//            "format": "json",
//            "resources": "game",
//            "limit": "50",
//            "query": "\"\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\"",
//            "field_list": "guid,image,name,original_release_date,platforms,publisher",
//        ]
        
        let url = "\(apiURL)search/?api_key=\(apiKey)&format=json&limit=50&resources=game&field_list=guid%2Cimage%2Cname%2Coriginal_release_date%2Cplatforms%2Cpublisher&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        
        let group = DispatchGroup()
        
        group.enter()

        HTTP.GET(url) {
            response in
            
            if let err = response.error {
                storedError = err
            }
            print("opt finished: \(response.description)")
            print("data is: \(response.data)") // access the response of the data with response.data
            
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any]
                if let json = jsonObj {
                    if let results = json["results"] as? [[String: Any]] {
                        for result in results {
                            let game = Game(with: result)
                            self.games.append(game)
                        }
                    }
                }
            } catch let error {
                storedError = error
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion?(storedError)
        }
        
    }
    
}
