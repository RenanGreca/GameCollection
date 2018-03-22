//
//  PlatformTableViewCell.swift
//  GameCollection
//
//  Created by Cinq Technologies on 22/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class PlatformTableViewCell: UITableViewCell {
    
    class CompanyView:UIView {
        
        let name:UILabel
        
        init(company: Company) {
            self.name = UILabel()
            self.name.translatesAutoresizingMaskIntoConstraints = false
            self.name.font = UIFont.systemFont(ofSize: 12)
            self.name.textColor = .white
            self.name.text = company.name
            self.name.textAlignment = .center
            self.name.sizeToFit()
            
            super.init(frame: CGRect(x: 0, y: 0, width: self.name.frame.width+12.0, height: 16.0))
            
            self.backgroundColor = company.color
            self.layer.cornerRadius = 3.0
            
            self.addSubview(self.name)
            
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
            
            self.addConstraints([titleX,titleY])
            
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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var gameCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func draw(company: Company) {
        for subview in self.companyView.subviews {
            subview.removeFromSuperview()
        }
        
        
        let view = CompanyView(company: company)
        
        self.companyView.addSubview(view)
        
    }
    
}
