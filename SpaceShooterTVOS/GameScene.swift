//
//  GameScene.swift
//  SpaceShooterTVOS
//
//  Created by JH on 6/21/17.
//  Copyright © 2017 Sparrowhawk1984. All rights reserved.
//

import SpriteKit
import GameplayKit

struct physicsCategory {
    static let player: UInt32 = 1
    static let projectile: UInt32 = 2
    static let enemy: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode?
    var enemy: SKSpriteNode?
    var projectile: SKSpriteNode?
    var star: SKSpriteNode?
    
    let playerSize = CGSize(width: 50, height: 50)
    let enemySize = CGSize(width: 30, height: 30)
    let projectileSize = CGSize(width: 10, height: 10)
    var starSize: CGSize?
    
    var lblMain = SKLabelNode?
    var lblScore = SKLabelNode?
    
    let offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    let offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    let enemySpeed: Double = 2.0
    let enemySpawnRate: Double = 1.0
    
    let projectileSpeed: Double = 1.0
    let projectileSpawnRate: Double = 0.4
    
    var isAlive = true
    var score = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        physicsWorld.contactDelegate = self
        
        self.spawnPlayer()
        self.timerEnemySpawn()
        self.timerStarSpawn()
        self.timerProjectileSpawn()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAlive {
            for touch in touches {
                if isAlive {
                    let location = touch.location(in: self)
                    player?.position.y = location.y
                }
            }
        }
    }
    
    func keepPlayerOnScreen() {
        if let posY = player?.position.y {
            if posY > (self.frame.maxY - self.playerSize.height) {
                player?.position.y = self.frame.maxY - self.playerSize.height
            }
            if posY < (self.frame.minY + self.playerSize.height) {
                player?.position.y = self.frame.minY + self.playerSize.height
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        keepPlayerOnScreen()
    }
    
    func spawnPlayer() {
        player = SKSpriteNode(color: offWhiteColor, size: playerSize)
        player?.position = CGPoint(x: self.frame.minX + 100, y: self.frame.midY)
        player?.name = "playerName"
        
        player?.physicsBody = SKPhysicsBody(rectangleOf: (player?.size)!)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.allowsRotation = false
        player?.physicsBody?.categoryBitMask = physicsCategory.player
        player?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player?.physicsBody?.isDynamic = true
        
        if let player = player {
            self.addChild(player)
        }
    }
    
    func spawnEnemy() {
        let randomY = CGFloat(Int(arc4random_uniform(500))) + self.frame.minY
        enemy = SKSpriteNode(color: offWhiteColor, size: enemySize)
        enemy?.position = CGPoint(x: self.frame.maxX, y: randomY)
        enemy?.name = "enemyName"
        
        enemy?.physicsBody = SKPhysicsBody(rectangleOf: (enemy?.size)!)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy?.physicsBody?.contactTestBitMask = physicsCategory.projectile | physicsCategory.player
        enemy?.physicsBody?.isDynamic = true
        
        if let enemy = enemy {
            self.addChild(enemy)
        }
        moveEnemyForward()
    }
    
    func moveEnemyForward() {
        let moveForward = SKAction.moveTo(x: frame.minX - 100, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        enemy?.run(SKAction.sequence([moveForward, destroy]))
    }
    
    func timerEnemySpawn() {
        let wait = SKAction.wait(forDuration: enemySpawnRate)
        let spawn = SKAction.run({
            self.spawnEnemy()
        })
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func spawnStar() {
        let randomWidth = Int(arc4random_uniform(3) + 1)
        let randomHeight = Int(arc4random_uniform(3) + 1)
        let randomY = CGFloat(Int(arc4random_uniform(500))) + self.frame.minY
        
        
        starSize = CGSize(width: randomWidth, height: randomHeight)
        star = SKSpriteNode(color: offWhiteColor, size: starSize!)
        star?.position = CGPoint(x: self.frame.maxX, y: randomY)
        star?.zPosition = -1
        if let star = star {
            self.addChild(star)
        }
        moveStarForward()
    }
    
    func moveStarForward() {
        let randomSpeed = Int(arc4random_uniform(3) + 1)
        let moveForward = SKAction.moveTo(x: frame.minX - 100, duration: Double(randomSpeed))
        let destroy = SKAction.removeFromParent()
        star?.run(SKAction.sequence([moveForward, destroy]))
    }
    
    func timerStarSpawn() {
        let wait = SKAction.wait(forDuration: 0.1)
        let spawn = SKAction.run({
            self.spawnStar()
        })
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func spawnProjectile() {
        projectile = SKSpriteNode(color: offWhiteColor, size: projectileSize)
        if let player = player {
            projectile?.position.y = player.position.y
            projectile?.position.x = player.position.x + 50
        }
        projectile?.name = "projectileName"
        
        projectile?.physicsBody = SKPhysicsBody(rectangleOf: (projectile?.size)!)
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.physicsBody?.allowsRotation = false
        projectile?.physicsBody?.categoryBitMask = physicsCategory.projectile
        projectile?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        projectile?.physicsBody?.isDynamic = true
        
        if let projectile = projectile {
            self.addChild(projectile)
        }
        moveProjectileForward()
    }
    
    func moveProjectileForward() {
        let moveForward = SKAction.moveTo(x: 1200, duration: projectileSpeed)
        let destroy = SKAction.removeFromParent()
        projectile?.run(SKAction.sequence([moveForward, destroy]))
    }
    
    func timerProjectileSpawn() {
        let wait = SKAction.wait(forDuration: projectileSpawnRate)
        let spawn = SKAction.run({
            self.spawnProjectile()
        })
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == physicsCategory.player && secondBody.categoryBitMask == physicsCategory.enemy)
        || (firstBody.categoryBitMask == physicsCategory.enemy && secondBody.categoryBitMask == physicsCategory.player) {
            playerEnemyCollision(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
        
        if (firstBody.categoryBitMask == physicsCategory.enemy && secondBody.categoryBitMask == physicsCategory.projectile)
            || (firstBody.categoryBitMask == physicsCategory.projectile && secondBody.categoryBitMask == physicsCategory.enemy) {
            projectileEnemyCollision(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
    }
    
    func playerEnemyCollision(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "enemyName" {
            contactA.removeFromParent()
        } else {
            contactB.removeFromParent()
        }
        isAlive = false
        gameOverLogic()
    }
    
    func projectileEnemyCollision(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        score += 1
        updateScore()
        contactA.removeFromParent()
        contactB.removeFromParent()
    }
    
    func updateScore() {
        
    }
    
    func gameOverLogic() {
        
    }
    
    func movePlayerOffscreen() {
        if !isAlive {
            player?.position.y = self.frame.minY - 100
        }
    }
}
