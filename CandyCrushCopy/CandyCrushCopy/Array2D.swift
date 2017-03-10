//
//  Array2D.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 8/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import Foundation

//this struct is a generic
struct Array2D<T>{
    let columns:Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns:Int, rows: Int){
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating:nil, count: rows*columns)
        
    }
    
    subscript(column:Int, row:Int)-> T?{
        get {
          return array[row*columns + column]

          }
        set {

          array[row*columns + column] = newValue
            }
    }
    
}
