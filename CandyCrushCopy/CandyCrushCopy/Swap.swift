//
//  Swap.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 10/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

// CoustomStringConvertible: a type with customzed textual representation
struct Swap: CustomStringConvertible,Hashable {
    
    let candyA: Candy
    let candyB: Candy
    
    init(candyA: Candy, candyB: Candy){
        self.candyA = candyA
        self.candyB = candyB
    }
    
    var description: String{
        return "swap \(candyA) with \(candyB)"
    }
    
    var hashValue: Int{
        
        //This simply combines the hash values of the two cookies with the exclusive-or operator.
        return candyA.hashValue ^ candyB.hashValue
    }
    
}


func ==(lhs:Swap,rhs:Swap) ->Bool{
    return (lhs.candyA == rhs.candyA && lhs.candyB == rhs.candyB) ||
           (lhs.candyB == rhs.candyA && lhs.candyA == rhs.candyB)
}
