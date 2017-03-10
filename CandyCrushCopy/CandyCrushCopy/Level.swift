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
        return createInitialCandies()
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
    
}
