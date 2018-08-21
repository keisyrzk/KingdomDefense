//
//  GameScene.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate {
    func coinsDidUpdate(value: Int)
    func levelDidWin()
    func levelDidFail()
}

class GameScene: SKScene {

    var sceneDelegate: GameSceneDelegate? = nil
    
    // update time
    var lastUpdateTimeInterval: TimeInterval = 0
    
    var lastUnitDidSpawn: Bool = false
    
    var entityManager: EntityManager!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var level: Level!
    var cam:SKCameraNode!
    
    var towerPicker: TowerPicker!
    var _tile: TileModel = TileModel(type: .None)
    var _column: Int = 0
    var _row: Int = 0
    
    let scale: CGFloat = 3
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 127/255, green: 200/255, blue: 88/255, alpha: 1)
        
        //  entity manager
        entityManager = EntityManager(scene: self)
        
        // setup camera
        setupCamera()
        
        // add tiles
        addTiles()
        
        // add castle node
        addCastle()
        
        // handle tower picker
        towerPicker = TowerPicker(entityManager: entityManager)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            
            if location.x > (self.frame.width * scale)/2 - TileModel.width &&
                location.x < level.size.width - (self.frame.width * scale)/2 &&
                location.y > (self.frame.height * scale)/2 &&
                location.y < level.size.height - (self.frame.height * scale)/2 {
                
                let move = SKAction.move(to: location, duration:0.2)
                cam.run(move)
            }
            else if location.x > (self.frame.width * scale)/2
                && location.x < level.size.width - (self.frame.width * scale)/2 {
                let move = SKAction.move(to: CGPoint(x: location.x, y: cam.position.y), duration:0.2)
                cam.run(move)
            }
            else if location.y > (self.frame.height * scale)/2
                && location.y < level.size.height - (self.frame.height * scale)/2 {
                let move = SKAction.move(to: CGPoint(x: cam.position.x, y: location.y), duration:0.2)
                cam.run(move)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            
            if towerPicker.isVisible {
                towerPicker.doAction(point: location, selected: { (selected) in
                    
                    buildTower(tile: _tile,
                               towerType: selected.towerType,
                               column: _column,
                               row: _row)

                    towerPicker.hide()
                }) {
                    towerPicker.hide()
                }
            }
            
            let (isSuccess, column, row) = TileModel.convertPoint(location)
            if isSuccess && !towerPicker.isVisible {
                if let tile = level.isTile(column: column, row: row) {
                    
                    _tile = tile
                    _column = column
                    _row = row
                    
                    if tile.type == .ConstructionField || tile.type == .Constructed {
                        handleTowerPicker(show: true, tile: tile, location: TileModel.getPointFor(column: column, row: row))
                    }
                }
            }
        }
    }
    
    private func handleTowerPicker(show: Bool, tile: TileModel? = nil, location: CGPoint? = nil) {
        
        if show {
            if let _location = location {
                towerPicker.show(location: _location, tile: tile!)
            }
        }
        else {
            towerPicker.hide()
        }
    }
    
    private func buildTower(tile: TileModel, towerType: Tower.TowerType, column: Int, row: Int) {
        
        if tile.type == .ConstructionField {
            if let humanCastle = entityManager.getCastle() {
                if humanCastle.coins >= towerType.cost() {
                    humanCastle.coins -= towerType.cost()
                    addTower(type: towerType, at: TileModel.getPointFor(column: column, row: row))
                    tile.type = .Constructed
                    handleTowerPicker(show: false)
                }
            }
        }
        else if tile.type == .Constructed {
            entityManager.updateTower(at: TileModel.getPointFor(column: column, row: row))
            handleTowerPicker(show: false)
        }
    }

    private func setupCamera() {
        
        cam = SKCameraNode()
        cam.setScale(scale)
        self.camera = cam
        self.addChild(cam)
        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midX)
    }
    
    private func addCastle() {

        let castle = Castle(imageName: "castle", entityManager: entityManager)
        if let spriteComponent = castle.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = level.getEndPoint()
        }
        entityManager.add(entity: castle, scale: 3)
    }
    
    private func addTower(type: Tower.TowerType, at position: CGPoint) {
        let tower = Tower(towerType: type, entityManager: entityManager)
        if let spriteComponent = tower.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
        }
        entityManager.add(entity: tower)
    }
    
    private func addTiles() {
        
        //add the tiles textures
        for _row in 0 ... Level.numRows {
            for column in 0 ... Level.numColumns {
        
                let row = Level.numRows - _row  //this is for iterating through map from bottom to top
                
                //check what kind of tile position it is (inside/outside corner, simple etc.)
                if column > 0 && column < Level.numColumns && row > 0 && row < Level.numRows {
                    if let tile = level.isTile(column: column, row: row) {
                        
                        var name = ""
                        
                        switch tile.type {
                            
                        case .Path, .MidPA, .MidPB:
                            let value = TileModel.getTileTypeValue(level: level, column: column, row: row)
                            if value != 0 {
                                name = String(format: "Tile_%ld", value)
                            }
                        case .Start:
                            name = "Tile_6"
                        case .End:
                            name = "Tile_6"
                        case .Water:
                            let value = TileModel.getTileTypeValue(level: level, column: column, row: row)
                            if value != 0 {
                                name = String(format: "Tile_2%ld", value)
                            }
                        case .Bridge:
                            name = "Tile_28"
                        case .ConstructionField:
                            name = "constructionField"
                        case .Tree:
                            name = "treeTile"
                        case .Fireplace:
                            name = "fireplace"
                        case .RoadSign:
                            name = "roadSign"
                        case .Building:
                            name = String(format: "building_%ld", Helpers.getRandomInRange(from: 1, to: 2))
                        case .Extras:
                            name = String(format: "extras_%ld", Helpers.getRandomInRange(from: 1, to: 4))
                        default:
                            break
                        }
                        
                        
                        let tileEntity = Tile(imageName: name)
                        if let spriteComponent = tileEntity.component(ofType: SpriteComponent.self) {
                            let point = TileModel.getPointFor(column: column, row: row)
                            spriteComponent.node.position = point
                            
                            switch tile.type {
                            case .Path, .Bridge, .Water:
                                spriteComponent.node.zPosition = 2
                            default:
                                spriteComponent.node.zPosition = 3
                            }
                            
                            entityManager.add(entity: tileEntity)
                        }
                    }
                }
            }
        }
        
    }
    
     override func update(_ currentTime: TimeInterval) {
     
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        
        if let humanCastle = entityManager.getCastle() {
            sceneDelegate?.coinsDidUpdate(value: humanCastle.coins)
        }
        
        if let castleHealth = entityManager.getCastleHealth() {
            if castleHealth.health <= 0 {
                sceneDelegate?.levelDidFail()
            }
            else if lastUnitDidSpawn == true && entityManager.getEntities(for: .AITeam).count == 0 {
                lastUnitDidSpawn = false
                sceneDelegate?.levelDidWin()
            }
        }
    }
}
