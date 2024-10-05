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
    var isResetImmersiveContents = false
    var isAllBubbleTapped = false
    var contentEntity = Entity()
    private let modelScale: Float = 0.3
    private var textBoundingBox = BoundingBox.empty
    
    private var currentIndex = 1
    private var countOfBubbles = 20
    private var addedChildList: [Entity] = []
    func resetContentEnityChild() {
        for child in addedChildList {
            contentEntity.removeChild(child)
        }
        addedChildList = []
    }
    
    func setUpContentEntity() -> Entity {
        resetContentEnityChild()
        
        var coordinates = makeCoordinates(row: 3)
        
        for i in 1...coordinates.count {
            let modelEntity = makeBubble(String(i))
            modelEntity.scale = SIMD3(repeating: modelScale)
            
            let textModelEntity = makeTextEntity(text: String(i))
            modelEntity.addChild(textModelEntity)
            
            coordinates = coordinates.shuffled()
            let coor = coordinates.popLast()!
            
            modelEntity.position = SIMD3<Float>(
                x: Float(coor.x),
                y: Float(coor.y),
                z: Float(coor.z)
            )
            
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.components.set(InputTargetComponent(allowedInputTypes: .all))
            addedChildList.append(modelEntity)
            contentEntity.addChild(modelEntity)
        }
        
        currentIndex = 1
        
        return contentEntity
    }
    
    func addParticleEntity(transForm: Transform, resetParticleClosure: @escaping (Entity) -> Void) {
        let particleEntity = Entity()
        var emitterComponent = ParticleEmitterComponent()
        
        let emitDuration = ParticleEmitterComponent.Timing.VariableDuration(duration: 1.0)
        emitterComponent.timing = .once(warmUp: nil, emit: emitDuration)
        emitterComponent.emitterShape = ParticleEmitterComponent.EmitterShape.sphere
        
        emitterComponent.speed = 1
        emitterComponent.mainEmitter.birthRate = 100
        emitterComponent.mainEmitter.color = .constant(.single(.white))
        
        particleEntity.components.set(emitterComponent)
        particleEntity.transform = transForm
        // 삭제시 파티클 이름으로 확인
        particleEntity.name = "particle"
        contentEntity.addChild(particleEntity)
        
        resetParticleClosure(particleEntity)
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
    
    private func makeCoordinates(row: Int = 3, minDistance: Float = 0.3) -> [EntityCoordinate] {
        var coordinates: [EntityCoordinate] = []
        
        let xRange: ClosedRange<Float> = -1.0...1.0
        let yRange: ClosedRange<Float> = 0.5...1.5
        // 내 뒤에까지 방울을 배치
        let zRange: ClosedRange<Float> = -1.0 ... 0.5
        
        for _ in 0..<countOfBubbles {
            var newEntityCoordinate: EntityCoordinate
            repeat {
                let randomX = Float.random(in: xRange)
                let randomY = Float.random(in: yRange)
                let randomZ = Float.random(in: zRange)
                newEntityCoordinate = EntityCoordinate(x: randomX, y: randomY, z: randomZ)
            } while isTooClose(newCoordinate: newEntityCoordinate, existingCoordinates: coordinates, minDistance: minDistance)
            
            coordinates.append(newEntityCoordinate)
        }
        return coordinates
    }
    
    private func isTooClose(newCoordinate: EntityCoordinate, existingCoordinates: [EntityCoordinate], minDistance: Float) -> Bool {
        for coordinate in existingCoordinates {
            let deltaX = abs(newCoordinate.x - coordinate.x)
            let deltaY = abs(newCoordinate.y - coordinate.y)
            let deltaZ = abs(newCoordinate.z - coordinate.z)
            
            // x, y, z 축 각각이 최소 거리 이상이어야 함
            if deltaX < minDistance && deltaY < minDistance && deltaZ < minDistance {
                return true
            }
        }
        return false
    }
    
    func didTapBubbleEntity(entity: Entity) {
        
        if entity.name == "index-\(currentIndex)" {
            entity.removeFromParent()
            for (idx, child) in addedChildList.enumerated() {
                if child.name == "index-\(currentIndex)" {
                    addedChildList.remove(at: idx)
                }
            }
            addParticleEntity (
                transForm: entity.transform
            ) { entity in
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 1.5
                ) {
                    entity.removeFromParent()
                }
            }
            if currentIndex == countOfBubbles {
                isAllBubbleTapped = true
            }
            currentIndex += 1

        } else {
            
            if let modelEntity = entity as? ModelEntity {
                let originalMaterials = modelEntity.model?.materials
                
                var clearRedMaterial = PhysicallyBasedMaterial()
                clearRedMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 5.0)
                clearRedMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.1))
                clearRedMaterial.baseColor = .init(tint: .red.withAlphaComponent(0.5))
                modelEntity.model?.materials = [clearRedMaterial]
                
                // 3초 뒤 원래대로
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    modelEntity.model?.materials = originalMaterials ?? []
                }
            }
        }
    }
}
