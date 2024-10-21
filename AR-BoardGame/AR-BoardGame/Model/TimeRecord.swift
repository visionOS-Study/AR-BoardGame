//
//  TimeRecord.swift
//  AR-BoardGame
//
//  Created by 이정동 on 10/4/24.
//

import Foundation
import SwiftData

@Model
final class TimeRecord {
  @Attribute(.unique) var date: Date = Date()
  var time: Double
  
  init(time: Double) {
    self.time = time
  }
}
