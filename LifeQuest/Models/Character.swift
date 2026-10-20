//
//  Character.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import Foundation
 
struct Character: Codable, Equatable, Sendable {
 
    var level: Int
    var currentXP: Int
    var gold: Int
 
    var intelligence: Int
    var strength: Int
    var charisma: Int
    var focus: Int
 
    init(level: Int = 1,
         currentXP: Int = 0,
         gold: Int = 0,
         intelligence: Int = 0,
         strength: Int = 0,
         charisma: Int = 0,
         focus: Int = 0){
 
        self.level = level
        self.currentXP = currentXP
        self.gold = gold
        self.intelligence = intelligence
        self.strength = strength
        self.charisma = charisma
        self.focus = focus
    }
 
    enum CodingKeys: String, CodingKey {
        case level = "level"
        case currentXP = "currentXP"
        case gold = "gold"
        case intelligence = "intelligence"
        case strength = "strength"
        case charisma = "charisma"
        case focus = "focus"
    }
 
}
