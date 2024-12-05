//
//  PTHYSannerConfiguration.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 22/11/24.
//

import AVFoundation

/// Typealias for code prettiness
public var PTHYConfig: PTHYSannerConfiguration { return PTHYSannerConfiguration.shared }

open class PTHYSannerConfiguration {
    public static let shared: PTHYSannerConfiguration = PTHYSannerConfiguration()
    
    // configuration specific settings
    open var scanAnimationStyle:PTHYSannerCommon.ScanAnimationStyle = .line
    
    open var metadata:[AVMetadataObject.ObjectType] = AVMetadataObject.ObjectType.metadata

    open var cornerColor:UIColor = .white
    
    open var backgroundColor:UIColor = .black
    
    open var backgroundAlpha:CGFloat = 0.6
    
    open var scanBorderWidthRadio:CGFloat = 0.6
    
    open var scanAdjustCenterY:CGFloat = 0.0
    
    open var frameImage:UIImage = PTHYSannerCommon.imageResourcePath("icon_scan_frame")
    
    open var frameBorderWidth:CGFloat = 4
    
    open var isScanningFullScreen:Bool = true
    
    open var showQrCodeScanned:Bool = true
    
    open var qrCodeScannedAdjustCenterY:CGFloat = 0.0
    
    open var customHeaderView: UIView = UIView()
    
    open var customFooterView: UIView = UIView()
}
