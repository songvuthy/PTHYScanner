# PTHYScanner

[![Version](https://img.shields.io/cocoapods/v/PTHYScanner.svg?style=flat)](https://cocoapods.org/pods/PTHYScanner)
[![License](https://img.shields.io/cocoapods/l/PTHYScanner.svg?style=flat)](https://cocoapods.org/pods/PTHYScanner)
[![Platform](https://img.shields.io/cocoapods/p/PTHYScanner.svg?style=flat)](https://cocoapods.org/pods/PTHYScanner)

## Requirements

- iOS 12.0+
- Xcode 10.0+
- Swift 4+

## Installation

PTHYScanner is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PTHYScanner'
```

## Example

```swift
import UIKit
import PTHYScanner

class ViewController: UIViewController {
    private var cameraViewController: PTHYSannerViewController!
    private var isOutputted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        PTHYConfig.backgroundColor = .black
        PTHYConfig.scanAnimationStyle = .line
        PTHYConfig.showQrCodeScanned = true
        PTHYConfig.customHeaderView = headerView
        PTHYConfig.customFooterView = footerView
        cameraViewController = PTHYSannerViewController()
        cameraViewController.delegate = self
        add(cameraViewController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraViewController.startScanning()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBecomeActiveBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleResignActiveBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraViewController.stopScanning()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleBecomeActiveBackground() {
        if !isOutputted { startScanning() }
    }
    @objc private func handleResignActiveBackground() {
        stopScanning()
    }
    
    private func startScanning() {
        cameraViewController.startScanning()
        isOutputted = false
    }
    private func stopScanning() {
        cameraViewController.stopScanning()
    }
    
    lazy var headerView: CustomLayoutView = {
        let view = CustomLayoutView()
        view.titleLabel.text = "Scan QR"
        return view
    }()
    lazy var footerView: CustomLayoutView = {
        let view = CustomLayoutView()
        view.titleLabel.text = "A fast, lightweight, and customizable QR code scanner for iOS, providing seamless QR code detection and decoding."
        view.titleLabel.font = .systemFont(ofSize: 16)
        return view
    }()
}
extension ViewController: PTHYSannerViewControllerDelegate {
    
    func didBegin(_ code: String) {
        print("begin: ==>",code)
    }

    func didOutput(_ code: String,_ overlayImageView: UIImageView) {
        isOutputted = true
        overlayImageView.image = UIImage(named: "ic_symbol_currency_dollar")
        print("output: ==>",code)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.startScanning()
        })
    }
    
    func didReceiveError(_ error: String) {
        print("error: ==>",error)
    }
}


class CustomLayoutView: UIView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.text = "Scan QR"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 32).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor,constant: -32).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

```

## Customize Scanner
Needs to change before scan.

```swift
    // configuration specific settings
    PTHYConfig.scanAnimationStyle = .line
    
    PTHYConfig.metadata = AVMetadataObject.ObjectType.metadata

    PTHYConfig.cornerColor:UIColor = .white
    
    PTHYConfig.backgroundColor = .black
    
    PTHYConfig.backgroundAlpha = 0.6
    
    PTHYConfig.scanBorderWidthRadio = 0.6
    
    PTHYConfig.scanAdjustCenterY = 0.0
    
    PTHYConfig.frameImage = PTHYSannerCommon.imageResourcePath("icon_scan_frame")
    
    PTHYConfig.frameBorderWidth = 4
    
    PTHYConfig.showQrCodeScanned = true
    
    PTHYConfig.qrCodeAdjustCenterY = 0.0
```

## Author

  Song Vuthy, songvuthy93@gmail.com

## License

PTHYScanner is available under the MIT license. See the LICENSE file for more info.
