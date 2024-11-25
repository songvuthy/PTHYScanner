//
//  UIViewController+Extensions.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

extension UIViewController{
    
    
    public func add(_ childController:UIViewController) {
        childController.willMove(toParentViewController: self)
        addChildViewController(childController)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
        
    }    
}
