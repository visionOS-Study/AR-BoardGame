//
//  AR_BoardGameApp.swift
//  AR-BoardGame
//
//  Created by Damin on 8/4/24.
//

import SwiftUI

@main
struct AR_BoardGameApp: App {
    
    @State private var contentViewModel = ContentViewModel()
    @State private var timerViewModel = TimerViewModel()
    var timerWindowSize: CGSize = CGSize(width: 600, height: 900)
    
    var body: some Scene {
        WindowGroup(id: SceneID.WindowGroup.content.id) {
            ContentView(contentViewModel: contentViewModel)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: SceneID.ImmersiveSpace.game.id) {
            ImmersiveView()
                .environment(contentViewModel)
        }
        
        WindowGroup(id: SceneID.WindowGroup.timer.id) {
            TimerView(contentViewModel: contentViewModel)
                .environment(timerViewModel)
        }
        .defaultSize(width: timerWindowSize.width, height: timerWindowSize.height)
    }
}
