//
//  PTHYSannerConfiguration.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 22/11/24.
//

import Foundation

/// Typealias for code prettiness
public var PTHYConfig: PTHYSannerConfiguration { return PTHYSannerConfiguration.shared }

public class PTHYSannerConfiguration {
    public static var shared: PTHYSannerConfiguration = PTHYSannerConfiguration()
    
    // configuration specific settings
    public var scanAnimationStyle:PTHYSannerCommon.ScanAnimationStyle = .default
    
    public var borderColor: UIColor = .white
    
    public var borderLineWidth:CGFloat = 1
    
    public var cornerColor:UIColor = .white
    
    public var backgroundAlpha:CGFloat = 0.6
    
    public var scanBorderWidthRadio:CGFloat = 0.6
    
    public var frameImage:UIImage = PTHYSannerCommon.ImageResourcePath("icon_scan_frame")
    
    public var showFrameImage:Bool = true
    
    public var adjustmentY:CGFloat = 0.0
}
