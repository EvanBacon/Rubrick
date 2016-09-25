//
//  SCNNode+Extension.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/9/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import SceneKit



extension SCNNode {
    func size() -> SCNVector3 {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        getBoundingBoxMin(&min, max: &max)
        
        return max - min
    }
    
    func minBounds() -> SCNVector3 {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        getBoundingBoxMin(&min, max: &max)
        max = SCNVector3()
        return min
    }
    
    
    var center:SCNVector3 {
        get {
            var minVec = SCNVector3Zero
            var maxVec = SCNVector3Zero
            if getBoundingBoxMin(&minVec, max: &maxVec) {
                let bound = SCNVector3(
                    x: minVec.x + ((maxVec.x - minVec.x)/2),
                    y: minVec.y + ((maxVec.y - minVec.y)/2),
                    z: minVec.z + ((maxVec.z - minVec.z)/2) )
                
                return bound
            }
            return SCNVector3()
        }
    }
    
    
    func resetTransforms() {
        self.rotation = SCNVector4(0,1,0,M_PI)
        self.scale = SCNVector3(1,1,1)
        self.position = SCNVector3()
    }
    
    func centerPivot() {
        
        //        var position = transform;
        //        let inversePosition = CATransform3DInvert(position);
        

        pivot = SCNMatrix4MakeTranslation(0.5, 0.5, 0.5)

//        var minVec = SCNVector3Zero
//        var maxVec = SCNVector3Zero
//        if getBoundingBoxMin(&minVec, max: &maxVec) {
//            let bound = SCNVector3(
//                x: maxVec.x - minVec.x,
//                y: maxVec.y - minVec.y,
//                z: maxVec.z - minVec.z)
//            
//            pivot = SCNMatrix4MakeTranslation(bound.x / 2, bound.y / 2, bound.z / 2)
//        }
    }
}

extension SCNScene {
    convenience init(withName:String?) {
        if let name = withName {
            self.init(named: name)!
        } else {
            self.init()
        }
    }
}

extension SCNLight {
    func defaultOmni() -> SCNLight {
        type = SCNLightTypeOmni
        return self
    }
    func defaultAmbient() -> SCNLight {
        type = SCNLightTypeAmbient
        color = UIColor.grayColor()
        return self
    }
}


