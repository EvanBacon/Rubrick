//
//  ShelfView.swift
//  Prototype
//
//  Created by Evan Bacon on 12/2/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Material


class ShelfView: UIView, SnappingSliderDelegate {
    private let snappingSlider:SnappingSlider = SnappingSlider(frame: CGRectMake(0.0, 0.0, 10.0, 10.0), title: "All")

    override init(frame: CGRect) {
     
        super.init(frame: frame)
        
      
        
        
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        self.layer.shadowRadius = 0.8
        self.layer.shadowOpacity = 0.3
        expandedY = self.frame.origin.y
        self.exclusiveTouch = true
        
        let swipe = UISwipeGestureRecognizer()
        swipe.addTarget(self, action: Selector("swipe:"))
        self.addGestureRecognizer(swipe)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("Tap:"))
        self.addGestureRecognizer(tap)
        
        
//        self.blur(blurRadius: 2)

        
        
        let button = UIButton(frame: CGRectMake(0,0,100,100))
        button.center = self.center
        button.center.x -= 50
        button.addTarget(self, action: Selector("goDown:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColor.redColor()
        
        self.addSubview(button)
        
        
        let upButton = UIButton(frame: CGRectMake(0,0,100,100))
        upButton.center = self.center
        upButton.center.x += 50
        
        upButton.addTarget(self, action: Selector("goUp:"), forControlEvents: UIControlEvents.TouchUpInside)
        upButton.backgroundColor = UIColor.redColor()
        self.addSubview(upButton)
        
        
        
snappingSlider.incrementAndDecrementLabelTextColor = MaterialColor.red.base
        snappingSlider.delegate = self
        snappingSlider.frame = CGRectMake(0.0, 0.0, self.bounds.size.width * 0.5, 50.0)
        snappingSlider.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.1)
        self.addSubview(snappingSlider)
        

        
    }
    
    
    
    func snappingSliderDidIncrementValue(snapSwitch: SnappingSlider) {
        
//        layer++
        
        model.goUpLayer()
        snappingSlider.sliderTitleText = "\(model.maxVisibleLayer())"
        //        bladderFillLabel.text = "\(layer)"
    }
    
    func snappingSliderDidDecrementValue(snapSwitch: SnappingSlider) {
        
//        layer = max(0, layer - 1)
        
        model.goDownLayer()
        snappingSlider.sliderTitleText = "\(model.maxVisibleLayer())"

        //        bladderFillLabel.text = "\(numberOfCupsOfTeaIHaveDrankSoFar)"
    }

    
    
    
    func Tap(tap: UITapGestureRecognizer) {
        if (collapsed) {
            expand()
        } else {
            collapse()
        }
    }
    
    func swipe(swipe: UISwipeGestureRecognizer) {
        collapse()
    }
    
    let collapsedHeight:CGFloat = 50
    
    var expandedY:CGFloat = 0
    
    var collapsed = false
    
    func collapse() {
        collapsed = true
        UIView.animateWithDuration(0.3, animations: {
            self.layer.shadowOpacity = 0.0

            self.frame.origin.y = UIScreen.mainScreen().bounds.size.height - self.collapsedHeight
        })
    }
    
    func expand() {
        collapsed = false
        UIView.animateWithDuration(0.3, animations: {
            self.layer.shadowOpacity = 0.3
            
            self.frame.origin.y = self.expandedY
        })
    }
    
    
    required init(coder : NSCoder) {
     
        super.init(coder:coder)!
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect)
    {
  
    }
}