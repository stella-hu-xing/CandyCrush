//
//The top-level item in the JSON file is a dictionary, so it makes sense to add the code for loading the JSON file to Swift’s Dictionary.

//  Extension.swift
//  CandyCrushCopy
//
//  Created by Xing Hu on 9/3/17.
//  Copyright © 2017 Xing Hu. All rights reserved.
//

import Foundation

//Using Swift’s extension mechanism you can add new methods to existing types.
extension Dictionary {
    
    
    //Here you have added loadJSONFromBundle(filename:) to load a JSON file from the app bundle, into a new dictionary of type Dictionary<String, AnyObject>. This means the dictionary’s keys are always strings but the associated values can be any type of object.

    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        var dataOK: Data
        var dictionaryOK: NSDictionary = NSDictionary()
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
                dataOK = data!
            }
            catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dictionaryOK = (dictionary as! NSDictionary as? Dictionary<String, AnyObject>)! as NSDictionary
            }
            catch {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        return dictionaryOK as? Dictionary<String, AnyObject>
    }
}
