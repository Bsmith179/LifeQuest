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
    var category: StatCategory
    var difficultyMultiplier: Double
    var frequency: QuestFrequency
    var isCompleted: Bool = false
}
