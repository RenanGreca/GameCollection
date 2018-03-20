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

// Field keys for the API
// Used for indexing JSON objects; safer than using String literals
enum Fields:String {
    case guid = "guid"
    case image = "image"
    case imageScale = "small_url"
    case name = "name"
    case releaseDate = "original_release_date"
    case platforms =  "platforms"
    case abbreviation = "abbreviation"
    case id = "id"
    case results = "results"
    case company = "company"
}

// Context constant for CoreData
let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
