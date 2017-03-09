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
                let ctype = CandyType.random()
                
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
    
}
