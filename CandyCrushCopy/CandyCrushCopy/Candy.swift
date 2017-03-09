//
//  Candy.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import SpriteKit

//put Candy as a model object that simple describes the data for the cookie. It is seperated from View and Controller.

enum CandyType:Int {
    case unknown = 0,cupcake, crossant,danish,donut,macaroon,sugarCookie
    
    //The spriteName property returns the filename of the corresponding sprite image in the texture atlas.
    //The spriteName and highlightedSpriteName properties simply look up the name for the cookie sprite in an array of strings.
    
    var spriteName:String{
        let spriteName = ["Cupcake","Crossant","Danish",
                        "Donut","Macaroon","SugarCookie"]
        
        return spriteName[rawValue - 1]//rawValue to convert the enum’s current value to an integer
        
    }
    var highlightedSpriteName: String{
        return spriteName+"-Highlighted"
    }
    
    
    //Every time a new cookie gets added to the game, it will get a random cookie type. It makes sense to add that as a function on CookieType
    static func random() ->CandyType{
        return CandyType(rawValue: Int(arc4random_uniform(6)+1))!
    }
    
    var description: String{
        return spriteName
    }
}


//customize the output of when you print a candy
class Candy:CustomStringConvertible, Hashable{
    
    var column: Int
    var row: Int
    let candyType: CandyType
    var sprite:SKSpriteNode? //because the candy object may not always have its sprite set.
    
    //to comform the CustomStringConvertible class,adding a computed property
    var description: String{
        return "type:\(candyType) square:(\(column),\(row))"
    }
    
    //The Hashable protocol requires that you add a hashValue property to the object. This should return an Int value that is as unique as possible for your object.
    var hashValue: Int{
        return row*10+column
    }
    
    init(column: Int, row:Int,candyType:CandyType){
        self.candyType = candyType
        self.column = column
        self.row = row
    }

}
//Whenever you add the Hashable protocol to an object, you also need to supply the == comparison operator for comparing two objects of the same type.
func ==(lhs: Candy, rhs: Candy)-> Bool{
    return lhs.column == rhs.column && rhs.row == lhs.row
}
