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
    
    var swipeHandler: ((Swap) -> ())? //The type of this variable is ((Swap) -> ())?. Because of the -> you can tell this is a closure or function. This closure or function takes a Swap object as its parameter and does not return anything. The question mark indicates that swipeHandler is allowed to be nil (it is an optional).
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    //These properties record the column and row numbers of the cookie that the player first touched when she started her swipe movement.
    //why Int? instead of Int? because they need to be nil when the player is not swiping.
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    //for highlight the selected candy
    var selectedSprite = SKSpriteNode()
    
    
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
    func convertPoint (point:CGPoint) -> (success: Bool, column:Int, row:Int){
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth  &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
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
                if let candy = level.candyAt(column: column, row: row) {
                    swipeFromRow = row
                    swipeFromColumn = column
                    
                    showSelectionIndicatorForCandy(candy: candy)
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
            
            if horzDelta != 0 || vertiDelta != 0 {
                trySwap(horizental: horzDelta, vertical: vertiDelta)
                
                hideSelectedIndicator()
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
            
            if let handler = swipeHandler{
                //create a swap object
                let swap = Swap(candyA: fromCandy, candyB: toCandy)
                handler(swap)
            }
        }
        
    }
    
    //be called when the user lifts her finger from the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //If the user just taps on the screen rather than swipes, you want to fade out the highlighted sprite, too
        if(selectedSprite.parent != nil && swipeFromColumn != nil){
            hideSelectedIndicator()
        }
        
        swipeFromRow = nil
        swipeFromColumn = nil
    }
    
    //happens when iOS decides that it must interrupt the touch (for example, because of an incoming phone call).
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    //This is basic SKAction animation code: You move cookie A to the position of cookie B and vice versa.
    //() -> () is simply shorthand for a closure that returns void and takes no parameters.
    func animate(swap: Swap, completion: @escaping () -> ()) {
        
        let spriteA = swap.candyA.sprite!
        let spriteB = swap.candyB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA,completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut  //easy out
        spriteB.run(moveB)
        
    }
    
    //it slides the cookies to their new positions and then immediately flips them back.
    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.candyA.sprite!
        let spriteB = swap.candyB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.2
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
    
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut  //easy out
  
        spriteA.run(SKAction.sequence([moveA,moveB]), completion: completion)
        spriteB.run(SKAction.sequence([moveB,moveA]))
    }
    
    // show the highlight
    func showSelectionIndicatorForCandy(candy: Candy){
        if selectedSprite.parent != nil {
            selectedSprite.removeFromParent()
        }
        
        if let sprite = candy.sprite{
            
            let texture = SKTexture(imageNamed: candy.candyType.highlightedSpriteName)
            selectedSprite.size = CGSize(width: TileWidth, height: TileHeight)
            selectedSprite.run(SKAction.setTexture(texture))
            
            sprite.addChild(selectedSprite)
            selectedSprite.alpha = 1.0
        }
    }
    
    //This method removes the selection sprite by fading it out.
    func hideSelectedIndicator(){
        selectedSprite.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.removeFromParent()]))
    }
    


    func animateMatchedCandies(for chains: Set<Chain>,completion:@escaping ()->()) {
        for chain in chains{
            for candy in chain.candies{
                if let sprite = candy.sprite{
                    if sprite.action(forKey: "removing") == nil{
                        let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
                        scaleAction.timingMode = .easeOut
                        sprite.run(SKAction.sequence([scaleAction,SKAction.removeFromParent()]), withKey: "removing")
                    }
                }
            }
        }
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    
    func animateFallingCandies(columns: [[Candy]], completion:@escaping () -> ()) {
        // 1
        var longestDuration: TimeInterval = 0
        for array in columns {
            for (idx, candy) in array.enumerated() {
                let newPosition = pointFor(column: candy.column, row: candy.row)
                // 2
                let delay = 0.05 + 0.15*TimeInterval(idx)
                // 3
                let sprite = candy.sprite!   // sprite always exists at this point
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                // 4
                longestDuration = max(longestDuration, duration + delay)
                // 5
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        moveAction]))
            }
        }
        
        // 6
        run(SKAction.wait(forDuration: longestDuration),completion: completion)
    }
    
    
    func animateNewCookies(_ columns: [[Candy]], completion: @escaping () -> ()) {
        // 1
        var longestDuration: TimeInterval = 0
        
        for array in columns {
            // 2
            let startRow = array[0].row + 1
            
            for (idx, candy) in array.enumerated() {
                // 3
                let sprite = SKSpriteNode(imageNamed: candy.candyType.spriteName)
                sprite.size = CGSize(width: TileWidth, height: TileHeight)
                sprite.position = pointFor(column: candy.column, row: startRow)
                CandyLayer.addChild(sprite)
                candy.sprite = sprite
                // 4
                let delay = 0.1 + 0.2 * TimeInterval(array.count - idx - 1)
                // 5
                let duration = TimeInterval(startRow - candy.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                // 6
                let newPosition = pointFor(column: candy.column, row: candy.row)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.alpha = 0
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.05),
                            moveAction])
                        ]))
            }
        }
        // 7
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
 }


