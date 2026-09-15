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
    
    func gainXP(amount: Int) {
        var amount = amount
        amount = max(0,amount)
        character.currentXP += amount
        checkLevelUp()
    }
    

    func checkLevelUp() {
        while character.currentXP >= xpThreshold {
            character.currentXP -= xpThreshold
            character.level += 1
        }
    }
    func addStat(category: StatCategory,  amount: Int) {
        var amount = amount
        let maxCap: Int = 99
        
        amount = max(0,amount)
        
        switch category {
        case .strength:
            character.strength = min(character.strength + amount, maxCap)
            break
            
        case .intelligence:
            character.intelligence = min(character.intelligence + amount, maxCap)
            break
            
        case .charisma:
            character.charisma = min(character.charisma + amount, maxCap)
            break
            
        case .focus:
            character.focus = min(character.focus + amount, maxCap)
            break
        }
    }
    
    func deductStat(category: StatCategory,  amount: Int) {
        var amount = amount
        amount = max(0,amount)
        
        switch category {
        case .strength:
            character.strength = max(character.strength - amount, 0)
            break
            
        case .intelligence:
            character.intelligence = max(character.intelligence - amount, 0)
            break
            
        case .charisma:
            character.charisma = max(character.charisma - amount, 0)
            break
            
        case .focus:
            character.focus = max(character.focus - amount, 0)
            break
        }
    }
    
    func addGold(amount: Int){
        
    }
    
    func deductGold(amount: Int){
        
    }
}
