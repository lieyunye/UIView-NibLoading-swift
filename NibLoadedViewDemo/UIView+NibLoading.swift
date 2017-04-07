//
//  UIView+NibLoading.swift
//  NibLoadedViewDemo
//
//  Created by lieyunye on 2017/4/6.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

import UIKit
import Foundation


extension UIView
{
    private struct AssociatedKeys {
        static var kUIViewNibLoading_associatedNibsKey = "kUIViewNibLoading_associatedNibsKey"
        static var kUIViewNibLoading_outletsKey = "kUIViewNibLoading_outletsKey"
    }
    
    class func _nibLoadingAssociatedNibWithName(nibName:String) -> UINib {
        let associatedNibs:Dictionary<String,AnyObject>? = objc_getAssociatedObject(self, &AssociatedKeys.kUIViewNibLoading_associatedNibsKey) as? Dictionary<String,AnyObject>
        var nib:UINib? = associatedNibs?[nibName] as? UINib;
        if nib == nil {
            let bundle = Bundle(for:self)
            nib = UINib(nibName:nibName, bundle: bundle)
            if nib != nil {
                var newNibs:Dictionary = Dictionary<String,AnyObject>()
                if associatedNibs != nil {
                    for item in (associatedNibs?.keys)! {
                        let key = item as String
                        newNibs[key] = associatedNibs?[key]
                    }
                }
                newNibs[nibName] = nib
                objc_setAssociatedObject(self, &AssociatedKeys.kUIViewNibLoading_associatedNibsKey, newNibs, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        return nib!
    }
    
    func loadContentsFromNibNamed(nibName:String){
        
        // Load the nib file, setting self as the owner.
        // The root view is only a container and is discarded after loading.
        let nib:UINib? = type(of:self)._nibLoadingAssociatedNibWithName(nibName: nibName)
        assert(nib != nil, "UIView+NibLoading : Can't load nib named \(nibName)");
        
        // Instantiate (and keep a list of the outlets set through KVC.)
        var outlets = Dictionary<String, AnyObject>()
        objc_setAssociatedObject(self, &AssociatedKeys.kUIViewNibLoading_outletsKey, outlets, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        let views:Array? = nib!.instantiate(withOwner: self, options: nil)
        assert(views != nil, "UIView+NibLoading : Can't instantiate nib named \(nibName)");
        objc_setAssociatedObject(self, &AssociatedKeys.kUIViewNibLoading_outletsKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        
        // Search for the first encountered UIView base object
        var containerView:UIView? = nil
        for view in views! {
            if let v = view as? UIView {
                containerView = v
                break
            }
        }
        assert(containerView != nil, "UIView+NibLoading : : There is no container UIView found at the root of nib \(nibName)");
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        
        if self.bounds.equalTo(CGRect.zero) {
            // `self` has no size : use the containerView's size, from the nib file
            self.bounds = (containerView?.bounds)!
        }else {
            // `self` has a specific size : resize the containerView to this size, so that the subviews are autoresized.
            containerView?.bounds = self.bounds
        }
        
        // Save constraints for later
        let constraints:Array? = containerView?.constraints
        // reparent the subviews from the nib file
        for view in (containerView?.subviews)! {
            self.addSubview(view)
        }
        
        // Recreate constraints, replace containerView with self
        for item in constraints! {
            let oldConstraint = item as NSLayoutConstraint
            var firstItem = oldConstraint.firstItem
            var secondItem = oldConstraint.secondItem
            if firstItem as! NSObject == containerView! {
                firstItem = self
            }
            if secondItem as! NSObject == containerView! {
                secondItem = self
            }
            let newConstraint = NSLayoutConstraint.init(item: firstItem, attribute: oldConstraint.firstAttribute, relatedBy: oldConstraint.relation, toItem: secondItem, attribute: oldConstraint.secondAttribute, multiplier: oldConstraint.multiplier, constant: oldConstraint.constant)
            self.addConstraint(newConstraint)
            
            // If there was outlet(s) to the old constraint, replace it with the new constraint.
            for key in outlets.keys {
                let c = outlets[key] as! NSLayoutConstraint
                if c == oldConstraint {
                    assert(self.value(forKey: key) as! NSLayoutConstraint == oldConstraint, "UIView+NibLoading : Unexpected value for outlet \(key) of view \(self). Expected \(oldConstraint), found \(String(describing: self.value(forKey: key))).");
                    self.setValue(newConstraint, forKey: key)
                }
            }
        }
    }
    
    open override func setValue(_ value: Any?, forKey key: String){
        // Keep a list of the outlets set during nib loading.
        // (See above: This associated object only exists during nib-loading)
        var outlets:Dictionary<String,AnyObject>? = objc_getAssociatedObject(self, &AssociatedKeys.kUIViewNibLoading_outletsKey) as? Dictionary<String,AnyObject>
        outlets?[key] = value as AnyObject
        super.setValue(value, forKey: key)
    }
    
    func loadContentsFromNib() {
        let className:String = String(describing:type(of: self))
        self.loadContentsFromNibNamed(nibName: className.components(separatedBy: ".").last!)
    }
}

class NibLoadedView: UIView {
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.loadContentsFromNib()
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        self.loadContentsFromNib()
    }
    
}



