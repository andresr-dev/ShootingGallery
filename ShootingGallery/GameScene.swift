//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Andres camilo Raigoza misas on 9/12/22.
//

import SpriteKit

class GameScene: SKScene {
    var shelf: Shelf!
    
    var firstRowTimer: Timer!
    var secondRowTimer: Timer!
    var thirdRowTimer: Timer!
    
    var yOffset = -15
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var currentAmmo: SKSpriteNode!
    var currentAmmoLabel: SKLabelNode!
    
    var ammoLeft = 6 {
        didSet {
            currentAmmoLabel.text = String(ammoLeft)
            currentAmmo.removeFromParent()
            switch ammoLeft {
            case 5...:
                currentAmmo = SKSpriteNode(imageNamed: "shots0")
            case 3...:
                currentAmmo = SKSpriteNode(imageNamed: "shots1")
            case 1...:
                currentAmmo = SKSpriteNode(imageNamed: "shots2")
            default:
                currentAmmo = SKSpriteNode(imageNamed: "shots3")
            }
            currentAmmo.position = CGPoint(x: 1004 - (currentAmmo.size.width / 2), y: 737 - (currentAmmo.size.height / 2))
            addChild(currentAmmo)
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var targetLabels = [SKLabelNode]()
    var shotsCount = Array(repeating: 0, count: 5)
    
    var timeCounter = 0 {
        didSet {
            timerLabel.text = timeCounter.asTimeFormatted()
        }
    }
    
    var gameTimer: Timer!
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        shelf = Shelf()
        shelf.yOffset = yOffset
        shelf.configure()
        shelf.zPosition = 1
        addChild(shelf)
        
        physicsWorld.gravity = .zero
        
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 20, y: 700)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        timerLabel.fontSize = 50
        timerLabel.text = "59:99"
        timerLabel.position = CGPoint(x: 512 - (timerLabel.frame.size.width / 2), y: 697)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        
        currentAmmo = SKSpriteNode(imageNamed: "shots0")
        currentAmmo.position = CGPoint(x: 1004 - (currentAmmo.size.width / 2), y: 737 - (currentAmmo.size.height / 2))
        addChild(currentAmmo)
        
        currentAmmoLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        currentAmmoLabel.fontSize = 50
        currentAmmoLabel.text = "6"
        currentAmmoLabel.position = CGPoint(x: 1004 - currentAmmo.size.width - 28, y: 696)
        addChild(currentAmmoLabel)
        
        let reload = SKSpriteNode(imageNamed: "shots0")
        reload.position = CGPoint(x: ((1024 * 6) / 7) + 45, y: 90)
        reload.name = "reload"
        addChild(reload)
        
        let reloadLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        reloadLabel.fontSize = 18
        reloadLabel.position = CGPoint(x: reload.position.x + 2, y: reload.position.y - reload.size.height)
        reloadLabel.text = "RELOAD!"
        reloadLabel.name = "reload"
        addChild(reloadLabel)
        
        for i in 0...4 {
            let target = SKSpriteNode(imageNamed: "target\(i)")
            target.position = CGPoint(x: ((1000 * (i + 1)) / 6) - 35, y: 80)
            target.size = CGSize(width: target.size.width * (i == 4 ? 0.7 : 0.5), height: target.size.height * (i == 4 ? 0.7 : 0.5))
            addChild(target)
            
            let label = SKLabelNode(fontNamed: "Avenir-Medium")
            label.fontSize = 45
            label.position = CGPoint(x: target.position.x - target.size.width + 5, y: target.position.y - 15)
            label.text = "0"
            label.name = "targetLabel\(i)"
            targetLabels.append(label)
            addChild(label)
        }
        
        startGame()
    }
    
