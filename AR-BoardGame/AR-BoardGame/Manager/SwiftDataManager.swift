//
//  SwiftDataManager.swift
//  AR-BoardGame
//
//  Created by 이정동 on 10/4/24.
//

import Foundation
import SwiftData

final class SwiftDataManager {
  static let shared = SwiftDataManager()
  private init() {}
  
  enum SortType {
    case date
    case time
  }
  
  private let modelContext: ModelContext = {
    let schema = Schema([TimeRecord.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
    do {
      let container = try ModelContainer(for: schema, configurations: [configuration])
      return ModelContext(container)
    } catch {
      print("ModelCOntext Error")
      fatalError(error.localizedDescription)
    }
  }()
}

extension SwiftDataManager {
  func createTimeRecord(_ timeRecord: TimeRecord) {
    self.modelContext.insert(timeRecord)
  }
  
  func fetchTimeRecord(sortBy: SortType) -> [TimeRecord] {
    let sort = sortBy == .date
    ? SortDescriptor(\TimeRecord.date, order: .reverse)
    : SortDescriptor(\TimeRecord.time, order: .reverse)
    
    let descriptor = FetchDescriptor(sortBy: [sort])
    
    let datas = try? modelContext.fetch(descriptor)
    return datas ?? []
  }
}
