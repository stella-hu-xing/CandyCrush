//
//  GameViewController.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var level:Level!
    
    func beginGame(){
        shuffle()
    }
    
    
    //call Level’s shuffle() method, which returns the Set containing new Candy objects
    //Remember that these cookie objects are just model data; they don’t have any sprites yet.
    func shuffle(){
        let newCandies = level.shuffle()
        scene.addSprites(for: newCandies)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // creating the actual Level instance
        level = Level(filename: "Level_1")
        
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        //cannot put over, the scene havn't a instance 
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        // Present the scene.
        skView.presentScene(scene)
        
        //remember to begin game
        beginGame()
    }
    
    func handleSwipe(_ swap: Swap) {
        // While cookies are being matched and new cookies fall down to fill up
        // the holes, we don't want the player to tap on anything.
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap:swap)
            scene.animate(swap: swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        scene.animateMatchedCandies(for: chains) {
            let columns = self.level.fillHoles()
            self.scene.animateFallingCandies(columns: columns) {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns) {
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.detectPossibleSwaps()
        view.isUserInteractionEnabled = true
    }
    
    
}
