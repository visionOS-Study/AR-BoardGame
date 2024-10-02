//
//  GameClearTextView.swift
//  AR-BoardGame
//
//  Created by dora on 10/2/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GameClearTextView: View {
    let text = Array("Game Clear!")
    @State private var flipAngle = Double.zero
    
    @State private var flipXYZ = Double.zero
    
    var body: some View {
        
        ZStack{
            Model3D(named: "Scene", bundle: realityKitContentBundle)
            
            VStack(spacing: 32) {
                
                HStack(spacing: 0) {
                    ForEach(0..<text.count, id: \.self) { flip in
                        Text(String(text[flip]))
                            .font(.largeTitle)
                            .rotation3DEffect(.degrees(flipXYZ), axis: (x: 1, y: 1, z: 1))
                            .animation(.default.delay(Double(flip) * 0.1), value: flipXYZ)
                    }
                }
                .rotation3DEffect(
                    .degrees(flipXYZ),
                    axis: (x: 1, y: 1, z: 1) // Only flip on the Z-axis
                )
                
                Button {
                    withAnimation(.bouncy) {
                        flipXYZ = (flipXYZ == .zero) ? 360 : .zero
                    }
                } label: {
                    Text("FlipXYZ")
                }
            }
        }
        
    }
}

#Preview {
    GameClearTextView()
}
