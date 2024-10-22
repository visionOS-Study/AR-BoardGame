//
//  FireworkView.swift
//  AR-BoardGame
//
//  Created by dora on 10/22/24.
//

import SwiftUI
import RealityKit

struct FireworkView: View {
    @State private var flipXYZ = Array(repeating: Double.zero, count: 12)
    
    var body: some View {
        GeometryReader3D { geometry in
            RealityView { content in
                let radius: Float = 0.3
                let angleIncrement = 360.0 / 6.0
                
                for i in 0..<6 {
                    let angle = Float(i) * Float(angleIncrement) * .pi / 180
                    
                    let firework = fireworkEntity
                    firework.position.x = radius * cos(angle)
                    firework.position.y = radius * sin(angle) - 0.1
                    firework.position.z = -0.1
                    
                    content.add(firework)
                }

                let text = Array("Game Clear!")
                
                for (index, char) in text.enumerated() {
                    let textEntity = createTextEntity(String(char))
                    textEntity.scale = [0.1, 0.1, 0.1]
                    textEntity.position = [Float(index) * 0.07 - 0.3, 0, 0.1]
                    content.add(textEntity)
                    
                    rotateTextEntity(to: textEntity, index: index)
                }
            }
        }
    }
    
    
    var fireworkEntity: Entity {
        var firework = ParticleEmitterComponent.Presets.fireworks
        firework.mainEmitter.birthRate = 2
        
        let entity = Entity()
        entity.components.set(firework)
        
        return entity
    }
    
   
    func createTextEntity(_ text: String) -> ModelEntity {
        let mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.05,
            font: .systemFont(ofSize: CGFloat(0.5)),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
        
        let material = SimpleMaterial(color: .black, isMetallic: false)
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        return textEntity
    }
    
 
    func rotateTextEntity(to entity: ModelEntity, index: Int) {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            withAnimation {
                entity.transform.rotation = simd_quatf(angle: Float(flipXYZ[index]), axis: SIMD3(x: 0, y: 1, z: 0))
                flipXYZ[index] += 0.1
            }
        }
    }
}

#Preview (windowStyle: .volumetric){
    FireworkView()
}






