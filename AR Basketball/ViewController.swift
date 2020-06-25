//
//  ViewController.swift
//  AR Basketball
//
//  Created by Giorgi Jashiashvili on 6/17/20.
//  Copyright © 2020 Giorgi Jashiashvili. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addHoopBtn: UIButton!
    var cameraPlace = SCNVector3()
    
    var actionNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene

        
        
        

        
    }
    
    func horizontalAction(node: SCNNode) {
        
        let leftAction = SCNAction.move(by: SCNVector3(-1, 0, 0), duration: 3)
        let rightAction = SCNAction.move(by: SCNVector3(1, 0, 0), duration: 3)
        
        let actionSequence = SCNAction.sequence([leftAction, rightAction])
        
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
        
    }
    
    func roundAction(node: SCNNode) {
        let rightUp = SCNAction.move(by: SCNVector3(1, 1, 0), duration: 2)
        let Rightdown = SCNAction.move(by: SCNVector3(1, -1, 0), duration: 2)
        let leftDown = SCNAction.move(by: SCNVector3(-1, -1, 0), duration: 2)
        let leftUp = SCNAction.move(by: SCNVector3(-1, 1, 0), duration: 2)
        
        let roundSequence = SCNAction.sequence([rightUp,Rightdown,leftDown,leftUp])
        
        node.runAction(SCNAction.repeat(roundSequence, count: 2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        
        if let camera = sceneView.session.currentFrame?.camera {
            let cameraLocation = SCNVector3(camera.transform.columns.3.x, camera.transform.columns.3.y, camera.transform.columns.3.z)
            let cameraOrientation = SCNVector3(-camera.transform.columns.2.x, -camera.transform.columns.2.y, -camera.transform.columns.2.z)
            let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y, cameraLocation.z + cameraOrientation.z)
            cameraPlace = cameraPosition
            
            let ball = SCNSphere(radius: 0.15)
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "basketballSkin.png")
            ball.materials = [material]
            
            let ballNode = SCNNode(geometry: ball)
            ballNode.position = cameraPosition
            print(cameraPosition)
            
            sceneView.scene.rootNode.addChildNode(ballNode)
            
            
            let ballPhysics = SCNPhysicsBody(type: .dynamic, shape: nil)
            ballPhysics.applyForce(SCNVector3(cameraPosition.x * 6, cameraPosition.y * 10, cameraPosition.z * 6), asImpulse: true)
            ballNode.physicsBody = ballPhysics
            
        }
        
        
    }
    
    
    
    
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    @IBAction func startHorizAction(_ sender: UIButton) {
        horizontalAction(node: actionNode)
        
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        actionNode.removeAllActions()
        
    }
    
    @IBAction func roundAction(_ sender: UIButton) {
        roundAction(node: actionNode)
        
    }
    
    @IBAction func addHoopPressed(_ sender: UIButton) {
        
        actionNode.removeFromParentNode()
        
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
        
        if let backboardNode = hoopScene.rootNode.childNode(withName: "backboard", recursively: true) {
            backboardNode.removeFromParentNode()
            actionNode = backboardNode
            
            //sceneView.scene = hoopScene
            backboardNode.position = SCNVector3(cameraPlace.x, cameraPlace.y + 0.5, cameraPlace.z - 3)
            print(backboardNode.position)
            
            sceneView.scene.rootNode.addChildNode(backboardNode)

        }
        // Set the scene to the view
                addHoopBtn.isHidden = true
        
    }
    
    
    
}
