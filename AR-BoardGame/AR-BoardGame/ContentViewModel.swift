//
//  ContentViewModel.swift
//  AR-BoardGame
//
//  Created by Damin on 8/5/24.
//

import SwiftUI
import UIKit
import RealityKit
import RealityKitContent

@Observable
class ContentViewModel {
    var immersiveSpaceIsShown = false
    var isResetImmersiveContents = false
    var contentEntity = Entity()
    private var childList: [ModelEntity] = []
    private let modelScale: Float = 0.1
    
    func setUpContentEntity() -> Entity {
        for child in childList {
            contentEntity.removeChild(child)
        }
        childList = []
        
        for i in 0..<10 {
            let modelEntity = makeBubble(text: "\(i+1)")
            modelEntity.scale = SIMD3(repeating: modelScale)
            
            //TODO: 배치로직 구현필요
            let x = Float.random(in: -2...2)
            let y = Float.random(in: -2...2)
            let z = Float.random(in: -4 ... -3)
            
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
        
        addParticleEntity(position: removedChild.position)
    }
    
    func addParticleEntity(position:  SIMD3<Float>) {
        /// ✅ 파티클
        let particleEntity = Entity()
        var particleEmitter = ParticleEmitterComponent()
        
        /// 한 번만 실행
        let emitDuration = ParticleEmitterComponent.Timing.VariableDuration(duration: 1.0)
        particleEmitter.timing = .once(warmUp: nil, emit: emitDuration)
        particleEmitter.emitterShape = ParticleEmitterComponent.EmitterShape.sphere
        particleEntity.components.set(particleEmitter)
        particleEntity.position = position
        // 색상 변경
        particleEmitter.mainEmitter.color = .constant(.single(.white))
        particleEntity.components.set(particleEmitter)
        
        print("particle position: " + "\(particleEntity.position)")
        
        contentEntity.addChild(particleEntity)
    }
    
    func makeBubble(text: String) -> ModelEntity {
        /// ✅ 투명 메테리얼 : 버블
        var clearMaterial = PhysicallyBasedMaterial()
        clearMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 1.0)
        clearMaterial.clearcoatRoughness = PhysicallyBasedMaterial.ClearcoatRoughness(floatLiteral: 0.1)
        clearMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.1))
        clearMaterial.emissiveColor = .init(color: .lightGray)
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 2),
            materials: [clearMaterial],
            collisionShape: .generateSphere(radius: 2),
            mass: 0.0
        )
        
        
        /// 3D 숫자
        let textMeshResource: MeshResource = .generateText(text,
                                                           extrusionDepth: 0.1,
                                                           font: .systemFont(ofSize: CGFloat(1.5), weight: .bold),
                                                           containerFrame: .zero,
                                                           alignment: .center,
                                                           lineBreakMode: .byWordWrapping )
        let numMaterial = UnlitMaterial(color:.black)
        
        let textEntity = ModelEntity(mesh: textMeshResource, materials:  [numMaterial])
        //textEntity.position =  entity.position
        textEntity.position = [entity.position.x - 0.3, entity.position.y - 0.8, entity.position.z]
        
        print("text position: " + "\(textEntity.position)")
        entity.addChild(textEntity)
        
        return entity
    }
    
    
}


