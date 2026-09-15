//
//  CharacterViewModel.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
import Combine
 
class CharacterViewModel: ObservableObject {
    @Published var character = Character()
    let xpThreshold: Int = 1000
    
    

    func gainXp(amount: Int) {
        
    }
    
    func checkLevelUp() {
        
    }
    
    func addStat(category: StatCategory,  amount: Int) {
        let maxCap: Int = 99
        
        switch category {
        case .strength:
            character.strength = min(character.strength + amount, maxCap)
            break
            
        case .intelligence:
            character.intelligence += amount
            break
        case .charisma:
            character.charisma += amount
            break
        case .focus:
            character.focus += amount
            break
        }
    }
    
    func deductStat(category: StatCategory,  amount: Int) {
        
    }
}
