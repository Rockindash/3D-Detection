//
//  ViewController.swift
//  3D_Demo
//
//  Created by amol kumar on 12/04/1940 Saka.
//  Copyright © 1940 amol kumar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Object Detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Model", bundle: Bundle.main)!
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor{
            
            //Gray Plane
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x), height: CGFloat(objectAnchor.referenceObject.extent.y))
            plane.cornerRadius = plane.width/8
            plane.firstMaterial?.diffuse.contents = UIColor.black
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.01, objectAnchor.referenceObject.center.z)
            
            let phoneScene = SCNScene(named: "art.scnassets/iPhoneX.scn")!
            let phoneNode = phoneScene.rootNode.childNodes.first!
            let min = phoneNode.boundingBox.min
            let max = phoneNode.boundingBox.max
            phoneNode.pivot = SCNMatrix4MakeTranslation(min.x + (max.x - min.x)/2, min.y + (max.y - min.y), min.z + (max.z - min.z)/2)
            phoneNode.eulerAngles.x = .pi / 2
            planeNode.addChildNode(phoneNode)
            
            phoneNode.runAction(translateObject())
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                phoneNode.runAction(self.rotateObject())
            }
            node.addChildNode(planeNode)
        }
        return node
    }
    
    //Animation
    func rotateObject() -> SCNAction {
        let action = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(GLKMathDegreesToRadians(360)), duration: 3)
        let repeatAction = SCNAction.repeatForever(action)
        return repeatAction
    }
    
    func translateObject() -> SCNAction {
        let translation = SCNAction.move(by: SCNVector3(0, 0, 0.14), duration: 2)
        return translation
    }
}
