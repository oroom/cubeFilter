import Foundation
import SwiftUI
import AVFoundation
import AppKit

final class VideoService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureSession?
    var filters: [ImageFilter] = []
    var update: (FilteredImage) -> Void
    
    init(update: @escaping (FilteredImage) -> Void) {
        self.update = update
    }
    
    func start() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                // Find the default video device
                guard let device = AVCaptureDevice.default(for: .video) else {
                    fatalError("No video device found")
                }
                
                // Create a new AVCaptureDeviceInput with the default device
                guard let input = try? AVCaptureDeviceInput(device: device) else {
                    fatalError("Unable to create AVCaptureDeviceInput")
                }
                
                // Create a new AVCaptureSession
                let session = AVCaptureSession()
                
                // Add the input to the session
                session.addInput(input)
                
                let videoOutput = AVCaptureVideoDataOutput()
                
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
                
                session.startRunning()
                self.session = session
            } else {
                // Handle denied access
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        let image = FilteredImage(ciImage: cameraImage)
        image.applyFilters(filters)
        DispatchQueue.main.async { [weak self] in
            self?.update(image)
        }
    }
}
