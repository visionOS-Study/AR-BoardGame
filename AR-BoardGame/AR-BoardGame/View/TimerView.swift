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
                TimeScoreView()
                    .onAppear {
                        timerViewModel.stopTimer()
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

