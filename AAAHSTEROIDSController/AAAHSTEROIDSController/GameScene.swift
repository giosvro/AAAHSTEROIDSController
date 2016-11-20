//
//  GameScene.swift
//  AAAHSTEROIDSController
//
//  Created by Gabrielle Brandenburg dos Anjos on 04/11/16.
//  Copyright © 2016 Gabrielle Brandenburg dos Anjos. All rights reserved.
//

import SpriteKit
import GameplayKit

enum MessageType: Int {
    case MOVE = 1, FIRE, RECHARGE
}

class GameScene: SKScene {
    
    //TODO: mudar para string:any depois ::: duvida
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var peerName = String()
    
    var counter = 0
    
    var touch1 = CGPoint()
    var touch2 = CGPoint()
    
    var fronteira = CGFloat()

    let velocidade: CGFloat = 60.0
    
    var touched : Bool = false
    var location : CGPoint!
    
    //booleana para verificar se o usuário está tocando fora do trackpad
    var inside: Bool = false
    
    private var miraNode : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        fronteira = 0.2*view.bounds.size.width
        peerName = appDelegate.mpcManager.peerID.displayName

        //node usado foi criado na SKScene do storyboard
        self.miraNode = self.childNode(withName: "//mira") as? SKSpriteNode
        if let mira = self.miraNode {
            mira.alpha = 0.0
            mira.zPosition = 5
            //mira.physicsBody = SKPhysicsBody(rectangleOf: mira.size)
        }
    }
    
    func sendMessage(messageDictionary: Dictionary<String, Any>) {
        //TODO: PRECISA REVISAR!
        if appDelegate.mpcManager.sendData(dictionaryData: messageDictionary, toPeer: appDelegate.mpcManager.session.connectedPeers[0]) {
            print("message sent")
        } else {
            print("error: message not sent")
        }
    }
    
    func moveMira(dir: CGVector){
        
        var mutableDir = dir
    
        print("\n 2. posicao x \(miraNode?.position.x) fronteira: \(fronteira)")
        
        if ((miraNode?.position.x)! >= fronteira && dir.dx > 0) {
            print("\n 3. verifica fronteira")
            inside = false
            mutableDir.dx = 0
        }
        
        mutableDir.applyModule(speed: velocidade)
        miraNode?.physicsBody?.velocity = mutableDir    
    }
    
    func fire() {
        print("\nFIRE!!!")
        
        let messageToSend: [String:Any] = ["sender": peerName, "message": MessageType.FIRE.rawValue]
        
        sendMessage(messageDictionary: messageToSend)
    }
    
    func sendCoordinates(dx: CGFloat, dy: CGFloat){
        
        let messageToSend: [String:Any] = ["sender": peerName, "dx": Double(dx), "dy": Double(dy), "message": MessageType.MOVE.rawValue]
        
        sendMessage(messageDictionary: messageToSend)
    }
    
    func recharge(){
        let messageToSend: [String:Any] = ["sender": peerName, "message": MessageType.RECHARGE.rawValue]
        
        sendMessage(messageDictionary: messageToSend)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        touch2 = pos
        
        if pos.x < fronteira {
        miraNode?.position = pos
        miraNode?.alpha = 1
        }
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        counter += 1
        
        touch1 = touch2
        touch2 = pos
        
        var direction = CGVector(point1: touch1, point2: touch2)
        
        print("\n 1. toque \(counter) direction: \(direction)")
        
        moveMira(dir: direction)

        //MARK: COMENTADO PARA TESTAR A POSIÇÃO
        if !inside { direction.dx = 0.0 }
        
        sendCoordinates(dx: direction.dx, dy: direction.dy)
        
        inside = true
 
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if inside {
            miraNode?.alpha = 0
            sendCoordinates(dx: 0.0, dy: 0.0)
            inside = false
        }
        
    }
    
    //MARK: touch detection starts here
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let loc: CGPoint = t.location(in: self)
            print("\nCHEGOU AQUI")
            print("\nNODE TOUCHED: \(nodes(at: loc)[0])")
            if loc.x >= fronteira {
                inside = false
                if (nodes(at: loc)[0]).name != nil && (nodes(at: loc)[0]).name  == "shootButton" {
                    self.fire()
                    print("\n IS OUTSIDE")
                }
            }
            else {
                inside = true
                self.touchDown(atPoint: loc)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!
        touched = true
        location = t.location(in: self)
        print("touchesMoved")
        checkTouchShadowVisibility(loc: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            self.touchUp(atPoint: t.location(in: self)) }
    }
    //MARK: touch detection ends here
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == UIEventSubtype.motionShake){
            print("\n \n RECHARGE!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        // Called before each frame is rendered
        
        if touched{
            touched = false
            //faci tretas
            if inside {
                self.touchMoved(toPoint: location) }
        }
            
        else {
            miraNode!.physicsBody!.velocity = CGVector.zero
        }
    }
    
    func checkTouchShadowVisibility(loc: CGPoint) {
        if loc.x < fronteira {
            inside = true
            if  miraNode?.alpha == 0 { miraNode?.alpha = 1 }
        }
    }
}
