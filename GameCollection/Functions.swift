//
//  Functions.swift
//  GameCollection
//
//  Created by Cinq Technologies on 19/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

func clearAllData() {
    Game.deleteAll()
    Platform.deleteAll()
    Company.deleteAll()
}
