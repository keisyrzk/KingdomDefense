//
//  TileModel.swift
//  DragonCrush
//
//  Created by Esteban on 12.07.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit

class TileModel {
    
    enum TileType: Int {
        case None = 0
        
        case Path = 1
        case Start = 2
        case End = 3
        
        case MidPA = -1
        case MidPB = -2
        
        case Building = 4
        case Water = 5
        case Bridge = 6
        case Tree = 7
        case Extras = 8
        case Fireplace = 9
        case RoadSign = 10
        
        case ConstructionField = 99
        case Constructed = 98
    }
    
    var type: TileType = .None
    
    init(type: TileType) {
        self.type = type
    }
    
        //tile dimensions taken from the tile image size
    static let width: CGFloat = 208
    static let height: CGFloat = 208
    
        // get point for given row and column
    static func getPointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * TileModel.width + TileModel.width / 2,
                       y: CGFloat(row) * TileModel.height + TileModel.height / 2)
    }
    
        // get the row and column for a given point (of touch)
    static func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(Level.numColumns) * TileModel.width && point.y >= 0 && point.y < CGFloat(Level.numRows) * TileModel.height {
            return (true, Int(point.x / TileModel.width), Int(point.y / TileModel.height))
        }
        else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    static func getTileTypeValue(level: Level, column: Int, row: Int) -> Int {
        
        let currentType = level.isTile(column: column, row: row)?.type
        
        var up = false
        var down = false
        var left = false
        var right = false
        
        if let _currentType = currentType {
            
            switch _currentType {
                
            case .Path:
                up = (row + 1 < Level.numRows) && level.isTile(column: column, row: row + 1) != nil
                    && (level.isTile(column: column, row: row + 1)?.type == currentType || level.isTile(column: column, row: row + 1)?.type == .MidPA || level.isTile(column: column, row: row + 1)?.type == .MidPB)
                down = (row - 1 > 0) && level.isTile(column: column, row: row - 1) != nil
                    && (level.isTile(column: column, row: row - 1)?.type == currentType || level.isTile(column: column, row: row - 1)?.type == .MidPA || level.isTile(column: column, row: row - 1)?.type == .MidPB)
                left = (column - 1 > 0) && level.isTile(column: column - 1, row: row) != nil
                    && (level.isTile(column: column - 1, row: row)?.type == currentType || level.isTile(column: column - 1, row: row)?.type == .MidPA || level.isTile(column: column - 1, row: row)?.type == .MidPB)
                right = (column + 1 < Level.numColumns) && level.isTile(column: column + 1, row: row) != nil
                    && (level.isTile(column: column + 1, row: row)?.type == currentType || level.isTile(column: column + 1, row: row)?.type == .MidPA || level.isTile(column: column + 1, row: row)?.type == .MidPB)
                
            case .MidPA, .MidPB:
                up = (row + 1 < Level.numRows) && level.isTile(column: column, row: row + 1) != nil
                    && (level.isTile(column: column, row: row + 1)?.type == currentType || level.isTile(column: column, row: row + 1)?.type == .Path )
                down = (row - 1 > 0) && level.isTile(column: column, row: row - 1) != nil
                    && (level.isTile(column: column, row: row - 1)?.type == currentType || level.isTile(column: column, row: row - 1)?.type == .Path)
                left = (column - 1 > 0) && level.isTile(column: column - 1, row: row) != nil
                    && (level.isTile(column: column - 1, row: row)?.type == currentType || level.isTile(column: column - 1, row: row)?.type == .Path)
                right = (column + 1 < Level.numColumns) && level.isTile(column: column + 1, row: row) != nil
                    && (level.isTile(column: column + 1, row: row)?.type == currentType || level.isTile(column: column + 1, row: row)?.type == .Path)
                
            default:
                up = (row + 1 < Level.numRows) && level.isTile(column: column, row: row + 1) != nil && level.isTile(column: column, row: row + 1)?.type == currentType
                down = (row - 1 > 0) && level.isTile(column: column, row: row - 1) != nil && level.isTile(column: column, row: row - 1)?.type == currentType
                left = (column - 1 > 0) && level.isTile(column: column - 1, row: row) != nil && level.isTile(column: column - 1, row: row)?.type == currentType
                right = (column + 1 < Level.numColumns) && level.isTile(column: column + 1, row: row) != nil && level.isTile(column: column + 1, row: row)?.type == currentType
            }
        }
        
        

        //                    let upLeft = (column - 1 < 0) && (row + 1 < Level.numRows) && level.isTile(column: column - 1, row: row + 1) != nil
        //                    let upRight = (column + 1 < Level.numColumns) && (row + 1 < Level.numRows) && level.isTile(column: column + 1, row: row + 1) != nil
        //
        //                    let downLeft = (column - 1 < 0) && (row - 1 > 0) && level.isTile(column: column - 1, row: row - 1) != nil
        //                    let downRight = (row - 1 > 0) && (column + 1 < Level.numColumns) && level.isTile(column: column + 1, row: row - 1) != nil
        //
        
        var value = 0
        
        // up/down
        if (up || down) && !left && !right {
            value = 6
        }
        // left/right
        if (left || right) && !up && !down {
            value = 7
        }
        // arc up-left
        if down && left && !right && !up  {
            value = 2
        }
        // arc up-right
        if down && right && !left && !up  {
            value = 1
        }
        // arc down-left
        if up && left && !right && !down  {
            value = 3
        }
        // arc up-right
        if up && right && !left && !down  {
            value = 4
        }
        // cross
        if up && down && left && right  {
            value = 5
        }
        // triple down
        if down && left && right && !up {
            value = 11
        }
        // triple left
        if up && down && left && !right {
            value = 12
        }
        // triple up
        if up && left && right && !down {
            value = 13
        }
        // triple right
        if up && right && down && !left {
            value = 14
        }
        
        
        return value
    }
}
