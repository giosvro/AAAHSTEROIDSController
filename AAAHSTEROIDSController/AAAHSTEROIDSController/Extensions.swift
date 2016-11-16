//
//  Extensions.swift
//  AAAHSTEROIDSController
//
//  Created by Gabrielle Brandenburg dos Anjos on 16/11/16.
//  Copyright © 2016 Gabrielle Brandenburg dos Anjos. All rights reserved.
//

import SpriteKit

extension CGVector {
    
    mutating func applyModule (speed: CGFloat){
        self.dx = speed*self.dx
        self.dy = speed*self.dy
    }
    
    init (point1: CGPoint, point2: CGPoint){
        
        let dx: CGFloat = point2.x - point1.x
        let dy: CGFloat = point2.y - point1.y
    
        self.dx = dx
        self.dy = dy
    }
    
}

