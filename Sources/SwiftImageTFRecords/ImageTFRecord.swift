//
//  TensorTFRecords.swift
//
//
//  Created by Jacopo Mangiavacchi on 11/6/19.
//

import Foundation
import SwiftTFRecords

public struct Annotation {
    public var xMin: Float
    public var yMin: Float
    public var xMax: Float
    public var yMax: Float
    public var text: String
    public var label: Int
}

public struct ImageTFRecord {
    public var width: Int
    public var height: Int
    public var filename: String
    public var encoded: Data
    public var format: String
    public var annotations: [Annotation]?

    public init(width: Int, height: Int, filename: String, encoded: Data, format: String, annotations: [Annotation]?) {
        self.width = width
        self.height = height
        self.filename = filename
        self.encoded = encoded
        self.format = format
        self.annotations = annotations
    }
    
    public init(withRecord record: Record) {
        // TODO Handling errors and remove ! with throws and guard
        self.width = record["image/width"]!.toInt()!
        self.height = record["image/height"]!.toInt()!
        self.filename = record["image/filename"]!.toString()!
        self.encoded = record["image/encoded"]!.toBytes()!
        self.format = record["image/format"]!.toString()!
        
        guard let xMinArray = record["image/object/bbox/xmin"]?.toFloatArray(),
              let yMinArray = record["image/object/bbox/ymin"]?.toFloatArray(),
              let xMaxArray = record["image/object/bbox/xmax"]?.toFloatArray(),
              let yMaxArray = record["image/object/bbox/ymax"]?.toFloatArray(),
              let textArray = record["image/object/class/text"]?.toStringArray(),
              let labelArray = record["image/object/class/label"]?.toIntArray(),
              xMinArray.count == yMinArray.count &&
              xMinArray.count == xMaxArray.count &&
              xMinArray.count == yMaxArray.count &&
              xMinArray.count == textArray.count &&
              xMinArray.count == labelArray.count else { self.annotations = nil; return }
            
        self.annotations = [Annotation]()
        
        for i in 0..<xMinArray.count {
            self.annotations?.append(Annotation(xMin: xMinArray[i],
                                               yMin: yMinArray[i],
                                               xMax: xMaxArray[i],
                                               yMax: yMaxArray[i],
                                               text: textArray[i],
                                               label: labelArray[i]))
        }
    }
    
    public var record: Record {
        var record = Record()
        
        record["image/width"] = Feature.Int(width)
        record["image/height"] = Feature.Int(height)
        record["image/filename"] = Feature.String(filename)
        record["image/encoded"] = Feature.Bytes(encoded)
        record["image/format"] = Feature.String(format)
            
        if let annotations = self.annotations {
            for annotation in annotations {
                record["image/object/bbox/xmin"] = Feature.Float(annotation.xMin)
                record["image/object/bbox/ymin"] = Feature.Float(annotation.yMin)
                record["image/object/bbox/xmax"] = Feature.Float(annotation.xMax)
                record["image/object/bbox/ymax"] = Feature.Float(annotation.yMax)
                record["image/object/class/text"] = Feature.String(annotation.text)
                record["image/object/class/label"] = Feature.Int(annotation.label)
            }
        }
        
        return record
    }
}
