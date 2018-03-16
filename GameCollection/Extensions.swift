//
//  Extensions.swift
//  GameCollection
//
//  Created by Cinq Technologies on 16/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    // Allows us to set search bar text color
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
    
}
