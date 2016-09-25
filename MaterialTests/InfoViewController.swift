//
//  InfoViewController.swift
//  Prototype
//
//  Created by Evan Bacon on 12/2/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class InfoViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var items: [String] = ["We", "Heart", "Swift"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Info"
        
        data = model.info.bricks
        
//        data.sort(<#T##isOrderedBefore: (BrickInfo, BrickInfo) -> Bool##(BrickInfo, BrickInfo) -> Bool#>)
        
        
        
//        //Quantity Des
//        data = data.sort({
//            return $0.quantity < $1.quantity
//        })
        
        //Quantity Asc
        data = data.sort({
            return $0.quantity > $1.quantity
        })
        
        
//        self.tableView.registerClass(InfoTableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    
    var data:[BrickInfo] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.items.count;
        return data.count;

    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:InfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! InfoTableViewCell
        
//        model.info.bricks.count;

        let item = data[indexPath.row]
        
//        cell.textLabel?.text = brickName(data.type)
//        cell.backgroundColor = UIColor(hexString: data.color)
        
        

        
        cell.title.text = brickName(item.type)
        cell.body.text = "\(item.quantity)"
        cell.icon.image = UIImage(named: item.type + ".png")

        cell.setColor(UIColor(hexString: item.color))
        
//        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    
}