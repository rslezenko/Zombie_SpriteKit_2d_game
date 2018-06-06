//
//  GameOverScene.swift
//  Zombie
//
//  Created by Roman Slezenko on 14.02.18.
//  Copyright © 2018 Roman Slezenko. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    let won: Bool
    
    init(size: CGSize,won: Bool) {
        self.won = won
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        if won{
            background = SKSpriteNode(imageNamed: "YouWin")
            run(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
        }else{
            background = SKSpriteNode(imageNamed: "YouLose")
            run(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
        }
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reaveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reaveal)
        }
        self.run(SKAction.sequence([wait,block]))
        
    }
    
}
