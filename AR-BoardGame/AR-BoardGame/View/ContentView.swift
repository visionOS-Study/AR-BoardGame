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
    @Environment(ContentViewModel.self) var viewModel: ContentViewModel
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Binding var showImmersiveSpace: Bool
    
    var body: some View {
        RealityView { content in
            let bubbleEntity = viewModel.makeBubble("Welcome")
            bubbleEntity.scale = SIMD3(repeating: 1)
            let textModelEntity = viewModel.makeTextEntity(text: "Welcome", scale: 0.3)
            bubbleEntity.addChild(textModelEntity)
            bubbleEntity.position = SIMD3<Float>(x: bubbleEntity.position.x, y: bubbleEntity.position.y - 0.1, z: bubbleEntity.position.z + 0.1)
            content.add(bubbleEntity)
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    openWindow(id: "TimerWindow")
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        debugPrint("ImmersiveSpace opened")
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        showImmersiveSpace = false
                    }
                } else {
                    dismissWindow(id: "TimerWindow")
                    await dismissImmersiveSpace()
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                Toggle("Start Game", isOn: $showImmersiveSpace)
            }
        }
    }
}

