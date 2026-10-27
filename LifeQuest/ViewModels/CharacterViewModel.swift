//
//  CharacterViewModel.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
import Combine

class CharacterViewModel: ObservableObject {
    @Published var character: Character
    let xpThreshold: Int = 1000
    let goldThreshold: Int = 99999
    
    private let persistenceManager = LocalPersistenceManager()
    private let saveURL: URL
    
    init(saveURL: URL? = nil){
        if let customURL = saveURL {
            self.saveURL = customURL
        } else {
            self.saveURL = LocalPersistenceManager.documentsURL(for: "character.json")
        }
        character = Character()
        loadData()
    }
    
    func saveData(){
        do {
            try persistenceManager.save(character, to: saveURL)
        } catch {
            print("Failed to save character data \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        do {
            character = try persistenceManager.load(from: saveURL)
        } catch {
            print("No character data found, starting with default")
        }
    }
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
    
    func applyDrain(XPAmount: Int){
        character.currentXP -= XPAmount
        
        if character.currentXP < 0 {
            character.currentXP = 0
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
        var amount = amount
        amount = max(amount, 0)
        character.gold = min(character.gold + amount, goldThreshold)
    }
    
    func deductGold(amount: Int){
        var amount = amount
        amount = max(amount, 0)
        character.gold = max(character.gold - amount, 0)
    }
}
