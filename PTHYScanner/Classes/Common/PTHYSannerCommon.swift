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
    
    public static func imageResourcePath(_ name:String)-> UIImage{
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else{
            return UIImage()
        }
        return image
    }
    
    public static func generateQrCode(string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        if let qrCodeImage = (filter?.outputImage) {
            return UIImage(ciImage:qrCodeImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)))
        }
        return nil
    }
    public enum ScanAnimationStyle {
        case line
        case grid
        case none
    }
}

