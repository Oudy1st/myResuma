//
//  ErrorAlert.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation
import UIKit

class ErrorAlert {
    var title:String?
    var message:String?
    
    private var alertActions:[UIAlertAction] = [UIAlertAction]()
    
    private let defaultTitle = "Error"
    private var defaultAction:UIAlertAction {
        get {
            return UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        }
    }
    
    init(_ title:String? = nil, message:String? = nil) {
        self.title = title
        self.message = message
    }
    
    func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        self.alertActions.append(UIAlertAction.init(title: title, style: style, handler: handler))
    }
    
    func generateAlertController() -> UIAlertController {
        let alertC = UIAlertController.init(title: title ?? defaultTitle, message: message, preferredStyle: .alert)
        if alertActions.count > 0 {
            alertActions.forEach { action in
                alertC.addAction(action)
            }
        }
        else {
            alertC.addAction(defaultAction)
        }
        
        return alertC
    }
}

