//
//  TimeScoreView.swift
//  AR-BoardGame
//
//  Created by 규북 on 10/5/24.
//

import SwiftUI

struct TimeScoreView: View {
    let dataManager = SwiftDataManager.shared
    @State private var currentRecord: Double = 0
    @State private var records: [Double] = []
    @Environment(TimerViewModel.self) var timerViewModel: TimerViewModel
  
    var body: some View {
      VStack {
        Text("Time Score Board")
          .font(.largeTitle)
          .padding()
        
        VStack(alignment: .leading, spacing: 10) {
          HStack {
            Text("This Game: ")
            Text("\(String(format: "%.2f", currentRecord)) seconds")
          }
          .padding()
          .font(.headline.bold())
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.red.opacity(0.5))
            .shadow(radius: 5)
        )
        
          List {
              ForEach(0..<records.count, id: \.self) { index in
                  let record = records[index]
                  Text("\(ordinalSuffix(of: index + 1)): \(String(format: "%.2f", record)) seconds")
                      .frame(maxWidth: .infinity)
                      .background(record == currentRecord ? Color.yellow.opacity(0.5) : Color.clear)
                      .padding(.vertical, 4)
                      .font(record == currentRecord ? .headline : .body)
                      .foregroundColor(record == currentRecord ? Color.red : Color.white)
              }
          }
          .listStyle(.inset)
      }
      .onAppear {
          let timeScore = timerViewModel.getTimeElaplsed()
          dataManager.createTimeRecord(
              TimeRecord(time: timeScore)
          )
          currentRecord = timeScore
          records = dataManager.fetchTimeRecord(sortBy: .time).map(\.time)
        }
      
    }
    
    func ordinalSuffix(of number: Int) -> String {
        let suffix: String
        let ones = number % 10
        let tens = (number / 10) % 10

        if tens == 1 {
            suffix = "th"
        } else {
            switch ones {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                suffix = "th"
            }
        }
        
        return "\(number)\(suffix)"
    }
}
