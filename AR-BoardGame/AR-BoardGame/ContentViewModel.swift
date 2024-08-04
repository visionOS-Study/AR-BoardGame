//
//  ContentViewModel.swift
//  AR-BoardGame
//
//  Created by Damin on 8/5/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

@Observable
class ContentViewModel {
    var immersiveSpaceIsShown = false
    var isResetImmersiveContents = false
    var contentEntity = Entity()
    private var childList: [Entity] = []
    private let modelScale: Float = 0.1

    func setUpContentEntity() -> Entity {
        for child in childList {
            contentEntity.removeChild(child)
        }
        childList = []
        
        var x: Float = 0.3
        var y: Float = 0.3
        var z: Float = -3
        
        for i in 0..<10 {
            guard let modelEntity = try? ModelEntity.loadModel(named: "player_pawn_blue.usdz") else {
                return ModelEntity()
            }
            modelEntity.scale = SIMD3(repeating: modelScale)
            //TODO: 배치로직 구현필요
            if i % 2 == 0 {
                y += 0.4
            }else {
                x += 0.4
            }
            
            modelEntity.name = "index-\(i)"
            modelEntity.position = SIMD3<Float>(x: x, y: y, z: z)
            
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
            
            childList.append(modelEntity)
            
            contentEntity.addChild(modelEntity)
        }
        return contentEntity
    }
    
    func removeChildEntity(removedChild: Entity) {
        contentEntity.removeChild(removedChild)
        for (idx , child) in childList.enumerated() {
            if child.name == removedChild.name {
                childList.remove(at: idx)
            }
        }
    }
    
}
