//
//  TensorTFRecords.swift
//
//
//  Created by Jacopo Mangiavacchi on 11/6/19.
//

import Foundation
import SwiftTFRecords

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
