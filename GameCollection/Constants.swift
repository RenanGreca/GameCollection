//
//  Constants.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let apiURL = "https://www.giantbomb.com/api/"
let apiKey = "5bd368f7ac8e636668e952a16f2e58fce297e516"

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

let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
