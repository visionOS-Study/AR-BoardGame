//
//  TimeScoreView.swift
//  AR-BoardGame
//
//  Created by 규북 on 10/5/24.
//

import SwiftUI

struct TimeScoreView: View {
  var records: [Float]
  var currentRecord: Float
  
  var sortedRecords: [Float] {
    return (records + [currentRecord]).sorted()
  }
  
    var body: some View {
      VStack {
        Text("게임 기록")
          .font(.largeTitle)
          .padding()
        
        VStack(alignment: .leading, spacing: 10) {
          HStack {
            Text("이번 게임 시간 : ")
            Text("\(String(format: "%.2f", currentRecord)) 초")
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

            ForEach(0..<sortedRecords.count, id: \.self) { index in
              let record = sortedRecords[index]
              
              
                Text("\(index + 1)위 : \(String(format: "%.2f", sortedRecords[index])) 초")
              .frame(maxWidth: .infinity)
              .padding(.vertical, 4)
//              .background(record == currentRecord ? Color.yellow.opacity(0.5) : Color.clear)
              .font(record == currentRecord ? .headline : .body)
              .foregroundColor(record == currentRecord ? Color.red : Color.white)
              
            }
        }
        .listStyle(.inset)
        
        Spacer()
        
        Button("완료") {
          // 완료 버튼 액션
        }
        .padding()
        .buttonStyle(.borderedProminent)
      }
      
    }
}

#Preview {
  TimeScoreView(records: [10, 20, 30], currentRecord: 12.5)
}
