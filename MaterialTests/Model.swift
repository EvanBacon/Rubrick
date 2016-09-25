//
//  Model.swift
//  Prototype
//
//  Created by Evan Bacon on 12/1/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Model: SCNNode {
    
    var bricks:[Brick] = []
    var layers:[SCNNode] = []

    var info:ModelInfo!
    
    
    
    func getBoundsOfNode(node: SCNNode) -> SCNVector3 {
        
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            return SCNVector3(
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
        }
        return SCNVector3Zero
    }
    
    
    
    
    required override init() {
        super.init()
        //        baseInit()
    }
    
    required convenience init(bricks: [Brick]){
        self.init()
        self.bricks = bricks
        
        grid = SCNNode()
        self.addChildNode(grid)
        
        info = ModelInfo()
        info.setBricks(bricks)
    
        
//        buildColorGroups()
            buildLayers()
        
        
        assembleGeometry()
    
        let bounds = getBoundsOfNode(self)
        info.setDimensions(Dimensions(width: bounds.x, height: bounds.y, depth: bounds.z))
    }
    
    
    func buildLayers(){
        let set = NSMutableSet(array: [])
        for box in bricks {
            set.addObject(box.position.y)
        }
        
        var arr:[Float] = set.map({ Float($0 as! NSNumber) })  // Swift 2

        arr = arr.sort({
            return $0 < $1
        })
        
        for i in 0...set.count-1 {
            let node = SCNNode()
            node.name = "\(i)"
            layers.append(node)
        }
        
        for box in bricks {
            let index = arr.indexOf(box.position.y)
            layers[index!].addChildNode(box)
        }
    }
    
    func maxVisibleLayer() -> Int {
        for (var i = 0; i < layers.count; i++) {
            if (layers[i].hidden == true) {

                return min(i + 1, layers.count - 1)
            }
        }
        return 0
    }
    
    
    
    func infoForCurrentLayer() -> ModelInfo{
        return infoForLayer(maxVisibleLayer())
    }

    
    func infoForLayer(layer: Int) -> ModelInfo{
        
        let info = ModelInfo()
        
        info.setBricks(getLayer(layer).childNodes as! [Brick])
        return info
    }
    
    func buildColorGroups(){
        let set = NSMutableSet(array: [])
        for box in bricks {
            set.addObject(box.ldColor)
        }
        
        var arr:[Int] = set.map({ Int($0 as! NSNumber) })  // Swift 2
        
        arr = arr.sort({
            return $0 < $1
        })
        
        
        for i in 0...set.count-1 {
            let node = SCNNode()
            node.name = "\(i)"
            layers.append(node)
        }
        
        for box in bricks {
            let index = arr.indexOf(box.ldColor)
            layers[index!].addChildNode(box)
        }
        
    }
    
    
    func assembleGeometry() {

//        for box in bricks {
//            self.addChildNode(box);
//            //            brickCount += [[box childNodes] count];
//        }

        for layer in layers {
            self.addChildNode(layer);
            //            brickCount += [[box childNodes] count];
        }

        
    }
    
//    func sortByLayer() {
//        
//        var sorted:[[Brick]] = []
//        for brick in bricks {
//            
//            
//        }
//        
//        bricks.sortInPlace({ $0.position.y > $1.position.y })
//    }
    
    
    var grid:SCNNode!
    let gridCell = UIImage(named: "point-hi.png")
    let brickSize:CGFloat = 20

    func setGridForLayer(layer: Int) {
        let node = getLayer(layer)

        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            let bounds = SCNVector3(
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
            
            
            updateGrid(SCNVector3Make(minVec.x + bounds.x/2, minVec.y + 0.01 , minVec.z + bounds.z/2), size: CGSizeMake(CGFloat(bounds.x), CGFloat(bounds.z)))
        }
    }
    

    
    func updateGrid(position: SCNVector3, size: CGSize) {

        
        let material = SCNMaterial();
        material.diffuse.contents = gridCell;
        //    material.transparency = 0.7;
        material.diffuse.wrapS = .Repeat;
        material.diffuse.wrapT = .Repeat;

        material.litPerPixel = false;
        
        
        let plane = SCNPlane(width: size.width, height: size.height)
        grid.geometry = plane;
        //        grid.hidden = shouldHide;
        grid.eulerAngles = SCNVector3Make((Float(M_PI) * 1.5), 0, 0);
        grid.position = position;
        grid.geometry!.firstMaterial = material;
        grid.geometry!.firstMaterial!.diffuse.contentsTransform = SCNMatrix4MakeScale(Float( size.width / brickSize), Float( size.height / brickSize), 1);
        grid.geometry!.firstMaterial!.locksAmbientWithDiffuse = true;
        
    }
    
    
    func getLayer(layer: Int) -> SCNNode {
        return layers[max(0, min(layer, bricks.count - 1))]
    }
    
    
    func goDownLayer() {
        for (var i = layers.count - 1; i > -1; i--) {
            if (layers[i].hidden == false) {
                layers[i].hidden = true
                
                setGridForLayer(i - 1)
                return
            }
        }
    }
    
    func goUpLayer() {
        for (var i = 0; i < layers.count; i++) {
            if (layers[i].hidden == true) {
                layers[i].hidden = false
                
                setGridForLayer(i)

                return
            }
        }
    }

    func setMaxVisibleLayer(layer: Int) { //0 is bottom : layers - 1 is top
        for (var i = 0; i < layers.count; i++) {
            if (i <= layer) {
                layers[i].hidden = false
            } else {
                layers[i].hidden = true
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}
