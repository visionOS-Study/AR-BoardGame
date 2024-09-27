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
    
    @State private var currentNumber = 0   // 터뜨려야 하는 방울 번호
    
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
                    if let bubbleNumber = Int(event.entity.name.split(separator: "-").last ?? "") {
                        // currentNum과 bubbleNum 비교
                        if bubbleNumber == currentNumber {
                            // 제대로 누른 경우
                            event.entity.removeFromParent()
                            viewModel.addParticleEntity(transForm: event.entity.transform) { entity in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    entity.removeFromParent()
                                }
                                currentNumber += 1
                            }
                        } else {
                            // 잘못 누른 경우
                            if let modelEntity = event.entity as? ModelEntity {
                                let originalMaterials = modelEntity.model?.materials
                                
                                var clearRedMaterial = PhysicallyBasedMaterial()
                                clearRedMaterial.clearcoat = PhysicallyBasedMaterial.Clearcoat(floatLiteral: 5.0)
                                clearRedMaterial.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(scale: 0.1))
                                clearRedMaterial.baseColor = .init(tint: .red.withAlphaComponent(0.5))
                                modelEntity.model?.materials = [clearRedMaterial]
                                
                                // 3초 뒤 원래대로
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    modelEntity.model?.materials = originalMaterials ?? []
                                }
                            }
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
