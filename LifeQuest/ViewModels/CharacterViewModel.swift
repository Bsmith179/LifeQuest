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
    
    func gainXp(amount: Int) {}
    func checkLevelUp() {}
    func addStat(category: StatCategory,  amount: Int) {}
    func deductStat(category: StatCategory,  amount: Int) {}
}
