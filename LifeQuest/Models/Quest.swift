//
//  Quest.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import Foundation
 
struct Quest: Identifiable, Equatable, Sendable, Codable {
    let id: UUID
    var title: String
    var categories: [StatCategory]
    var difficultyMultiplier: Double
    var frequency: QuestFrequency
    var status: QuestStatus
    
    var earnedXP: Int
    var earnedGold: Int
    var earnedStat: Int
    
    var startDate: Date?
    var endDate: Date?
    var streak: Int?
    
    var syncStatus: SyncStatus
    
    init(
id: UUID = UUID(),
title: String,
categories: [StatCategory],
difficultyMultiplier: Double,
frequency: QuestFrequency,
status: QuestStatus = .active,
earnedXP: Int = 0,
earnedGold: Int = 0,
earnedStat: Int = 0,
startDate: Date? = nil,
endDate: Date? = nil,
streak: Int? = nil,
syncStatus: SyncStatus = .pending) {
        self.id = id
        self.title = title
        self.categories = categories
        self.difficultyMultiplier = difficultyMultiplier
        self.frequency = frequency
        self.status = status
        self.earnedXP = earnedXP
        self.earnedGold = earnedGold
        self.earnedStat = earnedStat
        self.startDate = startDate
        self.endDate = endDate
        self.streak = streak
        self.syncStatus = syncStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case categories = "categories"
        case difficultyMultiplier = "difficultyMultiplier"
        case frequency = "frequency"
        case status = "status"
        case earnedXP = "earnedXP"
        case earnedGold = "earnedGold"
        case earnedStat = "earnedStat"
        case startDate = "startDate"
        case endDate = "endDate"
        case streak = "streak"
        case syncStatus = "syncStatus"
    }
}
