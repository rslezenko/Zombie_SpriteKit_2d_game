//
//  GameScene.swift
//  Zombie
//
//  Created by Roman Slezenko on 14.02.18.
//  Copyright © 2018 Roman Slezenko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime:TimeInterval = 0
    var dt:TimeInterval = 0
    let zombiePerSecond:CGFloat = 600.0 //480
    var velocity = CGPoint.zero
    let zombieAnimate:SKAction
    var lastTouchLocation: CGPoint?
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * CGFloat.pi
    
    let catcolisionsound :SKAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let enemycolisionsound :SKAction = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    
    var invincible = false
    let catMovePointsPerSec:CGFloat = 480.0
    
    var lives = 5
    var cats = 0
    var gameOver = false
   
    
    let cameraNode = SKCameraNode()
    let cameraMoveperSecond :CGFloat = 150.0
    
    let livesLabel = SKLabelNode(fontNamed: "CastileInlineGrunge")
    let catsLabel = SKLabelNode(fontNamed: "CastileInlineGrunge")
    
    var cameraRect: CGRect{
        let x = cameraNode.position.x - size.width/2 + (size.width - playableRect.size.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableRect.size.height)/2
        
        return CGRect(x: x, y: y, width: playableRect.size.width, height: playableRect.size.height)
    }
    
    
    let playableRect :CGRect
    override init(size: CGSize) {
        let maxAxpectRatio:CGFloat = 16.0/9.0 //ipad 16/9 iphone
        let playableHeight = size.width / maxAxpectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight) //iphone
        //playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height) //ipad
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        zombieAnimate = SKAction.animate(with: textures, timePerFrame: 0.1)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
       // backgroundColor = .blue
      playbackgroundmusic(filename: "backgroundMusic.mp3")
        
        for i in 0...1{
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            background.zPosition = -1
            background.name = "background"
            addChild(background)
            
        }
   
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 100
       
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
            self?.spawnEnemy()
            },SKAction.wait(forDuration: speed_gl)])))//2.0
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
            self?.spawnCat()
            },SKAction.wait(forDuration: 1.0)])))
        
        addChild(zombie)
         //debugDraw()
        
        addChild(cameraNode)
        
        camera = cameraNode
        cameraNode.position =  CGPoint(x: size.width/2, y: size.height/2)
        
       
        livesLabel.fontColor = .black
        livesLabel.fontSize = 150
        livesLabel.zPosition = 150
        
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.position = CGPoint(x: playableRect.size.width/2 - CGFloat(450), y: playableRect.size.height/2 - CGFloat(150))
        cameraNode.addChild(livesLabel)
        
        catsLabel.fontColor = .black
        catsLabel.fontSize = 150
        catsLabel.zPosition = 150
        catsLabel.horizontalAlignmentMode = .left
        catsLabel.verticalAlignmentMode = .bottom
        catsLabel.position = CGPoint(x: playableRect.size.width/2 - CGFloat(450), y: playableRect.size.height/2 - CGFloat(300))
        cameraNode.addChild(catsLabel)
        
    }
    
    override func didEvaluateActions() {
        checkcolision()
    }
    
    func startzombie(){
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimate), withKey: "animation")
        }
    }
    
    func stopzombie(){
        
        zombie.removeAction(forKey: "animation")
    }
    
