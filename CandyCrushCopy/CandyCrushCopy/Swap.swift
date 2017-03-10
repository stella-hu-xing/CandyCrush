//
//  Swap.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 10/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

// CoustomStringConvertible: a type with customzed textual representation
struct Swap: CustomStringConvertible {
    
    let candyA: Candy
    let candyB: Candy
    
    init(candyA: Candy, candyB: Candy){
        self.candyA = candyA
        self.candyB = candyB
    }
    
    var description: String{
        return "swap \(candyA) with \(candyB)"
    }
}
