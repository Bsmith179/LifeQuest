//
//  Quest.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
 
struct Quest: Identifiable {
    let id = UUID()
    var title: String
    var categories: [StatCategory]
    var difficultyMultiplier: Double
    var frequency: QuestFrequency
    var isCompleted: Bool = false
    
    var earnedXP : Int = 0
    var earnedGold : Int = 0
    var earnedStat : Int = 0
}
