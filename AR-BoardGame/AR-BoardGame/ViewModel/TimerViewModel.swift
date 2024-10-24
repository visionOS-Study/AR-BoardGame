//
//  TimerViewModel.swift
//  AR-BoardGame
//
//  Created by Damin on 10/2/24.
//

import SwiftUI

@Observable
class TimerViewModel {
    private var timeElapsed: TimeInterval = 0
    private var timer: Timer?
    private var startDate: Date?
    
    func startTimer() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let startDate = self?.startDate else { return }
            self?.timeElapsed = Date().timeIntervalSince(startDate)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        timeElapsed = 0
        stopTimer()
    }

    func formatTime() -> String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        let milliseconds = Int((timeElapsed - Double(Int(timeElapsed))) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    func getTimeElaplsed() -> Double {
        return timeElapsed
    }
}
