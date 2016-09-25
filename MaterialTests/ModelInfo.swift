//
//  ModelInfo.swift
//  Prototype
//
//  Created by Evan Bacon on 12/2/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation


//LD Dimensions
// 1 == 0.4 millimeters


struct Dimensions {
    var width:Float = 0
    var height:Float = 0
    var depth:Float = 0

}


class BrickInfo {
    var color:String = ""
    var type:String = ""
    
    var quantity:Int = 0
    
    init(color: String, type: String, quantity: Int) {
        self.color = color;
        self.type = type
        self.quantity = quantity
    }
    
   
}




class ModelInfo {
    var LDRAW_dimensions = Dimensions()
    var INCHES_dimensions = Dimensions()
    var MILLIMETERS_dimensions = Dimensions()

    var totalBricks = 0
    func setDimensions(dimensions: Dimensions) {
        LDRAW_dimensions = dimensions;
        MILLIMETERS_dimensions = Dimensions(width: dimensions.width * 0.4, height: dimensions.height * 0.4, depth: dimensions.depth * 0.4)

        INCHES_dimensions = Dimensions(width: MILLIMETERS_dimensions.width / 25.4 , height: MILLIMETERS_dimensions.height / 25.4, depth: MILLIMETERS_dimensions.depth / 25.4)
        
        
        print(MILLIMETERS_dimensions, LDRAW_dimensions)
    }
    
    var bricks:[BrickInfo] = []

    func setBricks(nodes: [Brick]) {
        totalBricks = nodes.count
        for brick in nodes {
           checkIndexed(brick)
        }
    }
    
    func checkIndexed(brick: Brick) {
        if (bricks.count > 0) {
        for i in 0...bricks.count-1 {
            var indexed = bricks[i]
            
            if (brick.hex == indexed.color && brick.type == indexed.type) {
                indexed.quantity += 1
//                print(brick.hex, indexed.color)

                return
            }
        }
        }
        bricks.append(BrickInfo(color: brick.hex, type: brick.type, quantity: 1))
        
    }
    
}