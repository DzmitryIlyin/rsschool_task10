//
//  GameState.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 9/2/21.
//

import Foundation

class GameState: Codable {
    
    
    var gameCondition: GameCondition?
    var savedCardIndex: Int = 0
    var playerCards: [PlayerCard]?
    
    private static var singletonInstance: GameState!
    
    class var sharedInstance: GameState! {
            get {
                singletonInstance = singletonInstance ?? GameState()
                return singletonInstance
            }
        }

    private init() {
        if let gameState = getFromUserDefaults() {
            self.savedCardIndex = gameState.savedCardIndex
            self.gameCondition = gameState.gameCondition
            self.playerCards = gameState.playerCards
        }
    }
    
    private func getFromUserDefaults() -> GameState? {
        if let data = UserDefaults.standard.data(forKey: "gameState") {
            if let value = try? PropertyListDecoder().decode(GameState.self, from: data) {
                print("getFromUserDefaults")
                return value
            }
        }
        return nil
    }
    

}

extension GameState: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

enum GameCondition: String, Codable {
    
    case new
    case inProgress
}
