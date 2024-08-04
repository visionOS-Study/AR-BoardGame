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
            let modelEntity = makeBubble()
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
        removedChild.removeFromParent()
        
        // 배열에도 entity 삭제
        for (idx , child) in childList.enumerated() {
            if child.name == removedChild.name {
                childList.remove(at: idx)
            }
        }
        
        addParticleEntity(transForm: removedChild.transform)
    }
    
    func addParticleEntity(transForm: Transform) {
        /// ✅ 파티클
        let particleEntity = Entity()
        var particleEmitter = ParticleEmitterComponent()
        
        /// 한 번만 실행
        let emitDuration = ParticleEmitterComponent.Timing.VariableDuration(duration: 1.0)
        particleEmitter.timing = .once(warmUp: nil, emit: emitDuration)
        particleEmitter.emitterShape = ParticleEmitterComponent.EmitterShape.sphere
        particleEntity.components.set(particleEmitter)
        particleEntity.transform = transForm
        
        contentEntity.addChild(particleEntity)
    }
    
    func makeBubble() -> ModelEntity {
        /// ✅ 투명 메테리얼
        var clearMaterial = PhysicallyBasedMaterial()
        clearMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 1.0)
        clearMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.3))
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.3),
            materials: [clearMaterial],
            collisionShape: .generateSphere(radius: 0.3),
            mass: 0.0
        )
        return entity
    }
    
}
