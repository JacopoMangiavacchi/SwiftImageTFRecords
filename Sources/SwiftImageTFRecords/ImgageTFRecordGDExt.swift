//
//  ImgageTFRecordGDExt.swift
//  
//
//  Created by Jacopo Mangiavacchi on 11/7/19.
//

import Foundation
import SwiftGD

// Image processing extension
extension ImageTFRecord {
    public init?(imageFile url: URL, imageName: String) {
        guard let image = Image(url: url),
              let data = try? image.export() else { return nil }

        self.init(width: image.size.width,
                  height: image.size.height,
                  filename: imageName,
                  encoded: data,
                  format: url.pathExtension.lowercased(),
                  annotations: nil)
    }
    
    public func validImage() -> Bool {
        guard let _ = try? Image(data: self.encoded) else { return false }
        return true
    }
    
    public func realSize() -> (width: Int, height: Int)? {
        guard let image = try? Image(data: self.encoded) else { return nil }
        return (image.size.width, image.size.height)
    }
    
    public mutating func resize(width: Int, height: Int, applySmoothing: Bool = true) -> Bool {
        guard let image = try? Image(data: self.encoded),
              let resizedImage = image.resizedTo(width: width, height: height, applySmoothing: applySmoothing),
              let data = try? resizedImage.export() else { return false }
        
        self.encoded = data
        self.width = resizedImage.size.width
        self.height = resizedImage.size.height
        
        // TODO: resize all annotations

        return true
    }
}
