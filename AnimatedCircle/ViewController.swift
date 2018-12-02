//
//  ViewController.swift
//  AnimatedCircle
//
//  Created by Charles Martin Reed on 12/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    let shapeLayer = CAShapeLayer()
    
    //percentage label
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding the percentage label
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        //shapeLayer path for our circle
        
        //MARK:- Track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true) //2 * PI is complete circle, PI is halfway
        trackLayer.path = circularPath.cgPath
        
        //add stroke highlight, set fill color
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
        
        //MARK:- CAShapeLayer circle
        //start at the top, end at the top
        shapeLayer.path = circularPath.cgPath
        
        //add stroke highlight, set fill color
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1) //rotating the shapeLayer 90 degrees, into the screen
        
        shapeLayer.strokeEnd = 0 //where to stop stroking the path, 0 becau we'll animate this
        
        view.layer.addSublayer(shapeLayer)
        
        //MARK:- Tap gesture
        //circle shape layer will animate on tap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"


    //MARK:- Downloading file method
    private func beginDownloadingFile() {
        //reset our strokeEnd
        shapeLayer.strokeEnd = 0
        
        //execute a URL session to download the file
        //using configuration because we need to monitor
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue() //queue in which we execute download task
        
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return } //constructor gives optional, we need none optional with downloadTask
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    //MARK:- Delegate method
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //percentage of download
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        //drawing the circle on the main thread, per common practice for UI updates
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Finished Downloading file.")
    }

    //MARK:- Tap gesture method
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1 //so this should go from strokeEnd = 0 to strokeEnd = 1
        basicAnimation.duration = 2 //in seconds
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards //remain visible when animation is complete
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "soBasic")
    }
    
    @objc private func handleTap() {
        
        beginDownloadingFile()
        //animateCircle() //add animation to shapeLayer
        
    }
    
}

