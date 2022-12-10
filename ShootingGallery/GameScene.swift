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
    
    var yOffset = -15
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var ammo: SKSpriteNode!
    var ammoLabel: SKLabelNode!
    
    var targetLabels = [SKLabelNode]()
    
    override func didMove(to view: SKView) {
        let shelf = Shelf()
        shelf.yOffset = yOffset
        shelf.configure()
        shelf.zPosition = 1
        addChild(shelf)
        
        physicsWorld.gravity = .zero
        
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 20, y: 702)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        timerLabel.fontSize = 50
        timerLabel.text = "59:99"
        timerLabel.position = CGPoint(x: 512, y: 697)
        addChild(timerLabel)
        
        ammo = SKSpriteNode(imageNamed: "shots0")
        ammo.position = CGPoint(x: 1004 - (ammo.size.width / 2), y: 737 - (ammo.size.height / 2))
        addChild(ammo)
        
        ammoLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        ammoLabel.fontSize = 50
        ammoLabel.text = "6"
        ammoLabel.position = CGPoint(x: 1004 - ammo.size.width - 28, y: 696)
        addChild(ammoLabel)
        
        for i in 0...4 {
            let target = SKSpriteNode(imageNamed: "target\(i)")
            target.position = CGPoint(x: (1050 * (i + 1)) / 6, y: 80)
            target.size = CGSize(width: target.size.width * (i == 4 ? 0.7 : 0.5), height: target.size.height * (i == 4 ? 0.7 : 0.5))
            addChild(target)
            
            let label = SKLabelNode(fontNamed: "Avenir-Medium")
            label.fontSize = 50
            label.position = CGPoint(x: target.position.x - target.size.width, y: target.position.y - 15)
            label.text = "0"
            label.name = "targetLabel\(i)"
            targetLabels.append(label)
            addChild(label)
        }
        
        firstRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createFirstRowTarget), userInfo: nil, repeats: true)
        secondRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createSecondRowTarget), userInfo: nil, repeats: true)
        thirdRowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createThirdRowTarget), userInfo: nil, repeats: true)
    }
        
    @objc func createFirstRowTarget() {
        let rowIndex = 0
        addTargetNode(for: rowIndex)
    }
    
    @objc func createSecondRowTarget() {
        let rowIndex = 1
        addTargetNode(for: rowIndex)
    }
    
    @objc func createThirdRowTarget() {
        let rowIndex = 2
        addTargetNode(for: rowIndex)
    }
    
    @objc func addTargetNode(for rowIndex: Int) {
        let number = Int.random(in: 0...4)
        let targetName = "target\(number)"
        let yRowOffset = rowIndex * 130 + (rowIndex == 0 ? 2 : 5)
        
        let target = SKSpriteNode(imageNamed: targetName)
        let width = target.size.width * (number == 4 ? 1.1 : 0.8)
        let height = target.size.height * (number == 4 ? 1.1 : 0.8)
        target.size = CGSize(width: width, height: height)
        target.name = "target\(number)"
        target.position = CGPoint(x: rowIndex == 1 ? 1100 : -100, y: 273 + yOffset + yRowOffset)
        addChild(target)
        
        target.physicsBody = SKPhysicsBody(rectangleOf: target.size)
        target.physicsBody?.velocity = CGVector(dx: rowIndex == 1 ? -500 : 500, dy: 0)
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
