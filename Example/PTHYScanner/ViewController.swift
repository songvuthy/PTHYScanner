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
    private lazy var cameraViewController: PTHYSannerViewController = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        PTHYConfig.cornerColor = .red
        cameraViewController.delegate = self
        add(cameraViewController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraViewController.startScanning()
    }

}
extension ViewController: PTHYSannerViewControllerDelegate {
    
    func didOutput(_ code: String) {
        print("output: ==>",code)
    }
    
    func didReceiveError(_ error: String) {
        print("error: ==>",error)
    }
}

