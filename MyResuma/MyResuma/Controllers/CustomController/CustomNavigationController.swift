//
//  CustomNavigationController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import UIKit

class CustomNavigationController: UINavigationController,UINavigationControllerDelegate {
    @IBInspectable var backImage : UIImage!  = #imageLiteral(resourceName: "ic_back")
    
    var backButtonObserve:NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let navBarAppearance = UINavigationBarAppearance()
        // Will remove the shadow and set background back to clear
        navBarAppearance.configureWithTransparentBackground()

        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.configureWithDefaultBackground()
        
        
        
        self.delegate = self;
        
        if backImage != nil {
            let yourBackImage = backImage
            self.navigationBar.backIndicatorImage = yourBackImage
            self.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
            self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    
    
    
    @objc func popViewController(){
        self.popViewController(animated: true);
    }
    @objc func popToRootViewController(){
        self.dismiss(animated: true) { () -> Void in
            
        };
    }
}

