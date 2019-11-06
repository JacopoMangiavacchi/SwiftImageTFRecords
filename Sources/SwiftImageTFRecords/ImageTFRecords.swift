//
//  TensorTFRecords.swift
//
//
//  Created by Jacopo Mangiavacchi on 11/6/19.
//

import Foundation
import SwiftTFRecords
import SwiftGD

public struct Annotation {
    var xMin: Float
    var yMin: Float
    var xMax: Float
    var yMax: Float
    var text: String
    var label: Int
}

public struct ImageTFRecords {
    var width: Int
    var height: Int
    var filename: String
    var encoded: Data
    var format: String
    var annotation: [Annotation]?

    public var data: Data {
        let data = Data([1, 2, 3, 4])

        return data
    }
    
    public init(width: Int, height: Int, filename: String, encoded: Data, format: String, annotation: [Annotation]?) {
        self.width = width
        self.height = height
        self.filename = filename
        self.encoded = encoded
        self.format = format
        self.annotation = annotation
    }
    
    public init(withData data: Data) {
        self.width = 0
        self.height = 0
        self.filename = "filename"
        self.encoded = Data()
        self.format = "format"
    }
}
