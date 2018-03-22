//
//  GameTableViewCell.swift
//  GameCollection
//
//  Created by Cinq Technologies on 21/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    class PlatformView:UIView {
        
        let name:UILabel

        init(platform: Platform, spacing: (x: CGFloat, y: CGFloat), owned: Bool) {
            self.name = UILabel()
            self.name.translatesAutoresizingMaskIntoConstraints = false
            self.name.font = UIFont.systemFont(ofSize: 12)
            self.name.textColor = .white
            self.name.text = platform.abbreviation
            self.name.textAlignment = .center
            self.name.sizeToFit()
            
            super.init(frame: CGRect(x: spacing.x, y: spacing.y, width: self.name.frame.width+12.0, height: 16.0))
//            self.translatesAutoresizingMaskIntoConstraints = false
            
            if owned {
                self.backgroundColor = platform.company.color
            } else {
                self.backgroundColor = .black
            }
            self.layer.cornerRadius = 3.0
            
            self.addSubview(self.name)
//            self.updateConstraints()
            
        }
        
        override func updateConstraints() {
            let titleX = NSLayoutConstraint(item: self.name,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .centerX,
                                            multiplier: 1,
                                            constant: 0)
            
            let titleY = NSLayoutConstraint(item: self.name,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .centerY,
                                            multiplier: 1,
                                            constant: 0)
            
//            let titleLeading = NSLayoutConstraint(item: self.name,
//                                                  attribute: .leading,
//                                                  relatedBy: .equal,
//                                                  toItem: self,
//                                                  attribute: .leading,
//                                                  multiplier: 1,
//                                                  constant: 6)
//
//            let titleTrailing = NSLayoutConstraint(item: self.name,
//                                                   attribute: .trailing,
//                                                   relatedBy: .equal,
//                                                   toItem: self,
//                                                   attribute: .trailing,
//                                                   multiplier: 1,
//                                                   constant: 6)
            
            self.addConstraints([titleX,titleY])
//                                 titleBottom,
//                                 titleLeading,
//                                 titleTrailing])
            
            self.sizeToFit()
            
            super.updateConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.name = UILabel()
            super.init(coder: aDecoder)
        }
        
        override var intrinsicContentSize: CGSize {
            return UILayoutFittingExpandedSize
        }
    }

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var platformsView: UIView!
    @IBOutlet weak var samplePlatformView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func draw(ownedPlatforms:[Platform], allPlatforms:[Platform]) {        
        
        for subview in self.platformsView.subviews {
            subview.removeFromSuperview()
        }
        
        var counter:Int = 0
        var spacing:(x: CGFloat, y:CGFloat) = (x: 0, y: 0)
        for platform in ownedPlatforms {
            counter += 1
            
            let view = PlatformView(platform: platform, spacing: spacing, owned: true)
            
            self.platformsView.addSubview(view)
            
            spacing.x += view.frame.width + 6.0
            
            if counter == 7 {
                spacing.y += 22.0
                spacing.x = 0.0
                
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height+22.0)
                
                counter = 0
            }
        }
        
        for platform in allPlatforms where (!ownedPlatforms.contains(platform)) {
            counter += 1

            let view = PlatformView(platform: platform, spacing: spacing, owned: false)

            self.platformsView.addSubview(view)
            
            spacing.x += view.frame.width + 6.0
            
            if counter == 7 {
                spacing.y += 22.0
                spacing.x = 0.0
                
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height+22.0)
                
                counter = 0
            }
        }
        
    }
    
    func draw(ownedPlatforms:[Platform]) {
        for subview in self.platformsView.subviews {
            subview.removeFromSuperview()
        }
        
        var counter:Int = 0
        var spacing:(x: CGFloat, y:CGFloat) = (x: 0, y: 0)
        for platform in ownedPlatforms {
            counter += 1

            let view = PlatformView(platform: platform, spacing: spacing, owned: true)

            self.platformsView.addSubview(view)
            
            spacing.x += view.frame.width + 6.0
            
            if counter == 7 {
                spacing.y += 22.0
                spacing.x = 0.0
                
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height+22.0)
                
                counter = 0
            }
        }
    }
    
}
