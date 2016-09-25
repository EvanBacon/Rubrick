//
//  GameViewController.swift
//  Prototype
//
//  Created by Evan Bacon on 11/30/15.
//  Copyright (c) 2015 Evan Bacon. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Material
var model:Model!

//var fileName = "Wonder Woman.ldr"
var fileName = "test.ldr"

class ModelViewController: UIViewController {
    var menuButton:IconButton!
    var switchControl:MaterialSwitch!
    var searchButton:IconButton!
    
    var topDownView:Bool = false {
        didSet {
            if topDownView {
                let look = SCNLookAtConstraint(target: model)
                look.gimbalLockEnabled = true
                
                cameraNode.constraints = [look]
            } else {
                cameraNode.constraints = nil
            }
        }
    }
    var scnView:SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prepareMenuButton()
        prepareSearchButton()
        prepareSwitchControl()
        
        prepareNavigationItem()
        
        buildScene()
        
        buildModel()
        
        setupSlider()
        
        setSceneViewGestureRecognizers()
//        buildUI()
    }
   
    var cameraNode:SCNNode!
    var cameraVerticalNode:SCNNode!

    var curXRadians = Float(0)
    var curYRadians = Float(0)

    
    var cameraScale:Float = 0
}

extension ModelViewController: UIGestureRecognizerDelegate {
    // =======================================================================================================
    // Gesture Functions
    // =======================================================================================================
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if ((gestureRecognizer is UIPinchGestureRecognizer || gestureRecognizer is UIPanGestureRecognizer)
            && (otherGestureRecognizer is UIPinchGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer)) {
            return false
        } else {
            return true
        }
    }
    

    func sceneViewPannedTwoFingers(sender: UIPanGestureRecognizer) {
        // Get pan distance & convert to radians
        let translation = sender.translationInView(sender.view!)
//        var xRadians = GLKMathDegreesToRadians(Float(translation.x))
//        var yRadians = GLKMathDegreesToRadians(Float(translation.y))

        cameraVerticalNode.position.x = cameraVerticalNode.position.x + Float(translation.x)
        cameraVerticalNode.position.y = cameraVerticalNode.position.y + Float(translation.y)

    }
}

extension ModelViewController {
    
    func setupSlider() {
        var napySlider2: NapySlider!
        
        napySlider2 = NapySlider(frame: CGRectMake( view.frame.size.width - 25, 15, 50, view.frame.size.height - 150))
        view.addSubview(napySlider2)
        
        napySlider2.addTarget(self, action: #selector(ModelViewController.sliderValueChanged(_:)), forControlEvents: .AllEvents)
        napySlider2.min = 0
        napySlider2.max = Double(model.layers.count)
        napySlider2.step = 1
    }
    
    func sliderValueChanged(sender:NapySlider) {
        print(sender.handlePosition)
        model.setMaxVisibleLayer(Int(sender.handlePosition))
    }
    
    private func setSceneViewGestureRecognizers() {
        // Handle one-finger pans
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sceneViewPannedOneFinger))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        scnView.addGestureRecognizer(panRecognizer)
        
