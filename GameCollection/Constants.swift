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
