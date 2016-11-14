//
//  GameScene.swift
//  AAAHSTEROIDSController
//
//  Created by Gabrielle Brandenburg dos Anjos on 04/11/16.
//  Copyright © 2016 Gabrielle Brandenburg dos Anjos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //TODO: mudar para string:any depois ::: duvida
    var messageToSend: [String:String] = ["":""]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var peerName = String()
    
    var counter = 0
    
    var touch1 = CGPoint()
    var touch2 = CGPoint()
    //var dx = CGFloat()
    //var dy = CGFloat()
    var direction = CGVector()
    
    var move = SKAction()
    
    //var location = ()
    
    private var miraNode : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        
        
        peerName = appDelegate.mpcManager.peerID.displayName
        
        //messageToSend = [peerName:["x":"", "y": ""]]
        
        
        // Get label node from scene and store it for use later

        self.miraNode = self.childNode(withName: "//mira") as? SKSpriteNode
        if let mira = self.miraNode {
            mira.alpha = 0.0
            mira.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        /*let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
 
 */
    }
    
    func moveMira(dir: CGVector, duration: Double){
        
        //move.
        move = SKAction.move(by: dir, duration: duration)
        
        miraNode?.run(move)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }*/
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }*/
        
        touch1 = touch2;
        touch2 = pos;
        let dx: CGFloat = touch2.x - touch1.x
        let dy: CGFloat = touch2.y - touch1.y
        
        
        let norma = sqrt(dx*dx + dy*dy)
        direction = CGVector(dx: dx, dy: dy)
        let time = norma / 30.0
        moveMira(dir: direction, duration: Double(time))
        
        //direction = touch2 - touch1;
        
        
        let xPos = String(describing: pos.x)
        let yPos = String(describing: pos.y)
        
        counter += 1
        
        print("\n toque \(counter) x: \(xPos) y: \(yPos)")
        
        //MARK: COMENTADO PARA TESTAR A POSIÇÃO
        
        //messageToSend = ["sender": peerName, "x": xPos, "y": yPos]
        
        //TODO: PRECISA REVISAR!
        
        /*
        if appDelegate.mpcManager.sendData(dictionaryData: messageToSend, toPeer: appDelegate.mpcManager.session.connectedPeers[0]) {
            print("message sent")
        } else {
            print("error: message not sent")
        }
         */
 
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }*/
        
        touch1 = CGPoint.zero;
        touch2 = CGPoint.zero;
        
        miraNode?.removeAllActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }*/
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //let touchedNode = self.atPoint(t.location(in: self))
        
            self.touchMoved(toPoint: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
