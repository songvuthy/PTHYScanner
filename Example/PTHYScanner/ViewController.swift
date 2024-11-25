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
    private var cameraViewController: PTHYSannerViewController = .init()
    var isOutputted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        PTHYConfig.backgroundColor = .black
        PTHYConfig.scanAnimationStyle = .line
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
}
extension ViewController: PTHYSannerViewControllerDelegate {
    
    func didBegin(_ code: String) {
        print("begin: ==>",code)
    }

    func didOutput(_ code: String,_ overlayImageView: UIImageView) {
        isOutputted = true
        overlayImageView.image = UIImage(named: "ic_symbol_currency_dollar")
        print("output: ==>",code)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.startScanning()
        })
    }
    
    func didReceiveError(_ error: String) {
        print("error: ==>",error)
    }
}
