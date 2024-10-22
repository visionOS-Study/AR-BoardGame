//
//  GameClearView.swift
//  AR-BoardGame
//
//  Created by dora on 10/22/24.
//

import SwiftUI
import RealityKit

struct GameClearView: View {
    let text = Array("Game Clear!")
    @State private var flipXYZ = Double.zero
    
    var body: some View {
        VStack(spacing: 32) {
            
            HStack(spacing: 0) {
                ForEach(0..<text.count, id: \.self) { index in
                    Text(String(text[index]))
                        .font(.system(size: 100, weight: .bold))
                        .rotation3DEffect(.degrees(flipXYZ), axis: (x: 1, y: 1, z: 1))
                        .animation(.default.delay(Double(index) * 0.1), value: flipXYZ)
                }
            }
            .rotation3DEffect(
                .degrees(flipXYZ),
                axis: (x: 1, y: 1, z: 1)
            )
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

#Preview(windowStyle: .volumetric) {
    GameClearView()
}
