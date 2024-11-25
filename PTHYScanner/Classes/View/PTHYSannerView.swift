//
//  ScanView.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 21/11/24.
//

import UIKit

public class PTHYSannerView: UIView {
    private var scanAnimationImage: UIImage {
        if PTHYConfig.scanAnimationStyle == .line {
            return PTHYSannerCommon.imageResourcePath("icon_scan_line")
        }else{
            return PTHYSannerCommon.imageResourcePath("icon_scan_net")
        }
    }
    private lazy var scanBorderWidth = PTHYConfig.scanBorderWidthRadio * PTHYSannerCommon.screenWidth
    
    private  lazy var scanBorderHeight = scanBorderWidth
    
    private lazy var scanBorderX = 0.5 * (1 - PTHYConfig.scanBorderWidthRadio) * PTHYSannerCommon.screenWidth
    
    private lazy var scanBorderY = (0.5 * (PTHYSannerCommon.screenHeight - scanBorderWidth) + PTHYConfig.scanAdjustCenterY)
    
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
        
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        addSubview(contentView)
        
        addSubview(frameImageView)
        frameImageView.frame = getRectFrameImageView
        
        var rect:CGRect?
        switch PTHYConfig.scanAnimationStyle {
        case .line:
            rect = CGRect(x: 0 , y: -(12 + 20), width: scanBorderWidth , height: 12)
        case .grid:
            rect = CGRect(x: 0, y: -(scanBorderHeight + 20), width: scanBorderWidth, height:scanBorderHeight)
        case .none:
            rect = nil
        }
        
        if let rect = rect {
            let imageView = UIImageView(image: scanAnimationImage.changeColor(PTHYConfig.cornerColor))
            PTHYSannerAnimation.shared.startWith(rect, contentView, imageView: imageView)
        }
    }
    
    public var getRectFrameImageView: CGRect {
        let outsideExcess = PTHYConfig.frameBorderWidth
        return CGRect(x: scanBorderX - outsideExcess, y: scanBorderY - outsideExcess, width: scanBorderWidth + (outsideExcess * 2), height: scanBorderHeight + (outsideExcess * 2))
    }
    
    lazy var frameImageView: UIImageView = {
        let view = UIImageView()
        view.image = PTHYConfig.frameImage
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
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
        
        PTHYConfig.backgroundColor.withAlphaComponent(PTHYConfig.backgroundAlpha).setFill()
        
        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setBlendMode(.destinationOut)
        
        let bezierPath = UIBezierPath(rect: CGRect(x: scanBorderX , y: scanBorderY , width: scanBorderWidth, height: scanBorderHeight))
        
        bezierPath.fill()
        
        context?.setBlendMode(.normal)
        
    }
    
}