    func startGame() {
        for node in children {
            if let name = node.name {
                if name.hasPrefix("target") && !name.contains("Label") {
                    // There's still some targets alive
                    return
                }
                if name.hasPrefix("gameOver") {
                    node.removeFromParent()
                }
            }
        }
        
        isGameOver = false
        ammoLeft = 6
        score = 0
        shotsCount = Array(repeating: 0, count: 5)
        
        for targetLabel in targetLabels {
            targetLabel.text = "0"
        }
        
        targetLabels[4].fontColor = .white
        timeCounter = 4500
        
        let interval1 = Double.random(in: 0.8...2)
        firstRowTimer = Timer.scheduledTimer(timeInterval: interval1, target: self, selector: #selector(createFirstRowTarget), userInfo: nil, repeats: true)
        
        let interval2 = Double.random(in: 0.8...2)
        secondRowTimer = Timer.scheduledTimer(timeInterval: interval2, target: self, selector: #selector(createSecondRowTarget), userInfo: nil, repeats: true)
        
        let interval3 = Double.random(in: 0.8...2)
        thirdRowTimer = Timer.scheduledTimer(timeInterval: interval3, target: self, selector: #selector(createThirdRowTarget), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
        
    @objc func createFirstRowTarget() {
        let rowIndex = 0
        createTargetNode(for: rowIndex)
    }
    
    @objc func createSecondRowTarget() {
        let rowIndex = 1
        createTargetNode(for: rowIndex)
    }
    
    @objc func createThirdRowTarget() {
        let rowIndex = 2
        createTargetNode(for: rowIndex)
    }
    
    @objc func countdown() {
        if timeCounter > 0 {
            timeCounter -= 1
            return
        }
        let gameOverSound = SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false)
        run(gameOverSound)
        isGameOver = true
        
        gameTimer.invalidate()
        firstRowTimer.invalidate()
        secondRowTimer.invalidate()
        thirdRowTimer.invalidate()
        
        let gameOverMessage = SKSpriteNode(imageNamed: "game-over")
        gameOverMessage.position = CGPoint(x: 512, y: 576 + 25)
        gameOverMessage.zPosition = 2
        gameOverMessage.name = "gameOverMessage"
        addChild(gameOverMessage)
        
        let finalScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        finalScore.position = CGPoint(x: 512, y: 384 + 8)
        finalScore.zPosition = 2
        finalScore.fontSize = 55
        finalScore.text = "Score: \(score)"
        finalScore.name = "gameOverMessage"
        addChild(finalScore)
        
        let button = SKShapeNode(rectOf: CGSize(width: 260, height: 70), cornerRadius: 35)
        button.position = CGPoint(x: 512, y: 192 + 14)
        button.fillColor = .blue
        button.zPosition = 2
        button.name = "gameOverButton"
        addChild(button)
        
        let buttonLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        buttonLabel.text = "Play Again"
        buttonLabel.position = CGPoint(x: 512, y: 182 + 14)
        buttonLabel.zPosition = 2
        buttonLabel.name = "gameOverLabel"
        addChild(buttonLabel)
    }
    
    @objc func createTargetNode(for rowIndex: Int) {
        var number = Int.random(in: 0...5)
        if number > 3 {
            number = 4
        }
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
        
        let velocity: Double
        if number == 4 {
            velocity = Double.random(in: 700...1300)
        } else {
            velocity = Double.random(in: 800...1700)
        }
        target.physicsBody?.velocity = CGVector(dx: rowIndex == 1 ? -velocity : velocity, dy: 0)
        target.physicsBody?.linearDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        guard !isGameOver else {
            for node in nodes {
                if node.name == "gameOverButton" {
                    startGame()
                }
            }
            return
        }
        
        if (shelf.bottomWoodBoard.position.y - 30...shelf.topWoodBoard.position.y + 30).contains(location.y) {
            // Shooting zone
            guard ammoLeft > 0 else {
                let emptyGunSound = SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false)
                run(emptyGunSound)
                return
            }
            
            shootGun(at: location)
            
            for node in nodes {
                if let name = node.name, name.contains("target") {
                    if (61..<1024 - 60).contains(location.x) {
                        hitTarget(node: node)
                    }
                }
            }
        } else {
            for node in nodes {
                if node.name == "reload" && ammoLeft == 0 {
                    let reloadSound = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
                    run(reloadSound)
                    ammoLeft = 6
                }
            }
        }
    }
    
    func shootGun(at location: CGPoint) {
        let shot = SKEmitterNode(fileNamed: "Shot")!
        shot.position = location
        shot.zPosition = 1
        addChild(shot)
        
        Task {
            try await Task.sleep(for: .seconds(0.4))
            shot.removeFromParent()
        }
        let shotSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
        run(shotSound)
        ammoLeft -= 1
    }
    
    func hitTarget(node: SKNode) {
        guard let index = Int(node.name!.suffix(1)) else { return }
        
        shotsCount[index] += 1
        let label = targetLabels[index]
        label.text = "\(shotsCount[index])"
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.05)
        node.run(fadeOut)
        
        if index == 4 {
            score -= 5
            score = score < 0 ? 0 : score
            
            label.fontColor = .red
        } else {
            score += 2
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -100 || node.position.x > 1100 {
                node.removeFromParent()
            }
        }
    }
}
