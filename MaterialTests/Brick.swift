//
//  Brick.swift
//  Prototype
//
//  Created by Evan Bacon on 11/30/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit


class Brick: SCNNode {
    
    var hex:String!
    var type:String!
    var ldColor:Int!
    
    
    required override init() {
        super.init()
        //        baseInit()
    }
    
    required convenience init(Position: SCNVector3, type: String, color: Int){
        self.init()
        self.position = Position
        
        
        self.type = type;
        self.ldColor = color;
        assembleGeometry();
        
        setColor()
        
        addStuds();
    }
    
    func setColor(){
        let key = "\(ldColor)"
        let filtered = colors!.filter { $0["Id"] == key}
        hex = (filtered[0]["Color"] as? AnyObject) as! String
        self.geometry!.firstMaterial?.diffuse.contents = UIColor(hexString: hex)
    }
    
    
    func getColor() -> UIColor {
        return self.geometry!.firstMaterial?.diffuse.contents as! UIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func assembleGeometry(){
        let library = BrickLibrary()
        let list = library[type]?.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]!
        
        let box = SCNBox(
            width: CGFloat((list[0] as NSString).floatValue),
            height: CGFloat((list[1] as NSString).floatValue),
            length: CGFloat((list[2] as NSString).floatValue),
            chamferRadius: 2)
        
        
        box.heightSegmentCount = 1;
        box.lengthSegmentCount = 1;
        box.widthSegmentCount = 1;
        self.geometry = box;
        
    }
    
    func addStuds() {
        
        let studY = 14;
        
        let c = self.geometry?.firstMaterial?.diffuse.contents as? UIColor!
        
        let material = SCNMaterial()
        material.diffuse.contents = c!.accent()
        
        
        if (type == "3005") {
            self.name = "1x1";
            
            self.stud(SCNVector3Make(0, Float(studY), 0), color: material, parent: self)
            //            [self stud:SCNVector3Make(0, studY, 0) color:matStud parent:self];
            return;
        }
        else if (type == "3004") {
            self.name = "1x2";
            for (var inc = 10; inc > -30; inc-=20) {
                
                self.stud(SCNVector3Make(Float(inc), Float(studY), 0),color:  material,parent:  self)
                
            }
            return;
        }
        else if (type == "3001") {
            self.name = "2x4";
            for (var inc = 30; inc > -50; inc-=20) {
                self.stud(SCNVector3Make(Float(inc), Float(studY), 10),color:  material,parent:  self)
                self.stud(SCNVector3Make(Float(inc), Float(studY), -10),color:  material,parent:  self)
                
                
            }
            return;
        }
        else if (type == "3003") {
            self.name = "2x2";
            for (var inc = 10; inc > -30; inc-=20) {
                
                self.stud(SCNVector3Make(Float(inc), Float(studY), 10),color:  material,parent:  self)
                
                self.stud(SCNVector3Make(Float(inc), Float(studY), -10),color:  material,parent:  self)                
                
            }
            return;
        }
        else {
            NSLog("UNKNOWN BRICK!");
            return;
        }
        
        
    }
    
    
    
    //    -(void) applyRotationMatrix:(NSArray *)rotationMatrix {
//        self.rotationMatrix = rotationMatrix;
    //
//        if ([rotationMatrix[0] floatValue] == 0 || [rotationMatrix[0] floatValue] == -0 ) self.eulerAngles = SCNVector3Make(0, 1*M_PI/2, 0); //Orientation
    //    }
    //
    
    
    
    var rotationMatrix:[String] = []
    func applyRotationMatrix(rotation: [String]) {
        self.rotationMatrix = rotation;

        if ((rotation[0] as NSString).floatValue == 0 || (rotation[0] as NSString).floatValue == -0 ) {
           
            self.eulerAngles = SCNVector3Make(0, Float(1.0 * Double(M_PI / 2)), 0); //Orientation
        }

    }
    
    
    func stud(position: SCNVector3, color: SCNMaterial, parent: SCNNode) {
        
        let cylinder = SCNCylinder(radius: 6, height: 5)
        cylinder.radialSegmentCount = 10;
        let stud = SCNNode(geometry: cylinder)
        
        //    SCNScene *studScene = [SCNScene sceneNamed:@"stud.dae"];
        //    SCNNode *stud = [studScene.rootNode childNodeWithName:@"stud" recursively:true].clone;
        
        
        //    SCNNode *mStud = stud.clone;
        stud.name = "stud";
        stud.geometry!.firstMaterial = color;
        stud.position = position;
        parent.addChildNode(stud);
        
    }
    
   
    
    func BrickLibrary() -> [String: String] {
        return [
            "3005" : "20 24 20 1", //1x1
            "3004" :"40 24 20 2", //1x2
            "3001" :"80 24 40 3", //2x4
            "3003" :"40 24 40 4", //2x2
        ]
    }

}

