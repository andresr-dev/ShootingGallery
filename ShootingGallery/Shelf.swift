//
//  Shelf.swift
//  ShootingGallery
//
//  Created by Andres camilo Raigoza misas on 9/12/22.
//

import SpriteKit
import UIKit

class Shelf: SKNode {
    var topWoodBoard: SKSpriteNode!
    var bottomWoodBoard: SKSpriteNode!
    var leftWoodBoard: SKSpriteNode!
    var rightWoodBoard: SKSpriteNode!
    var secondWoodRow: SKSpriteNode!
    var thirdWoodRow: SKSpriteNode!
    
    var yOffset: Int!
    
    func configure() {
        bottomWoodBoard = SKSpriteNode(imageNamed: "wood-board")
        bottomWoodBoard.size = CGSize(width: 60, height: 1026)
        bottomWoodBoard.zRotation = .pi / 2
        bottomWoodBoard.position = CGPoint(x: 512, y: 200 + yOffset)
        addChild(bottomWoodBoard)
        
        topWoodBoard = SKSpriteNode(imageNamed: "wood-board")
        topWoodBoard.size = bottomWoodBoard.size
        topWoodBoard.zRotation = .pi / 2
        topWoodBoard.position = CGPoint(x: 512, y: Int(bottomWoodBoard.position.y) + Int(bottomWoodBoard.size.width) + 390)
        addChild(topWoodBoard)
        
        leftWoodBoard = SKSpriteNode(imageNamed: "wood-board")
        leftWoodBoard.size = CGSize(width: 60, height: 391)
        leftWoodBoard.position = CGPoint(x: Int(leftWoodBoard.size.width / 2), y: Int(bottomWoodBoard.position.y) + Int(bottomWoodBoard.size.width / 2) + Int(leftWoodBoard.size.height / 2))
        addChild(leftWoodBoard)
        
        rightWoodBoard = SKSpriteNode(imageNamed: "wood-board")
        rightWoodBoard.size = leftWoodBoard.size
        rightWoodBoard.position = CGPoint(x: 1024 - Int(rightWoodBoard.size.width / 2), y: Int(leftWoodBoard.position.y))
        addChild(rightWoodBoard)
        
        secondWoodRow = SKSpriteNode(imageNamed: "wood-board")
        secondWoodRow.size = CGSize(width: 6, height: 1024 - leftWoodBoard.size.width - rightWoodBoard.size.width)
        secondWoodRow.zRotation = .pi / 2
        secondWoodRow.position = CGPoint(x: 512, y: Int(bottomWoodBoard.position.y) + Int(bottomWoodBoard.size.width / 2) + 130)
        addChild(secondWoodRow)
        
        thirdWoodRow = SKSpriteNode(imageNamed: "wood-board")
        thirdWoodRow.size = secondWoodRow.size
        thirdWoodRow.zRotation = .pi / 2
        thirdWoodRow.position = CGPoint(x: 512, y: Int(secondWoodRow.position.y) + 130)
        addChild(thirdWoodRow)
    }
}
