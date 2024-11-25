//
//  ScanView.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 21/11/24.
//

import UIKit

public class PTHYSannerView: UIView {
    private var scanAnimationImage: UIImage {
        if PTHYConfig.scanAnimationStyle == .default {
            return PTHYSannerCommon.ImageResourcePath("icon_scan_line")
        }else{
            return PTHYSannerCommon.ImageResourcePath("icon_scan_net")
        }
    }

    
    lazy var scanBorderWidth = PTHYConfig.scanBorderWidthRadio * PTHYSannerCommon.screenWidth
    
    lazy var scanBorderHeight = scanBorderWidth
    
    lazy var scanBorderX = 0.5 * (1 - PTHYConfig.scanBorderWidthRadio) * PTHYSannerCommon.screenWidth
    
    lazy var scanBorderY = 0.5 * (PTHYSannerCommon.screenHeight - scanBorderWidth)
    
    lazy var contentView = UIView(frame: CGRect(x: scanBorderX, y: scanBorderY, width: scanBorderWidth, height:scanBorderHeight))
    
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .clear
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        drawScan(rect)
        
        var rect:CGRect?
        
        let imageView = UIImageView(image: scanAnimationImage.changeColor(PTHYConfig.cornerColor))
        
        if PTHYConfig.scanAnimationStyle == .default {
            rect = CGRect(x: 0 , y: -(12 + 20), width: scanBorderWidth , height: 12)
            
        }else{
            rect = CGRect(x: 0, y: -(scanBorderHeight + 20), width: scanBorderWidth, height:scanBorderHeight)
        }
        
        contentView.backgroundColor = .clear
        
        contentView.clipsToBounds = true
        
        addSubview(contentView)
        
        
        PTHYSannerAnimation.shared.startWith(rect!, contentView, imageView: imageView)
        
    }
    
    lazy var frameImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
}



// MARK: - CustomMethod
extension PTHYSannerView{
    
    
    func startAnimation() {
        PTHYSannerAnimation.shared.startAnimation()
    }
    
    func stopAnimation() {
        PTHYSannerAnimation.shared.stopAnimation()
    }
    
    func drawScan(_ rect: CGRect) {
        
        UIColor.black.withAlphaComponent(PTHYConfig.backgroundAlpha).setFill()
        
        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setBlendMode(.destinationOut)
        
        let bezierPath = UIBezierPath(rect: CGRect(x: scanBorderX + 0.5 * PTHYConfig.borderLineWidth, y: scanBorderY + 0.5 * PTHYConfig.borderLineWidth, width: scanBorderWidth - PTHYConfig.borderLineWidth, height: scanBorderHeight - PTHYConfig.borderLineWidth))
        
        bezierPath.fill()
        
        context?.setBlendMode(.normal)
        
        let borderPath = UIBezierPath(rect: CGRect(x: scanBorderX, y: scanBorderY, width: scanBorderWidth, height: scanBorderHeight))
        
        borderPath.lineCapStyle = .butt
        
        borderPath.lineWidth = PTHYConfig.borderLineWidth
        
        PTHYConfig.borderColor.set()
        
        borderPath.stroke()
        
    }
    
}
