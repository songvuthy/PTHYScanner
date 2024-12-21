//
//  ViewController.swift
//  PTHYScanner
//
//  Created by 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 on 11/21/2024.
//  Copyright (c) 2024 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. All rights reserved.
//

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
        PTHYConfig.isScanningFullScreen = false
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
    private func alertCameraPermission() {
        let appName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) ?? ""
        // Create Alert
        let alert = UIAlertController(
            title: "This feature requires camera access",
            message: "Open iPhone Settings, tab \(appName) and turn on Camera.",
            preferredStyle: .alert
        )
        // Add "Cancel" Button to alert, pressing it will pop back view controller
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [self] _ in
            navigationController?.popViewController(animated: true)
        }))
        // Add "Setting" Button to alert, pressing it will bring you to the settings app
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        // Show the alert with animation
        self.present(alert, animated: true)
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
    
    func didReceiveError(_ failure: PTHYScanner.PTHYSannerViewController.ErrorState) {
        switch failure {
        case .failed(let error):
            print("failed: ==>",error)
            
        case .cameraNoPermission:
            DispatchQueue.main.async { [self] in
                alertCameraPermission()
                print("failed camera no permission")
            }

        }
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
