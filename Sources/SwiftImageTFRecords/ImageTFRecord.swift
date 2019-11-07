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

public struct ImageTFRecord {
    var width: Int
    var height: Int
    var filename: String
    var encoded: Data
    var format: String
    var annotation: [Annotation]?

    public init(width: Int, height: Int, filename: String, encoded: Data, format: String, annotation: [Annotation]?) {
        self.width = width
        self.height = height
        self.filename = filename
        self.encoded = encoded
        self.format = format
        self.annotation = annotation
    }
    
    public init(withRecord record: Record) {
        // TODO Handling errors and remove ! with throws and guard
        self.width = record["image/width"]!.toInt()!
        self.height = record["image/height"]!.toInt()!
        self.filename = record["image/filename"]!.toString()!
        self.encoded = record["image/encoded"]!.toBytes()!
        self.format = record["image/format"]!.toString()!
        
        let xMinArray = record["image/object/bbox/xmin"]!.toFloatArray()!
        let yMinArray = record["image/object/bbox/ymin"]!.toFloatArray()!
        let xMaxArray = record["image/object/bbox/xmax"]!.toFloatArray()!
        let yMaxArray = record["image/object/bbox/ymax"]!.toFloatArray()!
        let lextArray = record["image/object/class/text"]!.toStringArray()!
        let labelArray = record["image/object/class/label"]!.toIntArray()!

        
        // TODO Annotations
        self.annotation = nil
    }
    
    public var record: Record {
        var record = Record()
        
        record["image/width"] = Feature.Int(width)
        record["image/height"] = Feature.Int(height)
        record["image/filename"] = Feature.String(filename)
        record["image/encoded"] = Feature.Bytes(encoded)
        record["image/format"] = Feature.String(format)
            
        // TODO Annotations
        
        return record
    }
}
