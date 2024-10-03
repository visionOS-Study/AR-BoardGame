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
    @State private var flipXYZ = Double.zero
    
    var body: some View {
        ZStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
            
            VStack(spacing: 32) {
                
                HStack(spacing: 0) {
                    ForEach(0..<text.count, id: \.self) { flip in
                        Text(String(text[flip]))
                            .font(.system(size: 100, weight: .bold))
                            .rotation3DEffect(.degrees(flipXYZ), axis: (x: 1, y: 1, z: 1))
                            .animation(.default.delay(Double(flip) * 0.1), value: flipXYZ)
                    }
                }
                .rotation3DEffect(
                    .degrees(flipXYZ),
                    axis: (x: 1, y: 1, z: 1)
                )
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                withAnimation(.bouncy) {
                    flipXYZ = (flipXYZ == .zero) ? 360 : .zero
                }
            }
        }
    }
}

#Preview {
    GameClearTextView()
}

