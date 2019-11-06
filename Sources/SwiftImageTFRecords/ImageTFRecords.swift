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
    var images: [ImageTFRecord]
    
    public init() {
        self.images = [ImageTFRecord]()
    }
    
    public init(withData data: Data) {
        let tfRecords = TFRecords(withData: data)
        self.images = tfRecords.records.map{ ImageTFRecord(withRecord: $0) }
    }
    
    public var data: Data {
        let tfRecords = TFRecords(withRecords: images.map { $0.record })
        return tfRecords.data
    }
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
        self.width = record["image/width"]!.toInt()!
        self.height = record["image/height"]!.toInt()!
        self.filename = record["image/filename"]!.toString()!
        self.encoded = record["image/encoded"]!.toBytes()!
        self.format = record["image/format"]!.toString()!
        
        // TODO Annotations
        self.annotation = nil
    }
    
    public var record: Record {
        var record = Record()
        
        record["image/width"] = Feature.Int(width)
        record["image/height"] = Feature.Int(height)
        record["image/filename"] = Feature.Bytes(Data(String("\(filename)").utf8))
        record["image/encoded"] = Feature.Bytes(encoded)
        record["image/format"] = Feature.Bytes(Data(String("\(format)").utf8))
            
        // TODO Annotations
        
        return record
    }
}
