//
//  LevelData.swift
//  DBCrush
//
//  Created by Esteban on 10.07.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import Foundation

class LevelData {
    
  static func loadFrom(file filename: String) -> LevelModel? {
    
    if let path = Bundle.main.path(forResource: filename, ofType: "json") {
        let jsonString = try! String(contentsOfFile: path)
        let response = LevelModel(json: jsonString)
        
        return response
    }
    else {
        return nil
    }
  }
}
