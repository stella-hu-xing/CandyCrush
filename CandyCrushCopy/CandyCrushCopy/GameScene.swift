//
//  GameScene.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //The scene has a public property to hold a reference to the current level
    //(adding! could avoid the initialization)
    var level: Level!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    //To keep the Sprite Kit node hierarchy neatly organized, GameScene uses several layers. The base layer is called gameLayer. This is the container for all the other layers and it’s centered on the screen
    let gameLayer = SKNode()
    
    //a child of gameLayer
    let CandyLyer = SKNode()
    
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder) is not used")
    }
    
    override init(size:CGSize){
        super.init(size:size)
    
        anchorPoint = CGPoint(x:0.5, y:0.5)
    
        let background = SKSpriteNode(imageNamed: "Background")
        
        background.size = size
        addChild(background)
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: -TileWidth*CGFloat(NumColumns)/2,
                                    y: -TileHeight*CGFloat(NumRows)/2)
        
        CandyLyer.position = layerPosition
        gameLayer.addChild(CandyLyer)
    }
    
    //addSprites(for:) iterates through the set of cookies and adds a corresponding SKSpriteNode instance to the cookie layer. This uses a helper method, pointFor(column:, row:), that converts a column and row number into a CGPoint that is relative to the cookiesLayer. This point represents the center of the cookie’s SKSpriteNode.
    func addSprites(for candies: Set<Candy>) {
        for candy in candies {
            let sprite = SKSpriteNode(imageNamed: candy.candyType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: candy.column, row: candy.row)
            CandyLyer.addChild(sprite)
            candy.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
//    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//    
//    override func didMove(to view: SKView) {
//        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//    
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
