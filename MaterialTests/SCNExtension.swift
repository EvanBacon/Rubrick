//
//  SCNExtensions.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//


import Foundation
import SceneKit
import GLKit


public extension SCNMatrix4 {
    public var rightVector: SCNVector3 { return SCNVector3(m11, m12, m13) }
    public var upVector: SCNVector3 { return SCNVector3(m21, m22, m23) }
    public var forwardVector: SCNVector3 { return SCNVector3(m31, m32, m33) }
    public var translationVector: SCNVector3 { return SCNVector3(m41, m42, m43) }
}


//EB: Always extend common methods
extension SCNVector3
{
    /**
     * Returns the rounded value of the SCNVector3
     */
    func rounded() -> SCNVector3 {
        return SCNVector3(round(x),round(y),round(z))
    }
}


/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}


/**
 * Increments a SCNVector3 with the value of another.
 */
func += (inout left: SCNVector3, right: SCNVector3) {
    left = left + right
}


/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

