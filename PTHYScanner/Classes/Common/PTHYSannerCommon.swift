//
//  Common.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 21/11/24.
//

import Foundation

public class PTHYSannerCommon {
    
    private static let bundle = Bundle(for: PTHYSannerViewController.self)

    public static let screenWidth = UIScreen.main.bounds.width

    public static let screenHeight = UIScreen.main.bounds.height

    public static let statusHeight = UIApplication.shared.statusBarFrame.height
    
    public static func ImageResourcePath(_ name:String)-> UIImage{
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else{
            return UIImage()
        }
        return image
    }

    public enum ScanAnimationStyle {
        case `default`
        case grid
    }
}

