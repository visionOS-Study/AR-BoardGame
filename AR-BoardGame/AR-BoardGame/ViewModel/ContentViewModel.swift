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
        
        let x: Float = 0
        let y: Float = 0.5
        let z: Float = -1
        
        var coordinates = makeCoordinates(row: 3)
        
        for i in 0..<coordinates.count {
            let modelEntity = makeBubble(String(i))
            modelEntity.scale = SIMD3(repeating: modelScale)
            
            let textModelEntity = makeTextEntity(text: String(i))
            modelEntity.addChild(textModelEntity)

            coordinates = coordinates.shuffled()
            let coor = coordinates.popLast()!
            
            modelEntity.position = SIMD3<Float>(
                x: x + Float(coor.x),
                y: y + Float(coor.y),
                z: z - Float(coor.z)
            )
            
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.components.set(InputTargetComponent(allowedInputTypes: .all))
            
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
//        emitterComponent = ParticleEmitterComponent.Presets.impact
        /// 한 번만 실행
        let emitDuration = ParticleEmitterComponent.Timing.VariableDuration(duration: 1.0)
        emitterComponent.timing = .once(warmUp: nil, emit: emitDuration)
        emitterComponent.emitterShape = ParticleEmitterComponent.EmitterShape.sphere
        
//        typealias ParticleEmitter = ParticleEmitterComponent.ParticleEmitter
//        let singleColorValue1 = ParticleEmitter.ParticleColor.ColorValue.single(ParticleEmitter.Color.black)
//        let singleColorValue2 = ParticleEmitter.ParticleColor.ColorValue.single(ParticleEmitter.Color.white)
//        // Create an evolving color that shifts from one color value to another.
//        let evolvingColor = ParticleEmitter.ParticleColor.evolving(start: singleColorValue1, end: singleColorValue2)
        emitterComponent.speed = 1
        emitterComponent.mainEmitter.birthRate = 100
//        emitterComponent.mainEmitter.color = evolvingColor
        emitterComponent.mainEmitter.color = .constant(.single(.white))
        
        particleEntity.components.set(emitterComponent)
        particleEntity.transform = transForm
        // 삭제시 파티클 이름으로 확인
        particleEntity.name = "particle"
        contentEntity.addChild(particleEntity)
        
    }
    
    func makeBubble(_ index: String) -> ModelEntity {
        var clearMaterial = PhysicallyBasedMaterial()
        clearMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 5.0)
        clearMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.1))
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.3),
            materials: [clearMaterial],
            collisionShape: .generateSphere(radius: 0.3),
            mass: 0.0
        )
        entity.name = "index-\(index)"
        
        return entity
    }
    
    func makeTextEntity(text: String, scale: Float = 1.0) -> ModelEntity {
        let materialVar = SimpleMaterial(color: .black, roughness: 0, isMetallic: false)
        
        let depthVar: Float = 0.1
        let fontVar = UIFont.systemFont(ofSize: 0.3)
        // containerFrame을 넣으면 모델이 안나옴
//        let containerFrameVar = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        let containerFrameVar = CGRect.zero
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        let textMeshResource : MeshResource = .generateText(text,
                                                            extrusionDepth: depthVar,
                                                            font: fontVar,
                                                            containerFrame: containerFrameVar,
                                                            alignment: alignmentVar,
                                                            lineBreakMode: lineBreakModeVar)
        
        let textModelEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        textModelEntity.name = "text-\(text)"
        textBoundingBox = textMeshResource.bounds
        textModelEntity.scale = SIMD3(repeating: scale)
        
        let boundsExtents = textBoundingBox.extents * textModelEntity.scale
        textModelEntity.position = textModelEntity.position - SIMD3<Float>(x: boundsExtents.x/2, y: boundsExtents.y/2 + 0.03, z: 0.0)
        return textModelEntity
    }
    
    private func makeCoordinates(row: Int = 3) -> [EntityCoordinate] {
        
        // 반원 반경으로 10개의 Entity를 배치하기 위한 고정 위치 값
        let xValues: [Float] = [-1.00, -0.78, -0.56, -0.33, -0.11, 0.11, 0.33, 0.56, 0.78, 1.00]
        let zValues: [Float] = [0.43, 0.63, 0.83, 0.94, 0.99, 0.99, 0.94, 0.83, 0.63, 0.43]
        
        var coordinates: [EntityCoordinate] = []
        var y: Float = 0
        
        for r in 0..<row {
          for (x, z) in zip(xValues, zValues) {
            coordinates.append(EntityCoordinate(x: x, y: y, z: z))
          }
          
          y += 0.5
        }
        
        return coordinates
      }
    
}
