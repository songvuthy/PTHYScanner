
import UIKit

extension UIImage{
    
    public func changeColor(_ color : UIColor) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        color.setFill()
        
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = tintedImage else {
            return UIImage()
        }
        
        return image
    }
    
    func parseQR(completed: @escaping(_ code: String) -> ()) {
        guard let image = CIImage(image: self) else {
            return completed("")
        }

        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        let features = detector?.features(in: image) ?? []

        let code = features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }
        completed(code == [] ? "" : code[0])
    }
    
}