        // Handle two-finger pans
        let twoFingerPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sceneViewPannedTwoFingers))
        twoFingerPanRecognizer.minimumNumberOfTouches = 2
        twoFingerPanRecognizer.maximumNumberOfTouches = 2
        twoFingerPanRecognizer.delegate = self
        scnView.addGestureRecognizer(twoFingerPanRecognizer)
        
        // Handle pinches
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(sceneViewPinched))
        pinchGesture.delegate = self
        scnView.addGestureRecognizer(pinchGesture)
        
        // Handle taps
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneViewTapped))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.requireGestureRecognizerToFail(panRecognizer)
        tapRecognizer.requireGestureRecognizerToFail(twoFingerPanRecognizer)
        tapRecognizer.requireGestureRecognizerToFail(pinchGesture)
        scnView.addGestureRecognizer(tapRecognizer)
        
        // Handle two finger taps
        /*let twoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneViewTappedTwoFingers))
         twoTapRecognizer.numberOfTouchesRequired = 2
         twoTapRecognizer.requireGestureRecognizerToFail(panRecognizer)
         twoTapRecognizer.requireGestureRecognizerToFail(twoFingerPanRecognizer)
         twoTapRecognizer.requireGestureRecognizerToFail(pinchGesture)
         sceneView.addGestureRecognizer(twoTapRecognizer) */
    }
    
    
    
    
    func sceneViewPannedOneFinger(sender: UIPanGestureRecognizer) {
   
        let position = sender.locationInView(sender.view!)
        
        
  
        // If here, not in Camera mode so look around scene
        // Get pan distance & convert to radians
        let translation = sender.translationInView(sender.view!)
        var xRadians = GLKMathDegreesToRadians(Float(translation.x))
        var yRadians = GLKMathDegreesToRadians(Float(translation.y))
        
        
        //print("ONE FINGER x: \(xRadians). y: \(yRadians). curXRadians: \(curXRadians). curYRad: \(curYRadians).")
        
        
        
        // Get x & y radians
        xRadians = (xRadians / 4) + curXRadians
        yRadians = (yRadians / 4) + curYRadians
        
        // Limit yRadians to prevent rotating 360 degrees vertically
        yRadians = max(Float(-M_PI_2), min(Float(M_PI_2), yRadians))
        
        // Set rotation values to avoid Gimbal Lock
//        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: yRadians)
//        cameraVerticalNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: xRadians)
        
        cameraVerticalNode.eulerAngles = SCNVector3(yRadians, xRadians, 0)
        
        // Save value for next rotation
        if sender.state == UIGestureRecognizerState.Ended {
            curXRadians = xRadians
            curYRadians = yRadians
        }
        
    }
    
    

    func sceneViewTapped(sender: UITapGestureRecognizer) {

        if sender.numberOfTouches() > 1 {
            cameraVerticalNode.eulerAngles = SCNVector3()
            curXRadians = 0
            curYRadians = 0
            cameraVerticalNode.position = SCNVector3()

        }
    }
    
    func sceneViewPinched(gesture: UIPinchGestureRecognizer) {
        // Kill timer when gesture ends
        if gesture.state == .Ended {
//            moveTimer.invalidate()
//            pinchDir = nil
        } else if gesture.state == . Changed {
//            // Set baseline scale
//            let baselineScale = CGFloat(1.0)
//            
//            // Compute pinch delta
//            let delta = gesture.scale - baselineScale
//            
//            // Determine direction user should move
//            let newDir = delta > 0 ? DPadDirection.Closer : .Away
//            
//            // Adjust movement if moving in new direction
//            if newDir != pinchDir {
//                pinchDir = newDir
//                didDPadMove(newDir)
//                moveTimer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(startAutoZoom), userInfo: nil, repeats: true)
//                moveTimer.fire()
//            }
        }
    }

    

    
}

extension ModelViewController {
    /// Handles the menuButton.
    internal func handleMenuButton() {
        sideNavigationController?.openLeftView()
    }
    
