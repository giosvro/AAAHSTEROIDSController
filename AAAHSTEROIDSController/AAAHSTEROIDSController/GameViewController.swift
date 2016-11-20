//
//  GameViewController.swift
//  AAAHSTEROIDSController
//
//  Created by Gabrielle Brandenburg dos Anjos on 04/11/16.
//  Copyright © 2016 Gabrielle Brandenburg dos Anjos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var gameScene = GameScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.enableServices(enable: true)
        
        //loadControllerScene()
    }
    
    func loadControllerScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as! GameScene
                gameScene.name = "gameScene"
                print("\n scene name: \(gameScene.name) \n")
                // Present the scene
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
//    func recharge() {
//        
//        let peerName = appDelegate.mpcManager.peerID.displayName
//        
//        let messageToSend: [String:Any] = ["sender": peerName, "message": MessageType.FIRE]
//        
//        sendMessage(messageDictionary: messageToSend)
//    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resignFirstResponder()
        super.viewWillDisappear(true)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == UIEventSubtype.motionShake){
            if gameScene.name == "gameScene"{
            print("\n \n SHAKED!!!")
                gameScene.recharge()
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

