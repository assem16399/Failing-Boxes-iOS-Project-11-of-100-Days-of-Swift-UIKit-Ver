//
//  GameScene.swift
//  Failing Boxes
//
//  Created by Aasem Hany on 07/12/2022.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    override func didMove(to view: SKView) {
        
        /// Create SpriteNode
        let background = SKSpriteNode(imageNamed: "background")
        
        /// Position it to the middle of the screen
        background.position = CGPoint(x: 512 , y: 384)
        
        background.blendMode = .replace
        
        background.zPosition = -1
        
        /// Add it to the game scene
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        
        makeGoodSlot(at: CGPoint(x: 128, y: 50))
        makeBadSlot(at: CGPoint(x: 384, y: 50))
        makeGoodSlot(at: CGPoint(x: 640, y: 50))
        makeBadSlot(at: CGPoint(x: 896, y: 50))
        
        makeBouncer(at: CGPoint(x: 0, y: 50))
        makeBouncer(at: CGPoint(x: 256, y: 50))
        makeBouncer(at: CGPoint(x: 512, y: 50))
        makeBouncer(at: CGPoint(x: 768, y: 50))
        makeBouncer(at: CGPoint(x: 1024, y: 50))

        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// Get the first touch
        guard let touch = touches.first else {return}
        /// Get the location of that first touch in the GameScene
        let locationOfTouch = touch.location(in: self)
        /// Create a red square
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.name = "ball"
    
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        
        ball.physicsBody!.restitution = 0.4

        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.categoryBitMask
        
        ball.position = locationOfTouch
        /// Add that ball to the GameScene
        addChild(ball)
    }
    
    func makeBouncer(at position:CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody!.isDynamic = false
        addChild(bouncer)

    }
    
    func makeBadSlot(at position:CGPoint) {
        let badSlot = SKSpriteNode(imageNamed: "slotBaseBad")
        badSlot.name = "bad"
        badSlot.physicsBody = SKPhysicsBody(rectangleOf: badSlot.size)
        badSlot.physicsBody!.isDynamic = false
        badSlot.position = position

        let slotBadGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        
        slotBadGlow.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotBadGlow.run(spinForever)

        addChild(badSlot)
        addChild(slotBadGlow)

    }
    
    func makeGoodSlot(at position:CGPoint) {
        let goodSlot = SKSpriteNode(imageNamed: "slotBaseGood")
        goodSlot.name = "good"
        goodSlot.physicsBody = SKPhysicsBody(rectangleOf: goodSlot.size)
        goodSlot.physicsBody!.isDynamic = false
        goodSlot.position = position

        let slotGoodGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        
        slotGoodGlow.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        
        slotGoodGlow.run(spinForever)

        addChild(goodSlot)
        addChild(slotGoodGlow)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        }else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    func collision(between ball:SKNode,object:SKNode) {
        if object.name == "good" {
            destroy(ball)
        }
        if object.name == "bad" {
            destroy(ball)
        }
    }
    
    func destroy(_ ball: SKNode){
        ball.removeFromParent()
    }
    
}
