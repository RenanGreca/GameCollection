//
//  GameTitleView.swift
//  GameCollection
//
//  Created by Cinq Technologies on 16/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

// Tried using this for a custom header title, but it didn't work out.
class GameTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    var titleLabel: UILabel?
//    var subtitleLabel: UILabel?
//    
//    
//    init(title: String) {
//        let gameTitleArray = title.split(separator: ":", maxSplits: 1)
//        
//        let firstTitle = String(describing: gameTitleArray.first!)
//        
//        self.titleLabel = UILabel()
//        self.titleLabel!.frame = CGRect(x: 0, y: 0, width: 400, height: 25)
//        self.titleLabel!.backgroundColor = .clear
//        self.titleLabel!.numberOfLines = 1
//        self.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
//        self.titleLabel!.textAlignment = .center
//        self.titleLabel!.textColor = UIColor.white
//        self.titleLabel!.text = firstTitle+":"
//        
//        var height = 25
//        
//        if let secondTitle = gameTitleArray.last {
//            let subtitle = String(describing: secondTitle).trimmingCharacters(in: CharacterSet.whitespaces)
//            
//            self.subtitleLabel = UILabel()
//            self.subtitleLabel!.frame = CGRect(x: 0, y: 40, width: 400, height: 20)
//            self.subtitleLabel!.backgroundColor = .clear
//            self.subtitleLabel!.numberOfLines = 1
//            self.subtitleLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.black)
//            self.subtitleLabel!.textAlignment = .center
//            self.subtitleLabel!.textColor = UIColor.white
//            self.subtitleLabel!.text = subtitle
//            
//            height += 25
//        }
//        
//        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: height))
//        
//        self.addSubview(self.titleLabel!)
//        
//        if let subtitle = self.subtitleLabel {
//            self.addSubview(subtitle)
//        }
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }

}
