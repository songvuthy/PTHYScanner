
import UIKit

public class PTHYSannerAnimation:NSObject{
    
    static let shared:PTHYSannerAnimation = {
        
        let instance = PTHYSannerAnimation()
        
        return instance
    }()
    
    lazy var animationImageView = UIImageView()
    
    var displayLink:CADisplayLink?
    
    var tempFrame:CGRect?
    
    var contentHeight:CGFloat?
    
    func startWith(_ rect:CGRect, _ parentView:UIView, imageView:UIImageView) {
        
        tempFrame = rect
        
        imageView.frame = tempFrame ?? CGRect.zero
        
        animationImageView = imageView
        
        contentHeight = parentView.bounds.height
    
        parentView.addSubview(imageView)
        
        setupDisplayLink()
        
    }
    
    
    @objc func animation() {
        
        if animationImageView.frame.maxY > contentHeight! + 20 {
            animationImageView.frame = tempFrame ?? CGRect.zero
        }
        
        animationImageView.transform = CGAffineTransform(translationX: 0, y: 2).concatenating(animationImageView.transform)
        
    }
    
    
    func setupDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(animation))
        
        displayLink?.add(to: .current, forMode: RunLoopMode.commonModes)
        
        displayLink?.isPaused = true
        
    }
    
    
    func startAnimation() {
        
        displayLink?.isPaused = false
        
    }
    
    
    func stopAnimation() {
        
        displayLink?.isPaused = true
        
    }
    
}
