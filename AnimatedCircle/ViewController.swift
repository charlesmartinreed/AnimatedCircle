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
    
    var pulsatingLayer: CAShapeLayer!
    
    //percentage label
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    //MARK:- Make status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Fix for broken animation when app enters background
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor //generated via our helper file
        
        setupNotificationObservers() //call observer that watches for when app enters foreground
        
        //shapeLayer path for our circle
        
        //MARK:- Track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true) //2 * PI is complete circle, PI is halfway
        
        //MARK:- Pulsating layer
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = view.center
        
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        //add stroke highlight, set fill color
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer.fillColor = UIColor.backgroundColor.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        //MARK:- CAShapeLayer circle
        //start at the top, end at the top
        shapeLayer.path = circularPath.cgPath
        
        //add stroke highlight, set fill color
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1) //rotating the shapeLayer 90 degrees, into the screen
        shapeLayer.strokeEnd = 0 //where to stop stroking the path, 0 becau we'll animate this
        
        view.layer.addSublayer(shapeLayer)
        
        //MARK:- Tap gesture
        //circle shape layer will animate on tap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //adding the percentage label
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale") //the circle is constantly scaling up and down
        animation.toValue = 1.3 //scale factor
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut) //adds some irregularity to the pacing
        animation.autoreverses = true //scale the circle back down
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsate")
    }
    
    //MARK:- urlString value
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

