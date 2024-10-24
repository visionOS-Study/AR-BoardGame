//
//  TimerView.swift
//  AR-BoardGame
//
//  Created by Damin on 10/2/24.
//

import SwiftUI

struct TimerView: View {
    @Bindable var contentViewModel: ContentViewModel
    @Environment(TimerViewModel.self) var timerViewModel: TimerViewModel
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showGameClear = true
    @State private var fadeOut = false
    
    var body: some View {
        VStack {
            if !contentViewModel.isAllBubbleTapped {
                Text("Time: \(timerViewModel.formatTime())")
                    .font(.largeTitle)
                    .padding()
                
                Text("Tap Bubble Number")
                    .font(.largeTitle)
                Text("\(contentViewModel.getCurrentIndex())")
                    .font(.extraLargeTitle)
                    .foregroundStyle(.red)
                    .padding()
                    .background {
                        Circle()
                            .strokeBorder()
                            .fill(.clear)
                        
                    }
            } else {
                
                if showGameClear {
                    GameClearView()
                        .opacity(fadeOut ? 0 : 1)
                        .onAppear {
                            timerViewModel.stopTimer()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.easeOut(duration: 2.0)) {
                                    fadeOut = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showGameClear = false
                                }
                            }
                        }
                } else {
                    TimeScoreView()
                }
                
            }
            
            
            Button{
                timerViewModel.resetTimer()
                contentViewModel.isResetImmersiveContents = true
                timerViewModel.startTimer()
            } label: {
                Text("Re-Start")
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button {
                dismissWindow(id: SceneID.WindowGroup.timer.id)
                timerViewModel.stopTimer()
                contentViewModel.resetContentEnityChild()
                openWindow(id: SceneID.WindowGroup.content.id)
                Task {
                    await dismissImmersiveSpace()
                }
            } label: {
                Text("Back to Home")
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .padding()
        
        .onChange(of: scenePhase) { _, newScenePhase in
            if newScenePhase == .background {
                timerViewModel.stopTimer()
                contentViewModel.resetContentEnityChild()
                openWindow(id: SceneID.WindowGroup.content.id)
                Task {
                    await dismissImmersiveSpace()
                }
            }
        }
        .onAppear {
            dismissWindow(id: SceneID.WindowGroup.content.id)
            Task {
                switch await openImmersiveSpace(id: SceneID.ImmersiveSpace.game.id) {
                case .opened:
                    debugPrint("ImmersiveSpace opened")
                case .error, .userCancelled:
                    fallthrough
                @unknown default:
                    break
                }
            }
            timerViewModel.startTimer()
        }
    }
}

