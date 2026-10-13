//
//  Quest.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation

enum QuestStatus: String, Equatable, Sendable {
    case active, completed, expired, abandoned, upcoming
}

enum SyncStatus: Equatable, Sendable {
    case synced
    case pending
}

struct Quest: Identifiable {
    let id = UUID()
    var title: String
    var categories: [StatCategory]
    var difficultyMultiplier: Double
    var frequency: QuestFrequency
    var status: QuestStatus = .active
    var startDate: Date? = nil
    var endDate: Date? = nil
    var streak: Int? = nil
    
    var earnedXP : Int = 0
    var earnedGold : Int = 0
    var earnedStat : Int = 0
    
    var syncStatus: SyncStatus = .pending
}
