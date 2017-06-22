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
    
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        self.spawnPlayer()
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
}
