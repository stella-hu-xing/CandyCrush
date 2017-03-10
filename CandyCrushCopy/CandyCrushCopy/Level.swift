//
//  Level.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import Foundation

//declare 2 constant in global
let NumColumns = 9
let NumRows = 9

//the different level
class Level{
    
    fileprivate var candies = Array2D<Candy>(columns:NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    //Set  instead of an Array because the order of the elements in this collection isn’t important. This Set will contain Swap objects. If the player tries to swap two cookies that are not in the set, then the game won’t accept the swap as a valid move.
    private var possibleSwaps = Set<Swap>()
    
    func candyAt(column:Int,row:Int)->Candy?{
        
        //The idea behind assert is you give it a condition, and if the condition fails the app will crash with a log message.
        
        assert(column >= 0 && column < NumColumns)
        assert(row>=0 && row < NumRows)
        return candies[column,row]
        
    }
    
    func tileAt(column:Int, row:Int) ->Tile?{
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    //The shuffle method fills up the level with random cookies.
    func shuffle() -> Set<Candy>{
        var set: Set<Candy>
        repeat {
            set = createInitialCandies()
            detectPossibleSwaps()
            print("possible swaps  \(possibleSwaps)")
        }while possibleSwaps.count == 0
        return set
    }
    
    func detectPossibleSwaps(){
        var set = Set<Swap>()
        
        for r in 0..<NumRows {
            for c in 0..<NumColumns {
                if let candy = candies[c,r]{
                    
                    if c < NumColumns - 1 {
                        if let other = candies[c+1, r]{
                            //swap them
                            candies[c,r] = other
                            candies[c+1,r] = candy
                            
                            if hasChainAt(column: c+1, row: r) || hasChainAt(column: c, row: r) {
                                set.insert(Swap(candyA: candy, candyB: other))
                            }
                            
                            //Swap them back
                            candies[c,r] = candy
                            candies[c+1, r] = other
                            
                        }
                    }
                    
                    if r < NumRows - 1 {
                        if let other = candies[c,r+1]{
                            candies[c,r]=other
                            candies[c,r+1] = candy
                            
                            //is either candy now part of a chain?
                            if hasChainAt(column: c, row: r+1) || hasChainAt(column: c, row: r) {
                                set.insert(Swap(candyA: candy, candyB: other))
                            }
                            
                            candies[c,r] = candy
                            candies[c,r+1] = other
                        }
                    }
                }
            }
        }
        possibleSwaps = set
    }
    
    //detectPossibleSwaps() will use a helper method to see if a cookie is part of a chain.
    private func hasChainAt(column: Int, row: Int) -> Bool{
        let ctype = candies[column, row]?.candyType
        
        var horzLength = 1
        var verLength = 1
        
        //for left
        var i = column - 1
        while i >= 0 && candies[i,row]?.candyType == ctype  {
            i -= 1
            horzLength += 1
        }
        
        //for right
        i = column + 1
        while i < NumColumns && candies[i,row]?.candyType == ctype{
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        
        //for up  (pay attention on the coordinate system )
        i = row + 1
        while i < NumRows && candies[column,i]?.candyType == ctype {
            i += 1
            verLength += 1
        }
        
        //for down
        i = row - 1
        while i >= 0 && candies[column,i]?.candyType == ctype{
            i -= 1
            verLength += 1
        }
        
        return verLength >= 3
    }
    
    
    
    private func createInitialCandies() ->Set<Candy>{
        var set = Set<Candy>()
        
        for r in 0..<NumColumns{
            for c in 0..<NumRows{
                if tiles[c,r] != nil {
                    
               // let ctype = CandyType.random()
               //replace the random candy to make sure that it never creates a chain of three or more
                    //If the new random number causes a chain of three (because there are already two cookies of this type to the left or below) then the method tries again (how to make sure)
                    var ctype: CandyType
                    repeat{
                        ctype = CandyType.random()
                    }while(c >= 2 && candies[c-1,r]?.candyType == ctype && candies[c-2,r]?.candyType == ctype) ||
                           (r >= 2 && candies[c,r-1]?.candyType == ctype && candies[c,r-2]?.candyType == ctype)
                
                let candy = Candy(column: c, row: r, candyType: ctype)
                candies[c,r] = candy
                
                set.insert(candy)
                }
            }
        }
        return set
    }
    
    init(filename: String) {
        // 1
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        // 2
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        // 3
        for (row, rowArray) in tilesArray.enumerated() {
            // 4
            let tileRow = NumRows - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }
    
    func performSwap(swap:Swap){
        
        let columnA = swap.candyA.column
        let rowA = swap.candyA.row
        let columnB = swap.candyB.column
        let rowB = swap.candyB.row
        
        candies[columnA,rowA] = swap.candyB
        swap.candyB.column = columnA
        swap.candyB.row = rowA
        
        candies[columnB,rowB] = swap.candyA
        swap.candyA.column = columnB
        swap.candyA.row = rowB
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
}
