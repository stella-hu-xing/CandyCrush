//
//  Level.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import Foundation

//declare 2 constant
let NumColumns = 9
let NumRows = 9

//the different level
class Level{
    fileprivate var candies = Array2D<Candy>(columns:NumColumns, rows: NumRows)
    
    func candyAt(column:Int,row:Int)->Candy?{
        
        //The idea behind assert is you give it a condition, and if the condition fails the app will crash with a log message.
        
        assert(column >= 0 && column < NumColumns)
        assert(row>=0 && row < NumRows)
        return candies[column,row]
        
    }
    
    //The shuffle method fills up the level with random cookies.
    func shuffle() -> Set<Candy>{
        return createInitialCandies()
    }
    
    private func createInitialCandies() ->Set<Candy>{
        var set = Set<Candy>()
        
        for r in 0..<NumColumns{
            for c in 0..<NumRows{
                let ctype = CandyType.random()
                
                let candy = Candy(column: c, row: r, candyType: ctype)
                candies[c,r] = candy
                
                set.insert(candy)
            }
        }
        return set
    }
    
}
