//
//  ViewController+ARSessionDelegate.swift
//  ImageDetection-JPO
//
//  Created by Robin Champsaur on 25/06/2018.
//  Copyright © 2018 Robin Champsaur. All rights reserved.
//

import Foundation
import ARKit

extension ViewController : ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        debugPrint("Error - ARSession failed")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        debugPrint("Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        debugPrint("Restarting session")
        configureTracking(ressourceFolder: Constants.ARReference.folderName)
    }
}
