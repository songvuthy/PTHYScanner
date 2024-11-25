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

extension UIView{
    
    public func addSubViewToCenter(overlayImageView: UIImageView, width: CGFloat = 42, height: CGFloat = 42) {
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        self.addSubview(overlayImageView)
        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }
}
