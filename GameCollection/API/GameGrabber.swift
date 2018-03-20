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
typealias CompanyClosure = (_ company: Company?, _ error: Error?) -> Void

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
    
    let apiURL = "https://www.giantbomb.com/api/"
    
    let apiKey = "5bd368f7ac8e636668e952a16f2e58fce297e516"
    
    // Standard game search
    func searchForGamesWith(query: String, _ completion: CompletionClosure? ) {
        self.games = []
        
        var storedError: Error?
     
        // For some reason, SwiftHTTP didn't like the params Dictionary.
        // TODO: Find out why and try to fix it.
        
//        let params:[String: String] = [
//            "api_key": apiKey,
//            "format": "json",
//            "resources": "game",
//            "limit": "50",
//            "query": "\"\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\"",
//            "field_list": "guid,image,name,original_release_date,platforms,publisher",
//        ]
        
        let url = "\(apiURL)search/?api_key=\(apiKey)&format=json&limit=50&resources=game&field_list=guid%2Cimage%2Cname%2Coriginal_release_date%2Cplatforms%2Cpublisher&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        
        HTTP.GET(url) {
            response in
            
            if let err = response.error {
                storedError = err
            }
            
            // TODO: Check necessity of further error handling
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any]
                if let json = jsonObj {
                    if let results = json[Fields.results.rawValue] as? [[String: Any]] {
                        for result in results {
                            let game = Game(with: result)
                            self.games.append(game)
                        }
                    }
                }
            } catch let error {
                storedError = error
            }
            
            completion?(storedError)
        }
        
    }
    
    // Check the company that owns the platform
    func findCompanyForPlatformWith(id: Int, _ completion: CompanyClosure? ) {
        var company:Company?
        
        var storedError: Error?
                
        let url = "\(apiURL)platform/\(id)/?api_key=\(apiKey)&format=json&field_list=company"
        
        HTTP.GET(url) {
            response in
            
            if let err = response.error {
                storedError = err
            }

            // TODO: Check necessity of further error handling
            do {
                if  let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any],
                    let results = json[Fields.results.rawValue] as? [String: Any],
                    let result = results[Fields.company.rawValue] as? [String: Any] {
                        
                    company = Company(with: result)

                }
            } catch let error {
                storedError = error
            }
            
            completion?(company, storedError)
        }
        
    }
    
}
