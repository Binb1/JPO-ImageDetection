//
//  NodeHandler.swift
//  ImageDetection-JPO
//
//  Created by Robin Champsaur on 28/06/2018.
//  Copyright © 2018 Robin Champsaur. All rights reserved.
//

import Foundation
import ARKit

class NodeHandler {
    
    var onScreenNodes : [String]
    
    init() {
        onScreenNodes = []
    }
    
    func createSCObject(text: String, sceneView: ARSCNView) {
        debugPrint("called")
        guard let paperPlaneScene = SCNScene(named: "objects.scnassets/Mario.scn"),
        let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "mario", recursively: true)
            else {
                debugPrint("oh nan")
                return
            }
        paperPlaneNode.position = SCNVector3(0, 0, -0.5)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    func createSceneWithLabel(text: String) -> SKScene {
        let skScene = createScene(width: 500, height: 500)
        let point = CGPoint(x: skScene.frame.size.width/2, y: skScene.frame.size.width/2)
        skScene.addChild(createLabelNode(position: point, text: text))
        return skScene;
    }
    
    func createSceneWithNode(imageName: String) -> SKScene {
        let skScene = createScene(width: 500, height: 500)
        let point = CGPoint(x: skScene.frame.size.width/2, y: skScene.frame.size.width/2)
        skScene.addChild(createSpriteNode(position: point, imageName: imageName))
        return skScene;
    }
    
    func createSceneWithNodeAndLabel(text: String, imageName: String) -> SKScene {
        let skScene = createScene(width: 500, height: 500)
        var point = CGPoint(x: skScene.frame.size.width/2, y: skScene.frame.size.width/1.8)
        skScene.addChild(createSpriteNode(position: point, imageName: imageName))
        point = CGPoint(x: skScene.frame.size.width/2, y: skScene.frame.size.width/5)
        skScene.addChild(createLabelNode(position: point, text: text))
        return skScene;
    }
    
    func createScene(width: Int, height: Int) -> SKScene {
        let skScene = SKScene(size:CGSize(width: width, height: height))
        skScene.backgroundColor = SKColor(white:0,alpha:0)
        return skScene
    }

    
    func createLabelNode(position: CGPoint, text: String) -> SKLabelNode {
        //Creating the SKLabelNode
        let label = SKLabelNode(fontNamed:"Menlo-Bold")
        label.fontSize = 60
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.text = text
        var diff = 0
        if let str = label.text {
            diff = str.count * 15
            debugPrint(diff)
        }
        label.position = CGPoint(x: position.x - CGFloat(diff), y: position.y)
        label.zRotation = .pi
        label.xScale *= -1
        
        //Adding the node to the array of nodes
        onScreenNodes.append(text)
        
        return label
    }
    
    func createSpriteNode(position: CGPoint, imageName: String) -> SKSpriteNode {
        let spriteNode = SKSpriteNode(imageNamed: imageName)
        spriteNode.position = CGPoint(x: position.x, y: position.y)
        spriteNode.zRotation = .pi
        spriteNode.xScale *= -1
        return spriteNode
    }
}
