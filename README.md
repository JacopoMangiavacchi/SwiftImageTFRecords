# SwiftImageTFRecords
Swift library to load and save TFRecords file containing images with annotations (as used in TensorFlow Object Detection API).

## Installation

This package library depend on SwiftGD (https://github.com/twostraws/SwiftGD) that require to install the GD library on your computer. If you're using *macOS*, install Homebrew then run the command `brew install gd`. If you're using *Linux*, `apt-get libgd-dev` as root.

If your using this library on a Swift Jupyter or Colab Notebook you may install the GD library from a Python notebook cell executing `!run apt-get libgd-dev` and then in the Swift Notebook import this library with the following instruction:

```
%install '.package(url: "https://github.com/JacopoMangiavacchi/SwiftImageTFRecords", from: "0.0.3")' SwiftImageTFRecords
```

## Usage - Create TFRecord from image file

```swift
import Foundation
import SwiftImageTFRecords

let imageFileUrl = URL(fileURLWithPath: "image.jpeg")
let tfrecordUrl = URL(fileURLWithPath: "new.tfrecord")

var imageTFRecords = ImageTFRecords()
imageTFRecords.images.append(ImageTFRecord(imageFile: imageFileUrl, imageName: "new")!)
try? imageTFRecords.data.write(to: tfrecordUrl)

```

## Usage - Resize all images in a TFRecord

```swift
import Foundation
import SwiftImageTFRecords

let data = try Data(contentsOf: URL(fileURLWithPath: "image.tfrecord"))

let imageTFRecords = ImageTFRecords(withData: data)

print(imageTFRecords.images.count)
print(imageTFRecords.images.first)
print(imageTFRecords.images.first?.width, imageTFRecords.images.first?.height)
print(imageTFRecords.images.first?.validImage(), imageTFRecords.images.first?.realSize())

// Resize all images in the TFRecord
for (index, _) in imageTFRecords.images.enumerated() {
    imageTFRecords.images[index].resize(width: 299, height: 299)
}

print(imageTFRecords.images.first?.width, imageTFRecords.images.first?.height)
print(imageTFRecords.images.first?.validImage(), imageTFRecords.images.first?.realSize())

try? imageTFRecords.data.write(to: URL(fileURLWithPath: "resized-image.tfrecord"))

```
