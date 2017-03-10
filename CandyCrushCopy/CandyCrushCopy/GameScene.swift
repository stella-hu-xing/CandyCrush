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
    
    //These properties record the column and row numbers of the cookie that the player first touched when she started her swipe movement.
    //why Int? instead of Int? because they need to be nil when the player is not swiping.
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    //To keep the Sprite Kit node hierarchy neatly organized, GameScene uses several layers. The base layer is called gameLayer. This is the container for all the other layers and it’s centered on the screen
    let gameLayer = SKNode()
    
    //a child of gameLayer
    let CandyLayer = SKNode()
    let tilesLayer = SKNode()
    
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
        
        //the tiles need to be done first so the tiles appear behind the cookies (Sprite Kit nodes with the same zPosition are drawn in order of how they were added).
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        CandyLayer.position = layerPosition
        gameLayer.addChild(CandyLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    //addSprites(for:) iterates through the set of cookies and adds a corresponding SKSpriteNode instance to the cookie layer. This uses a helper method, pointFor(column:, row:), that converts a column and row number into a CGPoint that is relative to the cookiesLayer. This point represents the center of the cookie’s SKSpriteNode.
    func addSprites(for candies: Set<Candy>) {
        for candy in candies {
            let sprite = SKSpriteNode(imageNamed: candy.candyType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: candy.column, row: candy.row)
            CandyLayer.addChild(sprite)
            candy.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    //This method takes a CGPoint that is relative to the cookiesLayer and converts it into column and row numbers.
    func convertPoint(point:CGPoint) -> (success: Bool, column:Int, row:Int){
        if (point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth ) &&
            (point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight){
            return (true,Int(point.x/TileWidth),Int(point.y/TileHeight))
        }else{
            return (false,0,0)  //invalid location
        }
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    //The game will call touchesBegan() whenever the user puts her finger on the screen. Here’s what the method does, step by step:
    //1, It converts the touch location, if any, to a point relative to the cookiesLayer.
    //2.Then, it finds out if the touch is inside a square on the level grid by calling a method you’ll write in a moment. If so, then this might be the start of a swipe motion. At this point, you don’t know yet whether that square contains a cookie, but at least the player put her finger somewhere inside the 9×9 grid.
    //3,Next, the method verifies that the touch is on a cookie rather than on an empty square.
    //4.Finally, it records the column and row where the swipe started so you can compare them later to find the direction of the swipe.
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {return }
            let location = touch.location(in: CandyLayer)
            let (success,column,row) = convertPoint(point: location)
            
            if success {
                if level.candyAt(column:column,row:row) != nil{
                    swipeFromRow = row
                    swipeFromColumn = column
                }
            }
            
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard swipeFromColumn != nil else {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: CandyLayer)
        let (success,column,row) = convertPoint(point: location)
        
        if success{
            var horzDelta = 0, vertiDelta=0
            if column < swipeFromColumn! {
                horzDelta = -1
            }else if column > swipeFromColumn! {
                horzDelta = 1
            }else if row < swipeFromRow! {
                vertiDelta = -1
            }else if row > swipeFromRow!{
                vertiDelta = 1
            }
            
            if horzDelta != 0 && vertiDelta != 0 {
                trySwap(horizental: horzDelta, vertical: vertiDelta)
                
                 swipeFromColumn = nil
            }
            
           
        }
    }
    
    
    func trySwap(horizental horzDelta:Int, vertical vertiDelta:Int){ // horizental is the name of para,!!!!this part is important
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertiDelta
        
        guard toColumn >= 0 && toColumn < NumColumns else {return}
        guard toRow >= 0 && toRow < NumRows else {
            return
        }
        
        if let toCandy = level.candyAt(column: toColumn, row: toRow),
            let fromCandy = level.candyAt(column: swipeFromColumn!, row: swipeFromRow!){
            print("get a swap: from \(fromCandy) to \(toCandy)")
        }
        
    }
    
    //be called when the user lifts her finger from the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromRow = nil
        swipeFromColumn = nil
    }
    
    //happens when iOS decides that it must interrupt the touch (for example, because of an incoming phone call).
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
 }
