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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.mpcManager.delegate = self
        //appDelegate.mpcManager.enableServices(enable: true)
        
        
        
        loadControllerScene()
    }
    
    func loadControllerScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
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

extension GameViewController: MPCManagerDelegate {
    
    func foundPeer() {
        print("Found Peer!")
    }
    
    
    func lostPeer() {
        print("Lost Peer!")
    }
    

    func invitationWasReceived(fromPeer: String, codeReceived: String?) {
        //var textField: UITextField?
        
        //criação de um alert view em que o usuario digita o código que aparece na Apple TV para fazer a conexão
        let alert = UIAlertController(title: "Join a match", message: "Enter the code shown on your Apple TV", preferredStyle: .alert)

        alert.addTextField(configurationHandler: textFieldHandler)
        
        let codeTyped = alert.textFields?.first?.text
        
        alert.addAction(UIAlertAction(title: "Connect", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            
            if codeReceived != nil {
                if codeTyped == codeReceived {
                    self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
                    print("Started session with \(fromPeer)")
                }
                else {
                    //TODO: implementar um erro decente para código errado
                    print("ERROR! Wrong code typed. Couldn't start session with \(fromPeer)")
                    
                    self.appDelegate.mpcManager.invitationHandler(false, nil)
                }
            }
            
        }))
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            textField.placeholder = "code"
        }
    }
    
    //quando a conexão é estabelecida, a tela muda para a tela do controle
    func connectedWithPeer(peerID: MCPeerID) {
        loadControllerScene()
    }
}
