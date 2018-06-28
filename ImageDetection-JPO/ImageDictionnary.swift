//
//  ImageDictionnary.swift
//  ImageDetection-JPO
//
//  Created by Robin Champsaur on 28/06/2018.
//  Copyright © 2018 Robin Champsaur. All rights reserved.
//

import Foundation
import ARKit

class ImageDictionnary {
    
    var dictionnary: [String: String]
    
    init() {
        dictionnary = [String: String]()
        getElements(ressourceFolder: "WorldCup")
    }
    
    func getElements(ressourceFolder: String) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: ressourceFolder, bundle: nil) else {
            fatalError("Missing expected asset catalog resources")
        }
        
        for im in referenceImages {
            if let name = im.name {
                dictionnary[name] = name
            }
        }
    }
    
}
