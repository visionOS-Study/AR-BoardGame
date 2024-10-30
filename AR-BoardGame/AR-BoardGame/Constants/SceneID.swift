//
//  SceneID.swift
//  AR-BoardGame
//
//  Created by Damin on 10/8/24.
//

// SceneID.swift
enum SceneID {
  enum WindowGroup {
      case content
      case timer
      case alert
      var id: String {
          switch self {
          case .content: return "Content"
          case .timer: return "Timer"
          case .alert: return "Alert"
          }
      }
  }
    
    enum ImmersiveSpace {
        case game
        var id: String {
      switch self {
      case .game: return "Game"
      }
    }
  }
}
