//
//  ContentView.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(ContentViewModel.self) var viewModel: ContentViewModel
    @State private var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
//            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
//                content.add(scene)
//            }
            let bubbleEntity = viewModel.makeBubble("Welcome")
            bubbleEntity.scale = SIMD3(repeating: 1)
            let textModelEntity = viewModel.makeTextEntity(text: "Welcome", scale: 0.3)
            bubbleEntity.addChild(textModelEntity)

            content.add(bubbleEntity)
        } update: { content in
            
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        viewModel.immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        viewModel.immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if viewModel.immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    viewModel.immersiveSpaceIsShown = false
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack (spacing: 12) {
                    Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                    Button("Reset ImmersiveNumber") {
                        viewModel.isResetImmersiveContents = true
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
