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
    var timerWindowSize: CGSize = CGSize(width: 800, height: 600)
    
    var body: some Scene {
        WindowGroup(id: SceneID.WindowGroup.content.id) {
            ContentView(contentViewModel: contentViewModel)
        }
        .windowStyle(.volumetric)
        .windowResizability(.contentSize)

        ImmersiveSpace(id: SceneID.ImmersiveSpace.game.id) {
            ImmersiveView()
                .environment(contentViewModel)
                .preferredSurroundingsEffect(.dark)
                
        }
        
        WindowGroup(id: SceneID.WindowGroup.timer.id) {
            TimerView(contentViewModel: contentViewModel)
                .environment(timerViewModel)
        }
        .defaultSize(width: timerWindowSize.width, height: timerWindowSize.height)
        
        WindowGroup(id: SceneID.WindowGroup.alert.id) {
            AlertView()
        }
        .windowResizability(.contentSize)
        .persistentSystemOverlays(.hidden)
        
    }
}
