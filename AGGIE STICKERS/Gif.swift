//
//  Gif.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj on 31/12/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class GIF2MP4 {
    
    private(set) var gif: GIF
    private var outputURL: URL!
    private(set) var videoWriter: AVAssetWriter!
    private(set) var videoWriterInput: AVAssetWriterInput!
    private(set) var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    var videoSize: CGSize {
        //The size of the video must be a multiple of 16
        return CGSize(width: max(1, floor(gif.size.width / 16)) * 16, height: max(1, floor(gif.size.height / 16)) * 16)
    }
    
    init?(data: Data) {
        guard let gif = GIF(data: data) else { return nil }
        self.gif = gif
    }
    
    private func prepare() {
        
        try? FileManager.default.removeItem(at: outputURL)

        let avOutputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(value: Float(videoSize.width)),
            AVVideoHeightKey: NSNumber(value: Float(videoSize.height))
        ]
        
        let sourcePixelBufferAttributesDictionary = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: NSNumber(value: Float(videoSize.width)),
            kCVPixelBufferHeightKey as String: NSNumber(value: Float(videoSize.height))
        ]
        
        videoWriter = try! AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4)
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)
        videoWriter.add(videoWriterInput)
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: CMTime.zero)
    }
    
    func convertAndExport(to url: URL, completion: @escaping () -> Void ) {
        outputURL = url
        prepare()

        var index = 0
        var delay = 0.0 - gif.frameDurations[0]
        let queue = DispatchQueue(label: "mediaInputQueue")
        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            var isFinished = true

            while index < self.gif.frames.count {
                if self.videoWriterInput.isReadyForMoreMediaData == false {
                    isFinished = false
                    break
                }
                
                if let cgImage = self.gif.getFrame(at: index) {
                    let frameDuration = self.gif.frameDurations[index]
                    delay += Double(frameDuration)
                    let presentationTime = CMTime(seconds: delay, preferredTimescale: 600)
                    let result = self.addImage(image: UIImage(cgImage: cgImage), withPresentationTime: presentationTime)
                    if result == false {
                        fatalError("addImage() failed")
                    } else {
                        index += 1
                    }
                }
            }
            
            if isFinished {
                self.videoWriterInput.markAsFinished()
                self.videoWriter.finishWriting {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } else {
                // Fall through. The closure will be called again when the writer is ready.
            }
        }
    }
    
    private func addImage(image: UIImage, withPresentationTime presentationTime: CMTime) -> Bool {
        guard let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool else {
            print("pixelBufferPool is nil ")
            return false
        }
        let pixelBuffer = pixelBufferFromImage(image: image, pixelBufferPool: pixelBufferPool, size: videoSize)
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }

    private func pixelBufferFromImage(image: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer {
        var pixelBufferOut: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        if status != kCVReturnSuccess {
            fatalError("CVPixelBufferPoolCreatePixelBuffer() failed")
        }
        let pixelBuffer = pixelBufferOut!

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))

        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data, width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!

        context.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let horizontalRatio = size.width / image.size.width
        let verticalRatio = size.height / image.size.height
        let aspectRatio = max(horizontalRatio, verticalRatio) // ScaleAspectFill
        //let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)

        let x = newSize.width < size.width ? (size.width - newSize.width) / 2: -(newSize.width-size.width)/2
        let y = newSize.height < size.height ? (size.height - newSize.height) / 2: -(newSize.height-size.height)/2

        context.draw(image.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))

        return pixelBuffer
    }
}

import ImageIO
import MobileCoreServices

class GIF {

    private let frameDelayThreshold = 0.02
    private(set) var duration = 0.0
    private(set) var imageSource: CGImageSource!
    private(set) var frames: [CGImage?]!
    private(set) lazy var frameDurations = [TimeInterval]()
    var size: CGSize {
        guard let f = frames.first, let cgImage = f else { return .zero }
        return CGSize(width: cgImage.width, height: cgImage.height)
    }
    private lazy var getFrameQueue: DispatchQueue = DispatchQueue(label: "gif.frame.queue", qos: .userInteractive)

    init?(data: Data) {
        guard let imgSource = CGImageSourceCreateWithData(data as CFData, nil), let imgType = CGImageSourceGetType(imgSource), UTTypeConformsTo(imgType, kUTTypeGIF) else {
            return nil
        }
        self.imageSource = imgSource
        let imgCount = CGImageSourceGetCount(imageSource)
        frames = [CGImage?](repeating: nil, count: imgCount)
        for i in 0..<imgCount {
            let delay = getGIFFrameDuration(imgSource: imageSource, index: i)
            frameDurations.append(delay)
            duration += delay

            getFrameQueue.async { [unowned self] in
                self.frames[i] = CGImageSourceCreateImageAtIndex(self.imageSource, i, nil)
            }
        }
    }

    func getFrame(at index: Int) -> CGImage? {
        if index >= CGImageSourceGetCount(imageSource) {
            return nil
        }
        if let frame = frames[index] {
            return frame
        } else {
            let frame = CGImageSourceCreateImageAtIndex(imageSource, index, nil)
            frames[index] = frame
            return frame
        }
    }

    private func getGIFFrameDuration(imgSource: CGImageSource, index: Int) -> TimeInterval {
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(imgSource, index, nil) as? [String: Any],
            let gifProperties = frameProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
            let unclampedDelay = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval
            else { return 0.02 }

        var frameDuration = TimeInterval(0)

        if unclampedDelay < 0 {
            frameDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval ?? 0.0
        } else {
            frameDuration = unclampedDelay
        }

        /* Implement as Browsers do: Supports frame delays as low as 0.02 s, with anything below that being rounded up to 0.10 s.
         http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility */

        if frameDuration < frameDelayThreshold - Double.ulpOfOne {
            frameDuration = 0.1
        }

        return frameDuration
    }
}



import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