    /// Handles the searchButton.
    internal func handleSearchButton() {
        var recommended: Array<MaterialDataSourceItem> = Array<MaterialDataSourceItem>()
//        recommended.append(dataSourceItems[1])
//        recommended.append(dataSourceItems[3])
//        recommended.append(dataSourceItems[5])
        
        let vc: AppSearchBarController = AppSearchBarController(rootViewController: RecommendationViewController(dataSourceItems: recommended))
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true, completion: nil)
    }

    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = MaterialIcon.cm.menu
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    
    /// Prepares the switchControl.
    private func prepareSwitchControl() {
        switchControl = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
        switchControl.addTarget(self, action: #selector(ModelViewController.switchToggled(_:)), forControlEvents: .ValueChanged)
    }
    
    func switchToggled(sender:MaterialSwitch) {
        topDownView = sender.on
    }
    
    /// Prepares the searchButton.
    private func prepareSearchButton() {
        let image: UIImage? = MaterialIcon.cm.search
        searchButton = IconButton()
        searchButton.pulseColor = MaterialColor.white
        searchButton.setImage(image, forState: .Normal)
        searchButton.setImage(image, forState: .Highlighted)
        searchButton.addTarget(self, action: #selector(handleSearchButton), forControlEvents: .TouchUpInside)
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.titleLabel.text = fileName.substringToIndex(fileName.characters.indexOf(".")!)
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.leftControls = [menuButton]
        navigationItem.rightControls = [switchControl, searchButton]
    }

}

extension ModelViewController {
    
    func buildUI() {
        
        self.title = fileName.substringToIndex(fileName.characters.indexOf(".")!)
        
        
        
        
        let hei = self.view.frame.size.height * 0.2
        let shelf = ShelfView(frame: CGRectMake(0,self.view.frame.size.height - hei,self.view.frame.size.width,hei))
        
        self.view.addSubview(shelf)
        
        
        
    }
    
    
    
    func buildModel() {
        
        let parser = FileParser()
        parser.parse(fileName)
        
        
        model = Model(bricks: parser.BrickList)
        model.position = SCNVector3Zero
        scnView.scene?.rootNode.addChildNode(model)
        
        //        centerNodePivot(model)
        
        getCameraScaleForNode(model)
        //        cameraNode.camera?.orthographicScale = Double(50)
        
        
        
        centerCameraOnModel(model, camera: cameraNode)
        
        
        cameraNode.camera?.orthographicScale = Double(cameraScale/3 )
        print(cameraScale)
    }
    
    
    
    func centerCameraOnModel(node: SCNNode, camera:SCNNode) {
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            
            let bound = SCNVector3(
                
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
            
            
            let center = SCNVector3(
                x: minVec.x + (bound.x/2),
                y: minVec.y + (bound.y/2),
                z: minVec.z + (bound.z/2))
            
            
            
            cameraVerticalNode.pivot = SCNMatrix4MakeTranslation(0, 0, center.z)

            if (minVec.z < 0 && maxVec.z > 0) {
                let minDist = maxVec.z * -1;
                
                let zed = (maxVec.z > minDist) ? maxVec.z : minDist
                cameraVerticalNode.position = SCNVector3Make(center.x, center.y,
                                                 
                                                 center.z + max(maxVec.x, max(maxVec.y ,maxVec.z )));
            }
            else {
                cameraVerticalNode.position = SCNVector3Make(center.x, center.y, maxVec.z);
            }
//
        }
    }
    
    func buildScene(){
        // create a new scene
        let scene = SCNScene()
        
        buildCamera(scene)
        
        
        
        
        //        buildLights(scene)
        
        // retrieve the SCNView
        
        
        scnView = SCNView()
//        scnView.debugOptions.insert(.ShowBoundingBoxes)
        // set the scene to the view
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(scnView)
        MaterialLayout.alignToParent(self.view, child: scnView)
        buildGestures(scnView)
        
    }
    
    func buildGestures(scnView: SCNView){
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func buildLights(scene: SCNScene){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        
    }
    func buildCamera(scene: SCNScene){
        // create and add a camera to the scene
        
        cameraVerticalNode = SCNNode()
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.automaticallyAdjustsZRange = true
        scene.rootNode.addChildNode(cameraVerticalNode)
        cameraVerticalNode.addChildNode(cameraNode)

//         place the camera
//        cameraVerticalNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
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
    
    
    
    
    
    func centerNodePivot(node: SCNNode) -> SCNMatrix4 {
        
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            let bound = SCNVector3(
                
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
            
            
            let center = SCNVector3(
                x: minVec.x + (bound.x/2),
                y: minVec.y + (bound.y/2),
                z: minVec.z + (bound.z/2))
            
            
            node.pivot = SCNMatrix4MakeTranslation((bound.x/2),
                                                   (bound.y/2),
                                                   (bound.z/2));
            return node.pivot
            
            
        }
        
        return SCNMatrix4MakeTranslation(0, 0, 0)
    }
    
    
    
    
    func getBoundsOfNode(node: SCNNode) {
        
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            
            
        }
    }
    
    
    
    

    func getCameraScaleForNode(node: SCNNode) {
        
        
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if node.getBoundingBoxMin(&minVec, max: &maxVec) {
            let bound = SCNVector3(
                
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
            
            
            let center = SCNVector3(
                x: minVec.x + (bound.x/2),
                y: minVec.y + (bound.y/2),
                z: minVec.z + (bound.z/2))
            
            
            if (bound.x > bound.z) {
                if (bound.x > bound.y) {
                    cameraScale = (bound.x);
                    
                    //                    cameraScale = (bound.x / Float(20.0));
                }
                else {
                    
                    cameraScale = (bound.y);
                    
                    //                    cameraScale = (bound.y / Float(24.0));
                }
            }
            else {
                if (bound.z >= bound.y) {
                    cameraScale = (bound.z);
                    
                    //                    cameraScale = (bound.z / Float(20.0));
                    //            cameraScale = 10;
                    
                    //            cameraScale = (size.z / 20);
                }
            }
            
            
            
        }
        
        
    }
    

}