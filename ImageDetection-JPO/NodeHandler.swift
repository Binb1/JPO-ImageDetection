//
//  NodeHandler.swift
//  ImageDetection-JPO
//
//  Created by Robin Champsaur on 28/06/2018.
//  Copyright © 2018 Robin Champsaur. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class NodeHandler {
    
    var onScreenNodes : [String]
    
    init() {
        onScreenNodes = []
    }
    
    func createSCObject(name: String, rootname: String, sceneView: ARSCNView) {
        debugPrint("called")
        guard let paperPlaneScene = SCNScene(named: name),
        let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: rootname, recursively: true)
            else {
                debugPrint("oh nan -> " + rootname)
                return
            }
        
        //First droite gauche
        //Second -> z vers le haut
        //Third -> Profondeur
        paperPlaneNode.position = SCNVector3(0, 2, -5.5)
        let moveDown = SCNAction.move(by: SCNVector3(0, -0.1, 0), duration: 1)
        let moveUp = SCNAction.move(by: SCNVector3(0,0.1,0), duration: 1)
        let waitAction = SCNAction.wait(duration: 0.25)
        let hoverSequence = SCNAction.sequence([moveUp,waitAction,moveDown])
        let loopSequence = SCNAction.repeatForever(hoverSequence)
        paperPlaneNode.runAction(loopSequence)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    func animateObject(object: SCNNode, objectName: String) {
        if objectName == "XWing" {
            let goStraight = SCNAction.move(by: SCNVector3(0, 0, -10), duration: 1)
            let spin = SCNAction.rotate(by: .pi*2, around: SCNVector3(0, 0, 1), duration: 1)
            let spinLooping = SCNAction.rotate(by: .pi, around: SCNVector3(1, 0, 0), duration: 1)
            let goUp = SCNAction.move(by: SCNVector3(0, 8, 0), duration: 1)
            let goDown = SCNAction.move(by: SCNVector3(0, -8, 0), duration: 1)
            let goBack = SCNAction.move(by: SCNVector3(0, 0, 8), duration: 1)

            let groupFirst = SCNAction.group([goStraight, spin])
            let groupSecond = SCNAction.group([spinLooping, goUp])
            let groupThird = SCNAction.group([goBack, spin])
            let groupFourth = SCNAction.group([spinLooping, goDown])
         
            let hoverSequence = SCNAction.sequence([groupFirst, groupSecond, groupThird, groupFourth])
            
            let loopSequence = SCNAction.repeatForever(hoverSequence)
            object.runAction(loopSequence)
        } else if objectName == "FloatingIsland" {
            let moveDown = SCNAction.move(by: SCNVector3(0, -0.2, 0), duration: 1)
            let moveUp = SCNAction.move(by: SCNVector3(0,0.1,0), duration: 1)
            let waitAction = SCNAction.wait(duration: 0.30)
            let hoverSequence = SCNAction.sequence([moveUp,waitAction,moveDown])
            let loopSequence = SCNAction.repeatForever(hoverSequence)
            object.runAction(loopSequence)
        }
    }
    
    func createSCObjectWithVector(name: String, rootname: String, sceneView: ARSCNView, vect: SCNVector3) {
        debugPrint("called")
        guard let paperPlaneScene = SCNScene(named: name),
            let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: rootname, recursively: true)
            else {
                debugPrint("oh nan")
                return
        }
        
        //First droite gauche
        //Second -> z vers le haut
        //Third -> Profondeur
        paperPlaneNode.position = vect
        animateObject(object: paperPlaneNode, objectName: rootname)
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