//    func moveZombieToward(location: CGPoint){
//         startzombie()
//        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
//        let lenght = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
//        let direction = CGPoint(x: offset.x/CGFloat(lenght), y: offset.y/CGFloat(lenght))
//        velocity = CGPoint(x: direction.x * zombiePerSecond, y: direction.y * zombiePerSecond)
//    }
    
    func moveZombieToward(location: CGPoint) {
        startzombie()
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * zombiePerSecond
    }
    
    
    func sceneToched(touchLocation: CGPoint){
         lastTouchLocation = touchLocation
        moveZombieToward(location: touchLocation)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        //print("\(amountToMove) lenght")
       // sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        sprite.position += amountToMove
    }
 
    
    func bounceCheckZombie(){
        let bottomLeft = CGPoint(x: cameraRect.minX, y: playableRect.minY)
        let bottomRight = CGPoint(x: cameraRect.maxX, y: playableRect.maxY)
        
        if zombie.position.x <= bottomLeft.x{
            zombie.position.x = bottomLeft.x
            velocity.x = abs(velocity.x)
        }
        if zombie.position.x >= bottomRight.x{
            zombie.position.x = bottomRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y{
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= bottomRight.y{
            zombie.position.y = bottomRight.y
            velocity.y = -velocity.y
        }
        
    }
    
    func debugDraw(){
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(cameraRect)
        shape.path = path
        shape.strokeColor = .red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
//    func rotate(sprite: SKSpriteNode,direction: CGPoint){
//        sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
//    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }

    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime>0{
            dt = currentTime - lastUpdateTime
        }else{
            dt = 0
        }
        lastUpdateTime = currentTime
        //print("\(dt*1000) miliseconds")
        
  
        move(sprite: zombie, velocity: velocity)
        rotate(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombiePerSecond)
     
        
//        move(sprite: zombie, velocity: velocity)
//        rotate(sprite: zombie, direction: velocity)
        moveTrain()
        moveCamera()
        
        bounceCheckZombie()
       
        if lives <= 0 && !gameOver {
            gameOver = true
            print("You lose!!!")
            backgroundMusic.stop()
            
            let gameoverscene = GameOverScene(size: size, won: false)
            gameoverscene.scaleMode = scaleMode
            let reaveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameoverscene, transition: reaveal)
            
        }
        
         livesLabel.text = "Lives: \(lives)"
         catsLabel.text = "Cats: \(cats)/15"
       // cameraNode.position = zombie.position
    }
    
    func backgroundNode() ->SKSpriteNode{
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        
        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        
        let background2 = SKSpriteNode(imageNamed: "background2")
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)
        backgroundNode.addChild(background2)
        
        backgroundNode.size = CGSize(width: background1.size.width + background2.size.width, height: background1.size.height)
        return backgroundNode
    }
    
    func moveCamera(){
        let backgroundVelocity = CGPoint(x: cameraMoveperSecond, y: 0)
        let amounthToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amounthToMove
        
        enumerateChildNodes(withName: "background") { (node, _) in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width < self.cameraRect.origin.x {
                background.position = CGPoint(x: background.position.x + background.size.width * 2, y: background.position.y)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
            }
        let touchlocation = touch.location(in: self)
        sceneToched(touchLocation: touchlocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchlocation = touch.location(in: self)
        sceneToched(touchLocation: touchlocation)
    }
    
    func zombieHit(cat: SKSpriteNode){
       // cat.removeFromParent()
        
        cat.name = "train"
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0
        
        let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
        cat.run(turnGreen)
        
        run(catcolisionsound)
    }
    func zombieHit(enemy: SKSpriteNode){
       // enemy.removeFromParent()
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() { [weak self] in
            self?.zombie.isHidden = false
            self?.invincible = false
        }
        zombie.run(SKAction.sequence([blinkAction, setHidden]))
        run(enemycolisionsound)
        loseCats()
        lives -= 1
    }
    func checkcolision(){
        var hitCats: [SKSpriteNode] = []
        enumerateChildNodes(withName: "cat") { (node, _) in
            let cat = node as! SKSpriteNode
            if cat.frame.intersects(self.zombie.frame.insetBy(dx: 50, dy: 50)){
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieHit(cat: cat)
        }
        
        if invincible {
            return
        }
        
       var hitEnemy: [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy") { (node, _) in
            let enemy = node as! SKSpriteNode
            if enemy.frame.insetBy(dx:100, dy: 100).intersects(self.zombie.frame){ //50 50
                hitEnemy.append(enemy)
            }
        }
        for enemy in hitEnemy {
            zombieHit(enemy: enemy)
        }
    }
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(imageNamed: "Lawnmower1")
        enemy.name = "enemy"
        enemy.position = CGPoint(x: cameraRect.maxX + enemy.size.width/2, y: CGFloat.random(min: cameraRect.minY + enemy.size.height / 2, max: cameraRect.maxY - enemy.size.height / 2))
        addChild(enemy)
        
        let leftwiggle = SKAction.rotate(byAngle: CGFloat.pi/20.0, duration: 0.1)
        let rightwigle = leftwiggle.reversed()
        let leftwiggle2 = SKAction.rotate(byAngle: CGFloat.pi / -20.0, duration: 0.1)
        let rightwigle2 = leftwiggle2.reversed()
        let fullwigle = SKAction.sequence([leftwiggle,rightwigle,leftwiggle2,rightwigle2])
        let restart = SKAction.repeat(fullwigle, count: 10)
        
        let actionMove = SKAction.moveTo(x:  cameraRect.minX - 100 , duration: 2.0)
        let group = SKAction.group([actionMove,restart])
        
        let actionRemowe = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([group,actionRemowe]))
    }
    
    func spawnCat(){
         let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(x: CGFloat.random(min: cameraRect.minX ,max: cameraRect.maxX), y: CGFloat.random(min: cameraRect.minY,max: cameraRect.maxY))
        
        cat.setScale(0)
        addChild(cat)
        
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        cat.zRotation = -CGFloat.pi / 16.0
        
        let leftwiggle = SKAction.rotate(byAngle: CGFloat.pi/8.0, duration: 0.5)
        let rightwigle = leftwiggle.reversed()
        let fullwigle = SKAction.sequence([leftwiggle,rightwigle])
      
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullSkale = SKAction.sequence([scaleUp,scaleDown,scaleUp,scaleDown])
        let group = SKAction.group([fullSkale,fullwigle])
        let groupwait = SKAction.repeat(group, count: 10)
        
        let disapper = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear,groupwait,disapper,removeFromParent]
        cat.run(SKAction.sequence(actions))
        
    }
    
    func moveTrain() {
         var traincount = 0
        var targetPosition = zombie.position
        
        enumerateChildNodes(withName: "train") { node, stop in
               traincount += 1
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMovePerSec = direction * self.catMovePointsPerSec
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.run(moveAction)
            }
            targetPosition = node.position
        }
      cats = traincount
        if traincount >= 15  && !gameOver{
           gameOver = true
            print("You win!")
            backgroundMusic.stop()
            let gameoverscene = GameOverScene(size: size, won: true)
            gameoverscene.scaleMode = scaleMode
            let reaveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameoverscene, transition: reaveal)
    }
}
    
    func loseCats(){
        var loseCount = 0
        enumerateChildNodes(withName: "train") { (node, stop) in
            var randomspot = node.position
            randomspot.x += CGFloat.random(min: -100,max: 100)
            randomspot.y += CGFloat.random(min: -100,max: 100)
            node.name = ""
            node.run(SKAction.sequence([SKAction.group([
                SKAction.rotate(byAngle: CGFloat.pi*4, duration: 1.0),
                SKAction.move(to: randomspot, duration: 1.0),
                SKAction.scale(to: 0, duration: 1.0)]),
                       SKAction.removeFromParent()
                ]))
            
            loseCount += 1
            if loseCount >= 2{
                stop[0] = true
            }
        }
        
    }
        
        
}
