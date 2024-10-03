//
//  AR_BoardGameApp.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI

@main
struct AR_BoardGameApp: App {
    
    @State private var contentViewMdoel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            GameClearTextView()
            //ContentView()
                .environment(contentViewMdoel)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(contentViewMdoel)
        }
    }
}
