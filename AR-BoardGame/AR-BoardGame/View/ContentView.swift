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
    @State private var welcomeEntity = Entity()
    
    var body: some View {
        RealityView { content in
            let bubbleEntity = contentViewModel.makeBubble("Welcome")
            let textModelEntity = contentViewModel.makeTextEntity(text: "Welcome", scale: 0.3)
            bubbleEntity.addChild(textModelEntity)
            welcomeEntity.addChild(bubbleEntity)
            content.add(welcomeEntity)
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    
                }
                .onEnded { event in
                    if event.entity.name == "Welcome" {
                        let particleEntity = contentViewModel.addParticleEntity(transForm: event.entity.transform) { particleEntity in
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1.5
                            ) {
                                particleEntity.removeFromParent()
                                openWindow(id: SceneID.WindowGroup.timer.id)
                            }
                        }
                        event.entity.removeFromParent()
                        welcomeEntity.addChild(particleEntity)
                    }
                }
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                Text("Tap Welcome Bubble!")

            }
        }
    }
}

