//
//  Chain.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 12/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import Foundation

class Chain: Hashable, CustomStringConvertible{
    
    var candies = [Candy]()
    
    enum ChainType: CustomStringConvertible{
        case horizontal
        case vertical
        
        var description: String{
            switch self {
            case .horizontal:
                return "Horizontal"
            case .vertical:
                return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    //initialization
    init(chainType: ChainType){
        self.chainType = chainType
    }
    
    func add(candy: Candy){
        candies.append(candy)
    }
    
    func firstCandy() -> Candy{
        return candies[0]
    }
    
    func lastCandy() -> Candy{
        return candies[candies.count-1]
    }
    
    var length: Int{
        return candies.count
    }
    
    //to conform to protocal Hashable
    var hashValue: Int{
        return candies.reduce(0){
            $0.hashValue ^ $1.hashValue
        }
    }
   
    // to conform to protocal CustomStringConvertible
    var description: String{
        return "type: \(chainType)  candies\(candies)"
    }
    
    
}

func ==(lhs:Chain, rhs:Chain) -> Bool{
    return lhs.candies == rhs.candies
}
