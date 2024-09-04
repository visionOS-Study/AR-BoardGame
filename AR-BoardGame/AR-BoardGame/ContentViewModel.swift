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
    private let modelScale: Float = 0.3
    private var textBoundingBox = BoundingBox.empty
    
    func setUpContentEntity() -> Entity {
        for child in childList {
            contentEntity.removeChild(child)
        }
        childList = []
        
        let xRange: ClosedRange<Float> = -1.5...1.5
        let yRange: ClosedRange<Float> = 0.5...1.5
        let zRange: ClosedRange<Float> = -3.0 ... -2.0
        
        for i in 0..<30 {
            let modelEntity = makeBubble()
            let textModelEntity = makeTextModel(textString: "\(i)")
            modelEntity.scale = SIMD3(repeating: modelScale)
            textModelEntity.scale = SIMD3(repeating: 1.0)
            
            // x, y, z 범위 내에서 랜덤하게 값을 생성
            let randomX = Float.random(in: xRange)
            let randomY = Float.random(in: yRange)
            let randomZ = Float.random(in: zRange)
            
            modelEntity.name = "index-\(i)"
            modelEntity.position = SIMD3<Float>(x: randomX, y: randomY, z: randomZ)
            
            textModelEntity.name = "text-\(i)"
            let boundsExtents = textBoundingBox.extents * textModelEntity.scale
            textModelEntity.position = textModelEntity.position - SIMD3<Float>(x: boundsExtents.x/2, y: boundsExtents.y/2 + 0.03, z: 0.0)
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

            modelEntity.addChild(textModelEntity)

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
        // 새 파티클 추가전 particleEntity들 삭제
        // 삭제를 안하면 이전에 particle이 추가된 엔터티가 contentEntity에 남아있고
        // 씬 reset 실행시 이전에 추가된 파티클이 다시 실행됨
        for entity in contentEntity.children {
            if let particleEntity = entity.findEntity(named: "particle") {
                entity.removeChild(particleEntity)
            }
        }
        
        addParticleEntity(transForm: removedChild.transform)
    }
    
    func addParticleEntity(transForm: Transform) {
        let particleEntity = Entity()
        var emitterComponent = ParticleEmitterComponent()
        emitterComponent = ParticleEmitterComponent.Presets.magic
        /// 한 번만 실행
        let emitDuration = ParticleEmitterComponent.Timing.VariableDuration(duration: 1.0)
        emitterComponent.timing = .once(warmUp: nil, emit: emitDuration)
        emitterComponent.emitterShape = ParticleEmitterComponent.EmitterShape.sphere
        
        typealias ParticleEmitter = ParticleEmitterComponent.ParticleEmitter
        let singleColorValue1 = ParticleEmitter.ParticleColor.ColorValue.single(ParticleEmitter.Color.white)
        let singleColorValue2 = ParticleEmitter.ParticleColor.ColorValue.single(ParticleEmitter.Color.yellow)
        // Create an evolving color that shifts from one color value to another.
        let evolvingColor = ParticleEmitter.ParticleColor.evolving(start: singleColorValue1,
                                                   end: singleColorValue2)
        emitterComponent.speed = 1
        emitterComponent.mainEmitter.birthRate = 150
        emitterComponent.mainEmitter.color = evolvingColor
        
        particleEntity.components.set(emitterComponent)
        particleEntity.transform = transForm
        // 삭제시 파티클 이름으로 확인
        particleEntity.name = "particle"
        contentEntity.addChild(particleEntity)
    }
    
    func makeBubble() -> ModelEntity {
        var clearMaterial = PhysicallyBasedMaterial()
        clearMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 5.0)
        clearMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.1))
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.3),
            materials: [clearMaterial],
            collisionShape: .generateSphere(radius: 0.3),
            mass: 0.0
        )
        return entity
    }
    
    func makeTextModel(textString: String) -> ModelEntity {
        let materialVar = SimpleMaterial(color: .black, roughness: 0, isMetallic: false)
        
        let depthVar: Float = 0.1
        let fontVar = UIFont.systemFont(ofSize: 0.3)
        // containerFrame을 넣으면 모델이 안나옴
//        let containerFrameVar = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        let containerFrameVar = CGRect.zero
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        let textMeshResource : MeshResource = .generateText(textString,
                                                            extrusionDepth: depthVar,
                                                            font: fontVar,
                                                            containerFrame: containerFrameVar,
                                                            alignment: alignmentVar,
                                                            lineBreakMode: lineBreakModeVar)
        
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        textBoundingBox = textMeshResource.bounds
        return textEntity
    }
    
}
