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
    @State private var timerViewModel = TimerViewModel()
    @State private var showImmersiveSpace = false
    var body: some Scene {
        WindowGroup {
            ContentView(showImmersiveSpace: $showImmersiveSpace)
                .environment(contentViewMdoel)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(contentViewMdoel)
                .environment(timerViewModel)
        }
        
        WindowGroup(id: "TimerWindow") {
            TimerView(showImmersiveSpace: $showImmersiveSpace)
                .environment(contentViewMdoel)
                .environment(timerViewModel)
        }
    }
}
