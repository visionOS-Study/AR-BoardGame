//
//  ImmersiveView.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(ContentViewModel.self) var viewModel: ContentViewModel
    @State private var root: Entity?
    
    var body: some View {
        RealityView (make: { content in
            guard let root else { return }
            content.add(root)
        }, update: { content in
            // RealityView Update 시 코드 구현
        })
        .onAppear {
            root = viewModel.setUpContentEntity()
        }
        .gesture(
            SpatialTapGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                
            }
            .onEnded { event in
                // 터치 엔터티 삭제
                event.entity.removeFromParent()
                viewModel.addParticleEntity(transForm: event.entity.transform) { entity in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        entity.removeFromParent()
                    }
                }
            }
        )
        .onChange(of: viewModel.isResetImmersiveContents) { _ ,newValue in
            if newValue {
                root = viewModel.setUpContentEntity()
                viewModel.isResetImmersiveContents = false
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
