//
//  PTHYSannerViewController.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 21/11/24.
//

import UIKit
import AVFoundation

public protocol PTHYSannerViewControllerDelegate: AnyObject {
    func didOutput(_ code:String)
    func didReceiveError(_ error: String)
    
}
public class PTHYSannerViewController: UIViewController {
    public weak var delegate:PTHYSannerViewControllerDelegate?
        
    private lazy var scanView = PTHYSannerView(frame: CGRect(x: 0, y: 0 - PTHYConfig.adjustmentY, width: PTHYSannerCommon.screenWidth, height: PTHYSannerCommon.screenHeight))
    /// Capture session.
    private lazy var captureSession = AVCaptureSession()
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Video
    /// Video preview layer.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    /// Video capture device. This may be nil when running in Simulator.
    private lazy var captureDevice: AVCaptureDevice? = {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        if captureDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.whiteBalanceMode = .continuousAutoWhiteBalance
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = .continuousAutoFocus
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        if captureDevice.isExposureModeSupported(.continuousAutoExposure) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.exposureMode = .continuousAutoExposure
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        return captureDevice
    }()

    
    // MARK: - Functions
    private func setupUI(){
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        videoPreviewLayer?.frame = view.layer.bounds
        
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        view.backgroundColor = UIColor.black
        view.layer.addSublayer(videoPreviewLayer)
        view.addSubview(scanView)
    
        setupAVCaptureSession()
        
    }
    
    private func setupAVCaptureSession() {
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            delegate?.didReceiveError(error.localizedDescription)
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            delegate?.didReceiveError("Your device does not support scanning a code from an item. Please use a device with a camera.")
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        
//        metadataOutput.rectOfInterest = convertRectOfInterest(rect: getRectOfContentView)
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            delegate?.didReceiveError("Your device does not support scanning a code from an item. Please use a device with a camera.")
            return
        }
        
        DispatchQueue.main.async {[self] in
            videoPreviewLayer?.session = captureSession
        }
    }
    private func startCapturing() {
        guard !PTHYSannerPlatform.isSimulator else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            if self?.captureSession.isRunning == false {
                self?.captureSession.startRunning()
            }
        }
    }
    
    private func stopCapturing() {
        guard !PTHYSannerPlatform.isSimulator else {
            return
        }
        if self.captureSession.isRunning == true {
            self.captureSession.stopRunning()
        }
    }
    
    
    public func startScanning() {
        startCapturing()
        scanView.startAnimation()
    }
    public func stopScanning() {
        stopCapturing()
        scanView.stopAnimation()
    }
    
    private var getRectOfContentView: CGRect{
        var contentViewRect = scanView.contentView.frame
        contentViewRect.origin.y -= PTHYConfig.adjustmentY
        return contentViewRect
    }
    
    private func convertRectOfInterest(rect: CGRect) -> CGRect {
        let screenBounds = scanView.frame
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        // scanAreaSize given in screen coordinates
        let scanAreaSize = rect
        // Calculate rectOfInterest in normalized coordinates
        let rectOfInterest = CGRect(
            x: scanAreaSize.origin.y / screenHeight, // Y position normalized
            y: scanAreaSize.origin.x / screenWidth, // X position normalized
            width: scanAreaSize.height / screenHeight, // Height normalized
            height: scanAreaSize.width / screenWidth // Width normalized
        )
        return rectOfInterest
    }
}
// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension PTHYSannerViewController:AVCaptureMetadataOutputObjectsDelegate{
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
//        // Convert to screen coordinates
//        if let transformedObject = videoPreviewLayer?.transformedMetadataObject(for: object) {
//            let qrCodeBounds = transformedObject.bounds
//            view.addSubview(frameView)
//            frameView.frame = getRectOfContentView
//            UIView.animate(withDuration: 0.25) {[self] in
//                titleScanView.alpha = 0
//                actionView.alpha = 0
//                scanView.alpha = 0
//        
//                frameView.alpha = 1
//                frameView.frame = qrCodeBounds
//            }completion: {[self] _ in
//                delegate?.didOutput(object.stringValue ?? "")
//                Vibration.medium.vibrate()
//                isOutputted = true
//            }
//        }
        delegate?.didOutput(object.stringValue ?? "")
    }
}
