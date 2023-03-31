import Foundation
import AppKit
import CoreImage
import Accelerate

enum LUTError: Error {
    case incorrectImageSize
    case cantLoadImage
    case cantCreateFilter
}

protocol ImageFilter {
    func apply(to image: CIImage) -> CIImage
}

struct NoOp: ImageFilter {
    func apply(to image: CIImage) -> CIImage {
        image
    }
}

final class LUTFilter: ImageFilter {
    
    private var filter: CIFilter
    
    func apply(to image: CIImage) -> CIImage {
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
    
    init?(from filter: Filter) {
        do {
            self.filter = try Self.createLUTFilter(from: filter.url)
        } catch {
            debugPrint("Unable to create filter: \(error)")
            return nil
        }
    }
    
    private static func createLUTFilter(from url: URL) throws -> CIFilter {
        guard let image = CIImage(contentsOf: url) else {
            throw LUTError.cantLoadImage
        }
        
        let dimension = image.extent.width
        guard dimension == image.extent.height else {
            throw LUTError.incorrectImageSize
        }
        
        let totalPixels = Int(dimension * dimension)
        let pixelData = UnsafeMutablePointer<SIMD4<Float>>.allocate(capacity: totalPixels)
        
        let context = CIContext(options: [.workingColorSpace: NSNull()])
        context.render(image,
                       toBitmap: pixelData,
                       rowBytes: Int(dimension) * MemoryLayout<SIMD4<Float>>.size,
                       bounds: .init(origin: .zero, size: .init(width: dimension, height: dimension)),
                       format: .RGBAf,
                       colorSpace: nil)
        
        let data = Data(bytesNoCopy: pixelData, count: totalPixels * MemoryLayout<SIMD4<Float>>.size, deallocator: .free)
        let params: [String : Any] = [ "inputCubeData" : data, "inputCubeDimension": Int(cbrt(Double(totalPixels))) ]
        guard let filter = CIFilter(name: "CIColorCube", parameters: params) else {
            throw LUTError.cantCreateFilter
        }
        return filter
    }
}
