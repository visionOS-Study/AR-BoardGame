//
//  TimerView.swift
//  AR-BoardGame
//
//  Created by Damin on 10/2/24.
//

import SwiftUI

struct TimerView: View {
    @Environment(ContentViewModel.self) var contentViewModel: ContentViewModel
    @Environment(TimerViewModel.self) var timerViewModel: TimerViewModel
    @Binding var showImmersiveSpace: Bool
    var body: some View {
        VStack {
            Text("Time: \(timerViewModel.formatTime())")
                .font(.largeTitle)
                .padding()
            
            VStack {
                
                Button{
                    timerViewModel.resetTimer()
                    contentViewModel.isResetImmersiveContents = true
                    timerViewModel.startTimer()
                } label: {
                    Text("Reset")
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button {
                    timerViewModel.stopTimer()
                    showImmersiveSpace = false
                } label: {
                    Text("Back to Home")
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

            }
        }
        .onAppear {
            timerViewModel.startTimer()
        }
        .onChange(of: contentViewModel.isAllBubbleTapped) { _, newValue in
            if newValue {
                timerViewModel.stopTimer()
                contentViewModel.isAllBubbleTapped = false
            }
            
        }
    }
}

