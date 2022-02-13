//
//  UIButton+Action.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 12/2/2565 BE.
//

import UIKit

struct UIViewItem {
    var key:String = ""
    var value:Any
}

extension UIControl {
    
    enum ItemKey:String {
        case actionId = "actionId"
        case actionBlock = "actionBlock"
    }
    
    private func getViewItem(key:String) -> UIViewItem? {

        if self.accessibilityElements == nil {
            return nil
        }
        
        for item in self.accessibilityElements!.filter({ $0.self as? UIViewItem != nil }) {
           if let viewItem = item as? UIViewItem,
              viewItem.key == key {
               return viewItem
           }
        }
        return nil
    }
    
    private func setViewItem(key:String, value:Any) {

        if self.accessibilityElements == nil {
            self.accessibilityElements = [Any]()
        }
        
        if self.getViewItem(key: key) != nil {
            self.accessibilityElements?.removeAll(where: { (itemAny) -> Bool in
                if let item = itemAny as? UIViewItem,
                item.key == key {
                    return true
                }
                else {
                    return false
                }
            })
        }
        
        self.accessibilityElements?.append(UIViewItem(key: key, value: value))
    }
    
}

extension UIControl {
    
    @objc func actionBlock()  {
        if let actionItem = self.getViewItem(key: UIControl.ItemKey.actionBlock.rawValue),
           let action = actionItem.value as? () -> () {
            action()
        }
    }
    
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        
        self.setViewItem(key: UIControl.ItemKey.actionBlock.rawValue, value: action)
        addTarget(self, action: #selector(self.actionBlock), for: controlEvents)
    }
}
