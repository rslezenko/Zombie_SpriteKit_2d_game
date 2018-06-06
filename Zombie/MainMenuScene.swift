//
//  MainMenuScene.swift
//  Zombie
//
//  Created by Roman Slezenko on 14.02.18.
//  Copyright © 2018 Roman Slezenko. All rights reserved.
//

import Foundation
import SpriteKit

var speed_gl:TimeInterval = 2.0

class MainMenuScene: SKScene{
    let tap = SKLabelNode(fontNamed: "CastileInlineGrunge")
    let tap2 = SKLabelNode(fontNamed: "CastileInlineGrunge")
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "intro2")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        
        tap.alpha = 0
        tap.name = "tap"
        tap.fontColor = .black
        tap.fontSize = 200
        tap.zPosition = 150
        tap.position = CGPoint(x: size.width/2 - CGFloat(200) , y: size.height/2 - CGFloat(350))
        tap.text = "Easy"
    
        tap2.alpha = 0
        tap2.name = "tap2"
        tap2.fontColor = .black
        tap2.fontSize = 200
        tap2.zPosition = 150
        tap2.position = CGPoint(x: size.width/2 + CGFloat(200), y: size.height/2 - CGFloat(350))
        tap2.text = "Hard"
        
        
        UIView.animate(withDuration: 1.0, animations: {
          self.tap.alpha = 1
          self.tap2.alpha = 1
        })
      
        self.addChild(tap)
        self.addChild(tap2)
        
        self.addChild(background)
    }

  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches {
            let location = touch.location(in: self)
            if let theName = self.atPoint(location).name {
                if theName == "tap" {
                    speed_gl = 2.0
                    sceneTaped()
                }else if theName == "tap2" {
                    speed_gl = 0.5
                    sceneTaped()
               }
            }
            
        }
        
//        if let touch = event?.allTouches?.first {
//            let loc:CGPoint = touch.location(in: touch.view)
//            if  self.tap.position == loc {
//                speed_gl = 0.5
//                sceneTaped()
//            }else{
//                 sceneTaped()
//            }
//        }
       
    }
    
    func sceneTaped(){
        let gamescene = GameScene(size: size)
        gamescene.scaleMode = scaleMode
        let reaveal = SKTransition.doorsOpenVertical(withDuration: 1.5)
        view?.presentScene(gamescene, transition: reaveal)
    
    }
}
