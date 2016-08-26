//
//  VennPriceLabel.swift
//  venndor
//
//  Created by David Tamrazov on 2016-08-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class VennPriceLabel: UIImageView {
    var priceLabel : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, price: Int) {
        super.init(frame: frame)
        //create the price container
        self.image = UIImage(named: "venn.png")
        
        //create the price label
        let priceFrame = CGRect(x: frame.width * 0.15, y: frame.origin.y * 0.15 - 2, width: frame.width * 0.6, height: frame.height * 0.8)
        priceLabel = UILabel(frame:priceFrame)
        
        priceLabel.text = "$\(price)"
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.font = priceLabel.font.fontWithSize(30)
        priceLabel.textAlignment = .Center
        self.addSubview(priceLabel)
    }
    
    init(containerView: UIView, price: Int, adjustment: Int?) {
        var frameX = containerView.frame.size.width - 40
        if let adj = adjustment {
            frameX += CGFloat(adj)
        }
        
        let priceFrame = CGRectMake(frameX, -9, containerView.frame.size.width * 0.50, containerView.frame.size.height * 0.35)
        
        //create the price container
        super.init(frame: priceFrame)
        self.image = UIImage(named: "venn.png")
        
        //create the price label
        let priceLabel = UILabel(frame: CGRect(x: self.frame.size.width * 0.2, y:0, width: self.frame.width, height: self.frame.height))
        
        priceLabel.text = "$\(price)"
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.font = priceLabel.font.fontWithSize(15)
        self.addSubview(priceLabel)
    }
}
