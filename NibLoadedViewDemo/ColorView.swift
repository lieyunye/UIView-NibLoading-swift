//
//  ColorView.swift
//  NibLoadedViewDemo
//
//  Created by lieyunye on 2017/4/7.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

import UIKit

class ColorView: NibLoadedView {
    @IBOutlet weak var swatch: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    private var _color:UIColor = UIColor.clear
    
    var color:UIColor {
        
        get {
            return _color
        }

        set {
            _color = newValue
            
            self.swatch.backgroundColor = newValue
            var red:CGFloat = 0.0
            var green:CGFloat = 0.0
            var blue:CGFloat = 0.0
            var alpha:CGFloat = 0.0
            
            _color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            self.codeLabel.text = "#\(String(format:"%2X",Int(red * 0xFF)))\(String(format:"%2X",Int(green * 0xFF)))\(String(format:"%2X",Int(blue * 0xFF)))"
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
