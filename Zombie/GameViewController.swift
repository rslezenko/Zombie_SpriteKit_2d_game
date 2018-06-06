//
//  GameViewController.swift
//  Zombie
//
//  Created by Roman Slezenko on 14.02.18.
//  Copyright © 2018 Roman Slezenko. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scene = MainMenuScene(size: CGSize(width: 2048, height: 1536)) //ipad/iphone screen
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
