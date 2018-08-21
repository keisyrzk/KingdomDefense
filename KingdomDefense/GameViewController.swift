//
//  GameViewController.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {

    @IBOutlet weak var coinsValueLabel: UILabel!
    @IBOutlet weak var popupButton: UIButton!
    
    var scene: GameScene!
    
    var currentLevel = 0
    
    var units: [Unit] = []
    var waveCounter = 0
    var unitsSpawnCounter = 0
    
    var unitsTimer: Timer!
    var wavesTimer: Timer!
    
    enum GameplayState {
        case Start
        case Failed
        case Won
    }
    
    var gameplayState: GameplayState = .Start
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        popupButton.isHidden = false
        popupButton.setTitle("START", for: .normal)
    }
    
    private func startGame() {
        
        units = []
        waveCounter = 0
        unitsSpawnCounter = 0
        
        scene = GameScene()
        scene.sceneDelegate = self
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        let level = Level(level: "Level_\(currentLevel)")
        level.size = CGSize(width: CGFloat(Level.numColumns) * TileModel.width,
                            height: CGFloat(Level.numRows) * TileModel.height)
        scene.level = level
        skView.presentScene(scene)
        
        runWave()
    }
    
    override var prefersStatusBarHidden : Bool  {
        return true
    }
    
    func coinsDidUpdate(value: Int) {
        coinsValueLabel.text = "\(value)"
    }
    
    func levelDidWin() {
        scene.isPaused = true
        popupButton.setTitle("YOU WON!", for: .normal)
        popupButton.isHidden = false
        currentLevel += 1
        gameplayState = .Won
    }
    
    func levelDidFail() {
        scene.isPaused = true
        popupButton.setTitle("YOU FAILED!", for: .normal)
        popupButton.isHidden = false
        gameplayState = .Failed
    }
    
    @objc func runWave() {
        
        if waveCounter + 1 <= scene.level.data.waves.count {
            let wave = scene.level.data.waves[waveCounter]
            waveCounter += 1
            
            units = []
            for _ in 0 ..< wave.knights {
                units.append(.Knight)
            }
            for _ in 0 ..< wave.dwarfs {
                units.append(.Dwarf)
            }
            for _ in 0 ..< wave.undeads {
                units.append(.Undead)
            }
            
            units.shuffle()
            unitsTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.spawnUnit), userInfo: nil, repeats: true)
        }
    }
    
    @objc func spawnUnit() {
        
        if unitsSpawnCounter < units.count {
            switch units[unitsSpawnCounter] {
                
            case .Knight:
                scene.entityManager.spawnKnight()
            case .Dwarf:
                scene.entityManager.spawnDwarf()
            case .Undead:
                scene.entityManager.spawnUndead()
            }
            
            unitsSpawnCounter += 1
        }
        else {
            unitsTimer.invalidate()
            wavesTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.runWave), userInfo: nil, repeats: false)
            
            if waveCounter + 1 <= scene.level.data.waves.count {
                scene.lastUnitDidSpawn = true
            }
        }
    }
    
    @IBAction func popupButtonAction(_ sender: Any) {
        
        switch gameplayState {
            
        case .Start:
            popupButton.isHidden = true
            startGame()
            popupButton.setTitle("", for: .normal)
            scene.isPaused = false
        case .Failed, .Won:
            popupButton.setTitle("START", for: .normal)
            gameplayState = .Start
            popupButton.isHidden = false
        }
    }
    
}
