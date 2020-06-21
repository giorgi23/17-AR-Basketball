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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/hoop.scn")!
        
        if let backboardNode = scene.rootNode.childNode(withName: "backboard", recursively: true) {
            backboardNode.position = SCNVector3(0, 0.5, -3)
            
        }
        
        // Set the scene to the view
        sceneView.scene = scene

        
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
            
            let ball = SCNSphere(radius: 0.15)
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "basketballSkin.png")
            ball.materials = [material]
            
            let ballNode = SCNNode(geometry: ball)
            ballNode.position = cameraPosition
            
            sceneView.scene.rootNode.addChildNode(ballNode)
            
            
            let ballPhysics = SCNPhysicsBody(type: .dynamic, shape: nil)
            ballPhysics.applyForce(SCNVector3(cameraPosition.x * 0, cameraPosition.y * 10, cameraPosition.z * 6), asImpulse: true)
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
}
