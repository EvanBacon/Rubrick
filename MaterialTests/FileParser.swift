//
//  FileParser.swift
//  Prototype
//
//  Created by Evan Bacon on 11/30/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit


class FileParser: NSObject {
    
    
    var _minBounds:SCNVector3!
    var _maxBounds:SCNVector3!
        
    var orientation:Bool!
    var countedSet:NSCountedSet!
    var colorsSet:NSCountedSet!
    var _ModelFile:NSMutableArray!
    var _ColorList:NSMutableArray!
    var BrickList:[Brick] = []
    
    
    
    func makeBlock(position: SCNVector3, color: Int, type: String, orientation: [Float]) {
        
        
        let brick = Brick(Position: position, type: type, color: color)
//        let brick = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
//        brick.position = position
        BrickList.append(brick)
        
    }
    
    func parse(file: String) {
        
        //    SCNScene *studScene = [SCNScene sceneNamed:@"stud.dae"];
        //    stud = [studScene.rootNode childNodeWithName:@"stud" recursively:false].clone;
        //    stud.geometry.materials = @[];
        
        _minBounds = SCNVector3Make(MAXFLOAT, MAXFLOAT, MAXFLOAT);
        _maxBounds = SCNVector3Make(-MAXFLOAT, -MAXFLOAT, -MAXFLOAT);
        
        

        
        
        //    let ext = file.substringFromIndex(file.characters.count)
        let ext = "ldr"
        if (ext == "ldr") {
            let myFileURL = NSBundle.mainBundle().URLForResource("test", withExtension: "ldr")!
            let contents = try! String(contentsOfURL: myFileURL, encoding: NSUTF8StringEncoding)
            
            
            
            countedSet = NSCountedSet()
            colorsSet = NSCountedSet()
            
            _ModelFile = NSMutableArray()
            _ColorList = NSMutableArray()
            
            let layers = NSCountedSet()
            
            //        int lineCount = 0;
            for currentString in contents.componentsSeparatedByString("\n") {
                //            NSLog(@"File Read: %i",lineCount );
                //            lineCount ++;
                
                if (currentString != "") {
                    
                    if ((currentString as NSString).substringToIndex(1) == "1") {
                        let list = currentString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        
                        
                        //Fix This
                        var y:Float = (list[3] as NSString).floatValue
                        
                        if ((list[9] as NSString).floatValue == 1.0){
                            y = y * -1.0;
                            //                        orientation = true;
                        }
                        
                        
                        //                    NSString *yString = [NSString stringWithFormat:@"%f",y];
                        //
                        //
                        //                    if ([[yString substringToIndex:2] isEqualToString:@"-0"]) {
                        //                        [layers addObject:[yString substringFromIndex:1]];
                        //                    }
                        //                    else {
                        //                        [layers addObject:yString];
                        //                    }
                        
                        
                        
                        
                        let type:String = ((list[14] as NSString) as NSString).substringToIndex(4)
                        
                        
                        let orientation:[Float] = [
                            (list[5] as NSString).floatValue,
                            (list[6] as NSString).floatValue,
                            (list[7] as NSString).floatValue,
                            (list[8] as NSString).floatValue,
                            (list[9] as NSString).floatValue,
                            (list[10] as NSString).floatValue,
                            (list[11] as NSString).floatValue,
                            (list[12] as NSString).floatValue,
                            (list[13] as NSString).floatValue
                            
                        ]
                        
                        makeBlock(SCNVector3Make((list[2] as NSString).floatValue, y, (list[4] as NSString).floatValue), color: (list[1] as NSString).integerValue, type: type, orientation: orientation)
                        
                        
                        
                    }
                }
            }
            
            //        layersCount = [layers count];
            
            
            
        }
    }
}