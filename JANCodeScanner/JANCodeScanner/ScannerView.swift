// JAN Code Scanner
// Created by Saeed Rahmatolahi
// Codium Co Ltd

import UIKit
import AVFoundation

final class ScannerView: UIView , AVCaptureMetadataOutputObjectsDelegate {
    
    fileprivate var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    var stopAfterScan = true
    weak var scannerViewDelegate : scannerViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCamera()
    }
    
    
    /// scan functions
    fileprivate func initCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        self.didLunchScreen()
    }

    
    /// failed scan
    fileprivate func failed() {
        captureSession = nil
        self.scannerViewDelegate?.scanFailed()
    }
    
    
    /// detect camera rotation
    @objc fileprivate func rotated() {
        if UIDevice.current.orientation.isLandscape {
            if UIDevice.current.orientation == .landscapeLeft {
                self.previewLayer.connection?.videoOrientation = .landscapeRight
            } else {
                self.previewLayer.connection?.videoOrientation = .landscapeLeft
            }
        }
    }
    
    fileprivate func didLunchScreen() {
        if self.previewLayer.connection != nil {
                self.previewLayer.connection?.videoOrientation = self.viewOrientation
        }
    }
    
    deinit {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        NotificationCenter.default.removeObserver(self)
    }

    
    /// found BarCode
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            if stopAfterScan {
                captureSession.stopRunning()
            }
        }

    }

    
    /// success scan
    /// - Parameter code: send string code
    fileprivate func found(code: String) {
        self.scannerViewDelegate?.scanResult(code)
    }
    
    internal var viewOrientation: AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .unknown:
            return .landscapeRight
        default :
            return .landscapeLeft
        }
    }
}

protocol scannerViewProtocol : NSObjectProtocol {
    func scanResult(_ text : String)
    func scanFailed()
}
