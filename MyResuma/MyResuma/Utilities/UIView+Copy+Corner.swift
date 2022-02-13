//
//  UIView+Corner.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import UIKit

extension UIView
{
    func copyView() -> UIView?
    {
        guard let archivedData =  try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        else {
           return nil
       }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData) as? UIView
//        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
}
