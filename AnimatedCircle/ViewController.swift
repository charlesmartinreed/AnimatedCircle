//
//  ViewController.swift
//  AnimatedCircle
//
//  Created by Charles Martin Reed on 12/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //shapeLayer path for our circle
        let center = view.center
        
        //MARK:- Track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true) //2 * PI is complete circle, PI is halfway
        trackLayer.path = circularPath.cgPath
        
        //add stroke highlight, set fill color
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        view.layer.addSublayer(trackLayer)
        
        //MARK:- CAShapeLayer circle
        //start at the top, end at the top
        shapeLayer.path = circularPath.cgPath
        
        //add stroke highlight, set fill color
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round //rounding the line edges
        shapeLayer.strokeEnd = 0 //where to stop stroking the path, 0 becau we'll animate this
        
        view.layer.addSublayer(shapeLayer)
        
        //MARK:- Tap gesture
        //circle shape layer will animate on tap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }


    @objc func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1 //so this should go from strokeEnd = 0 to strokeEnd = 1
        basicAnimation.duration = 2 //in seconds
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards //remain visible when animation is complete
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "soBasic") //add animation to shapeLayer
    }
}

