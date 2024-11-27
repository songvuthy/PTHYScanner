//
//  PTHYSannerViewController.swift
//  PTHYScanner
//
//  Created by Song Vuthy on 21/11/24.
//

import UIKit
import AVFoundation

public protocol PTHYSannerViewControllerDelegate: AnyObject {
    func didBegin(_ code:String)
    func didOutput(_ code:String,_ overlayImageView: UIImageView)
    func didReceiveError(_ error: String)
    
}
public class PTHYSannerViewController: UIViewController {
    public weak var delegate:PTHYSannerViewControllerDelegate?
        
    private lazy var scanView = PTHYSannerView(frame: CGRect(x: 0, y: 0, width: PTHYSannerCommon.screenWidth, height: PTHYSannerCommon.screenHeight))
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
            metadataOutput.metadataObjectTypes = PTHYConfig.metadata
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
        resetUI()
        startCapturing()
        scanView.startAnimation()
    }
    public func stopScanning() {
        stopCapturing()
        scanView.stopAnimation()
    }
    
    private func updateUI(rect: CGRect, code: String){
        view.addSubview(qrImageView)
        scanView.alpha = 0
        overlayCurrencyImageView.alpha = 0
        qrImageView.alpha = 1
        
        qrImageView.frame = scanView.getRectFrameImageView
        qrImageView.image = PTHYConfig.frameImage
        UIView.animate(withDuration: 0.25) {
            self.qrImageView.frame = rect
            
        }completion: { _ in
            self.qrImageView.image = PTHYSannerCommon.generateQrCode(string: code)
            
            UIView.animate(withDuration: 0.25, delay: 0.25) {
                self.qrImageView.frame = self.getRectOfContentView
                
            }completion: { _ in
                self.overlayCurrencyImageView.alpha = 1
                self.qrImageView.addSubViewToCenter(overlayImageView:self.overlayCurrencyImageView)
                self.delegate?.didOutput(code,self.overlayCurrencyImageView)
            }
        }
    }
    
    private func resetUI(){
        UIView.animate(withDuration: 0.25) {
            self.overlayCurrencyImageView.alpha = 0
            self.qrImageView.alpha = 0
            self.scanView.alpha = 1
        }completion: { _ in
            self.overlayCurrencyImageView.removeFromSuperview()
            self.qrImageView.removeFromSuperview()
        }
    }
    
    private var getRectOfContentView: CGRect{
        let contentViewRect = scanView.contentView.frame
        let origin = CGPoint(x: contentViewRect.origin.x, y: contentViewRect.origin.y - PTHYConfig.qrCodeAdjustCenterY)
        let size = CGSize(width: contentViewRect.width, height: contentViewRect.height)
        return CGRect(origin: origin, size: size)
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
    
    private lazy var qrImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    private lazy var overlayCurrencyImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
}
// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension PTHYSannerViewController:AVCaptureMetadataOutputObjectsDelegate{
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else {
            return
        }
        stopScanning()
        delegate?.didBegin(code)
        
        if PTHYConfig.showQrCodeScanned {
            // Convert to screen coordinates
            if let transformedObject = videoPreviewLayer?.transformedMetadataObject(for: object) {
                let qrCodeBounds = transformedObject.bounds
                updateUI(rect: qrCodeBounds,code: code)
            }
            return
        }
        delegate?.didOutput(code,overlayCurrencyImageView)
    }
}
