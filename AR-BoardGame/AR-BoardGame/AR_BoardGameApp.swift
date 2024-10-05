//
//  AR_BoardGameApp.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI

@main
struct AR_BoardGameApp: App {
    
    @State private var contentViewModoel = ContentViewModel()
    @State private var timerViewModel = TimerViewModel()
    
    var body: some Scene {
        WindowGroup(id: "ContentWindow") {
            ContentView(contentViewModel: contentViewModoel)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(contentViewModoel)
        }
        
        WindowGroup(id: "TimerWindow") {
            TimerView(contentViewModel: contentViewModoel)
                .environment(timerViewModel)
        }
    }
}
