//
//  ContentView.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Bindable var contentViewModel: ContentViewModel
    @State private var contentEntity = Entity()
    
    var body: some View {
        RealityView { content in
            let bubbleEntity = contentViewModel.makeBubble("Welcome")
            bubbleEntity.scale = SIMD3(repeating: 1)
            let textModelEntity = contentViewModel.makeTextEntity(text: "Welcome", scale: 0.3)
            bubbleEntity.addChild(textModelEntity)
            bubbleEntity.position = SIMD3<Float>(x: bubbleEntity.position.x, y: bubbleEntity.position.y - 0.1, z: bubbleEntity.position.z + 0.1)
            bubbleEntity.generateCollisionShapes(recursive: true)
            let inputTargetComponent = InputTargetComponent(allowedInputTypes: .all)
            let hoverEffectComponent = HoverEffectComponent()
            bubbleEntity.components.set([inputTargetComponent, hoverEffectComponent])
            bubbleEntity.name = "Welcome"
            contentEntity.addChild(bubbleEntity)
            content.add(contentEntity)
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    
                }
                .onEnded { event in
                    if event.entity.name == "Welcome" {
                        let particleEntity = addParticleEntity(transForm: event.entity.transform)
                        contentEntity.children.forEach {
                            if $0.name == "Welcome" {
                                $0.removeFromParent()
                            }
                        }
                        contentEntity.addChild(particleEntity)
                        
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 1.5
                        ) {
                            particleEntity.removeFromParent()
                            openWindow(id: "TimerWindow")
                        }
                        
                    }
                }
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                Text("Tap Welcome Bubble!")

            }
        }
    }
    private func addParticleEntity(transForm: Transform) -> Entity {
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
        return particleEntity
    }
}

