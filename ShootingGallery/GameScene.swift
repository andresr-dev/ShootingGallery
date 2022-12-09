//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Andres camilo Raigoza misas on 9/12/22.
//

import SpriteKit

class GameScene: SKScene {
    var firstRowTimer: Timer!
    var secondRowTimer: Timer!
    var thirdRowTimer: Timer!
    var yOffset = -10
    
    override func didMove(to view: SKView) {
        let shelf = Shelf()
        shelf.yOffset = yOffset
        shelf.configure()
        shelf.zPosition = 1
        addChild(shelf)
        
        physicsWorld.gravity = .zero
        
        createFirstRowTarget()
        firstRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createFirstRowTarget), userInfo: nil, repeats: true)
        secondRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createSecondRowTarget), userInfo: nil, repeats: true)
        thirdRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createThirdRowTarget), userInfo: nil, repeats: true)
    }
        
    @objc func createFirstRowTarget() {
        addTargetNodeFor(rowIndex: 0)
    }
    
    @objc func createSecondRowTarget() {
        addTargetNodeFor(rowIndex: 1)
    }
    
    @objc func createThirdRowTarget() {
        addTargetNodeFor(rowIndex: 2)
    }
    
    @objc func addTargetNodeFor(rowIndex: Int) {
        let number = Int.random(in: 0...4)
        let targetName = "target\(number)"
        let yRowOffset = rowIndex * 130 + (rowIndex == 0 ? 2 : 5)
        
        let target = SKSpriteNode(imageNamed: targetName)
        if number == 4 {
            target.name = "penguin"
            target.size = CGSize(width: target.size.width * 1.1, height: target.size.height * 1.1)
        } else {
            target.name = "target"
            target.size = CGSize(width: target.size.width * 0.8, height: target.size.height * 0.8)
        }
        target.position = CGPoint(x: 1200, y: 273 + yOffset + yRowOffset)
        addChild(target)
        target.physicsBody = SKPhysicsBody(rectangleOf: target.size)
        target.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        target.physicsBody?.linearDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -100 {
                node.removeFromParent()
            }
        }
    }
}
