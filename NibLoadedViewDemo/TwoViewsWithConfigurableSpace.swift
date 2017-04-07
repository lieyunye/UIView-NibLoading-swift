//
//  TwoViewsWithConfigurableSpace.swift
//  NibLoadedViewDemo
//
//  Created by lieyunye on 2017/4/7.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

import UIKit

@IBDesignable
class TwoViewsWithConfigurableSpace: NibLoadedView {
    @IBOutlet weak var spaceBetweenViews: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var _space:CGFloat = 0
    
    @IBInspectable var space:CGFloat {
        get {
            return _space
        }
        
        set {
            _space = newValue
            self.spaceBetweenViews.constant = _space
        }
        
    }

}
