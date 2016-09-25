//
//  Library.swift
//  Prototype
//
//  Created by Evan Bacon on 12/2/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation

let BrickNamesForId = ["3005" : "1x1", "3004" : "1x2", "3001" : "2x4"]


func brickName(id: String) -> String {
    return BrickNamesForId[id]!
}

let myFileURL = NSBundle.mainBundle().URLForResource("LdrawColors", withExtension: "plist")!
let colors = NSArray(contentsOfURL: myFileURL)


