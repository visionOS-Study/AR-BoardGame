//
//  AlertView.swift
//  AR-BoardGame
//
//  Created by Damin on 10/30/24.
//

import SwiftUI

struct AlertView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        VStack {
            Text("Are You Ready to Play Bubble Pop?")
                .font(.title)
            Text("Please Check Your Surroundings before Starting")
                .font(.subheadline)
            Button("Start") {
                openWindow(id: SceneID.WindowGroup.timer.id)
            }
        }
        .padding(40)
        .glassBackgroundEffect()
        .onAppear {
            dismissWindow(id: SceneID.WindowGroup.content.id)
        }
    }
}

#Preview {
    AlertView()
}
