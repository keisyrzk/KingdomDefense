//
//  Level.swift
//  DragonCrush
//
//  Created by Esteban on 12.07.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit
import GameplayKit

class Level {
    
    enum Unit: Int {
        case None
        
        case Knight
        case Dwarf
        case Undead
    }
    
    // level dimensions
    static let numColumns = 10
    static let numRows = 10
    
    // level size
    var size: CGSize = CGSize.zero
    
    // level data
    var graph = GKGraph()
    var startNode: GKGraphNode2D!
    var endNode: GKGraphNode2D!
    var pathNodes: [GKGraphNode2D] = []
//    var path: GKPath!
    var paths: [GKPath] = []
    
    var midA: GKGraphNode2D? = nil
    var midB: GKGraphNode2D? = nil

    var data: LevelModel!
    
    // level tiles
    private var tiles = Array2D<TileModel>(columns: numColumns, rows: numRows)
    var tilesPoints: [TileModel.TileType : [CGPoint]] = [:]
    
    init(level fileName: String) {
        
        guard let levelData = LevelData.loadFrom(file: fileName) else {return}
        self.data = levelData
        
        
        for (row, rowArray) in levelData.tiles.enumerated() {
            
            //reverse the order because the tiles are numbered form 0 from the bottom of the scene
            let tileRow = Level.numRows - row - 1
            for (column, value) in rowArray.enumerated() {      //go through the matrix and if value is 1 than put a tile there
                
                if let type = TileModel.TileType(rawValue: value) {
                    
                    if value != 0 {
                        tiles[column, tileRow] = TileModel(type: type)
                        let nodePoint = TileModel.getPointFor(column: column, row: tileRow)
                        
                        if let _ = tilesPoints[type] {
                            tilesPoints[type]?.append(nodePoint)
                        }
                        else {
                            tilesPoints[type] = [nodePoint]
                        }
                        
                        if type == .Start {
                            startNode = GKGraphNode2D(point: vector_float2(Float(nodePoint.x),Float(nodePoint.y)))
                        }
                        if type == .End {
                            endNode = GKGraphNode2D(point: vector_float2(Float(nodePoint.x),Float(nodePoint.y)))
                        }
                        if type == .Path || type == .Bridge {
                            pathNodes.append(GKGraphNode2D(point: vector_float2(Float(nodePoint.x),Float(nodePoint.y))))
                        }
                        
                        if type == .MidPA {
                            midA = GKGraphNode2D(point: vector_float2(Float(nodePoint.x),Float(nodePoint.y)))
                        }
                        if type == .MidPB {
                            midB = GKGraphNode2D(point: vector_float2(Float(nodePoint.x),Float(nodePoint.y)))
                        }
                    }
                }
            }
        }
        
//        generateGraph()
        findPaths()
    }
    
    func isTile(column: Int, row: Int) -> TileModel? {
        
        precondition(column >= 0 && column < Level.numColumns)
        precondition(row >= 0 && row < Level.numRows)
        return tiles[column, row]
    }
    
    func getStartPoint() -> CGPoint {
        return tilesPoints[.Start]?.first ?? CGPoint.zero
    }
    
    func getEndPoint() -> CGPoint {
        return tilesPoints[.End]?.first ?? CGPoint.zero
    }
    
    func getPathPoints() -> [CGPoint] {
        return tilesPoints[.Path] ?? [CGPoint.zero]
    }
    
    func getBuildingPoints() -> [CGPoint] {
        return tilesPoints[.Building] ?? [CGPoint.zero]
    }
    
//    private func generateGraph() {
//
//        var nodes: [GKGraphNode2D] = pathNodes
//        nodes.append(startNode)
//        nodes.append(endNode)
//
//        let graph = GKGraph()
//        graph.add(nodes)
//
//        nodes.forEach { (node) in
//
//            let closeNodes = nodes.filter{ distance(fromPoint: $0.position, toPoint: node.position) == TileModel.width }
//            node.addConnections(to: closeNodes, bidirectional: false)
//        }
//
//        let _pathNodes = graph.findPath(from: startNode, to: endNode)
////        path = GKPath(graphNodes: _pathNodes, radius: 1)
//    }
    
    // Calculates distance between two points.
    private func distance(fromPoint: float2, toPoint: float2) -> CGFloat {
        let xDist = Float(fromPoint.x - toPoint.x)
        let yDist = Float(fromPoint.y - toPoint.y)
        return CGFloat(hypotf(xDist, yDist))
    }
    
    
    
    ////////////////////
    
    func getRandomPath() -> GKPath {
        let pathIndex = Helpers.getRandomInRange(from: 0, to: paths.count)
        return paths[pathIndex]
    }
    
    func findPaths() {
        
        // if two paths map
        if let _midA = midA, let _midB = midB {
            paths.append(findPath(with: _midA))
            paths.append(findPath(with: _midB))
        }
        else {
            paths.append(findPath(with: nil))
        }
    }
    
    private func findPath(with midPoint: GKGraphNode2D? = nil) -> GKPath {
        
        var nodes: [GKGraphNode2D] = pathNodes
        nodes.append(startNode)
        nodes.append(endNode)
        
        if let _midPoint = midPoint {
            nodes.append(_midPoint)
        }
        
        let graph = GKGraph()
        graph.add(nodes)
        
        nodes.forEach { (node) in
            
            let closeNodes = nodes.filter{ distance(fromPoint: $0.position, toPoint: node.position) == TileModel.width }
            node.addConnections(to: closeNodes, bidirectional: false)
        }
        
        let _pathNodes = graph.findPath(from: startNode, to: endNode)
        
        return GKPath(graphNodes: _pathNodes, radius: 1)
    }
}
