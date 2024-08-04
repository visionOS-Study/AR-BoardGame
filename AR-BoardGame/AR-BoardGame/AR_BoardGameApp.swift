//
//  AR_BoardGameApp.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI

@main
struct AR_BoardGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
