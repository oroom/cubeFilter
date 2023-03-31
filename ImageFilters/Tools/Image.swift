import Foundation
import CoreImage
import AppKit

final class FilteredImage {
    private let originalImage: CIImage
    private var resultingImage: CIImage
    
    var input: NSImage {
        originalImage.asNSImage()
    }
    
    var output: NSImage {
        resultingImage.asNSImage()
    }
    
    init?(url: URL) {
        guard let originalCIImage = CIImage(contentsOf: url) else {
            return nil
        }
        self.originalImage = originalCIImage
        self.resultingImage = originalCIImage
    }
    
    func applyFilters(_ filters: [ImageFilter]) {
        resultingImage = filters.reduce(originalImage) { $1.apply(to: $0) }
    }
}

extension CIImage {
   /// Create an NSImage version of this image
   /// - Parameters:
   ///   - pixelSize: The number of pixels in the result image. For a retina image (for example), pixelSize is double repSize
   ///   - repSize: The number of points in the result image
   /// - Returns: Converted image
   func asNSImage(pixelsSize: CGSize? = nil, repSize: CGSize? = nil) -> NSImage {
      let rep = NSCIImageRep(ciImage: self)
      if let ps = pixelsSize {
         rep.pixelsWide = Int(ps.width)
         rep.pixelsHigh = Int(ps.height)
      }
      if let rs = repSize {
         rep.size = rs
      }
      let updateImage = NSImage(size: rep.size)
      updateImage.addRepresentation(rep)
      return updateImage
   }
}

extension NSImage {
    private func data(using fileType: NSBitmapImageRep.FileType) -> Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: fileType, properties: [:])
    }
    
    func write(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        var data: Data?
        switch url.pathExtension {
        case "png":
            data = self.data(using: .png)
        case "jpg", "jpeg":
            data = self.data(using: .jpeg)
        default:
            break
        }
        do {
            try data?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
