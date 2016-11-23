//
//  MPCManagerDelegate.swift
//  AAAHSTEROIDSController
//
//  Created by Gabrielle Brandenburg dos Anjos on 20/11/16.
//  Copyright © 2016 Gabrielle Brandenburg dos Anjos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

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
        
        
        
        alert.addAction(UIAlertAction(title: "Connect", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            
            let codeTyped = alert.textFields?.first?.text
            print("\n \n CODE RECEIVED: \(codeReceived)")
            print("\n \n CODE TYPED: \(codeTyped)")
            
            if codeReceived != nil {
                if codeTyped == codeReceived {
                    self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
                    print("Will start session with \(fromPeer)")
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
        DispatchQueue.main.async {
            self.verificationView.isHidden = true
        }
        
        loadControllerScene()
    }
}
