//
//  GameScene.swift
//  SpaceShooterTVOS
//
//  Created by JH on 6/21/17.
//  Copyright © 2017 Sparrowhawk1984. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    var enemy: SKSpriteNode?
    var projectile: SKSpriteNode?
    var star: SKSpriteNode?
    
    var playerSize = CGSize(width: 50, height: 50)
    var enemySize = CGSize(width: 30, height: 30)
    var projectileSize = CGSize(width: 10, height: 10)
    var starSize = CGSize()
    
    var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    var enemySpeed: Double = 2.0
    var enemySpawnRate: Double = 1.0
    
    var projectileSpeed: Double = 1.0
    var projectileSpawnRate: Double = 0.4
    
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        self.spawnPlayer()
        self.timerEnemySpawn()
        self.timerStarSpawn()
        self.timerProjectileSpawn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player?.position.y = location.y
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
        if let player = player {
            self.addChild(player)
        }
    }
    
    func spawnEnemy() {
        var randomY = CGFloat(Int(arc4random_uniform(500))) + self.frame.minY
        enemy = SKSpriteNode(color: offWhiteColor, size: enemySize)
        enemy?.position = CGPoint(x: self.frame.maxX, y: randomY)
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
        star = SKSpriteNode(color: offWhiteColor, size: starSize)
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
        projectile?.position = (player?.position)!
        
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
}
