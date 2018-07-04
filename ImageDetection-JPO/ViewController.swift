//
//  ViewController.swift
//  ImageDetection-JPO
//
//  Created by Robin Champsaur on 25/06/2018.
//  Copyright © 2018 Robin Champsaur. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let nodeHandler = NodeHandler()
    let imgDictionnary = ImageDictionnary()
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTracking(ressourceFolder: Constants.ARReference.folderName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func configureTracking(ressourceFolder: String) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: ressourceFolder, bundle: nil) else {
            fatalError("Missing expected asset catalog resources")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let ref = imageAnchor.referenceImage
        updateQueue.async {
            
            //Initialize an SKScene to add 2D text to the SCScene
            var skScene: SKScene!
            //Triple check to see if the SKScene and the node can be created
            if let name = ref.name {
                if let dicoDescr = self.imgDictionnary.dictionnary[name] {
                    if !self.nodeHandler.onScreenNodes.contains(dicoDescr) {
                        //Creation of the SKScene, the SKLabelNode and the SCNPlane
//                        skScene = self.nodeHandler.createSceneWithLabel(text: dicoDescr)
                        skScene = self.nodeHandler.createSceneWithNodeAndLabel(text: dicoDescr, imageName: "logo-epita.png")
                        
                        //Create a plane on top of the detected image
                        let plane = SCNPlane(width: ref.physicalSize.width,
                                             height: ref.physicalSize.height)
                        let material = SCNMaterial()
                        material.lightingModel = SCNMaterial.LightingModel.constant
                        material.isDoubleSided = false
                        material.diffuse.contents = skScene
                        plane.materials = [material]
                        let planeNode = SCNNode(geometry: plane)
                        planeNode.opacity = 1
                        planeNode.eulerAngles.x = -.pi / 2

                        node.addChildNode(planeNode)
                    }
                }
            }
        }
    }
}
