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

extension Quest {
    static var dailyMock: Quest {
        Quest(title: "Test",
              categories: [.strength],
              difficultyMultiplier: 1.5,
              frequency: .daily,
              status: .active,
              earnedXP: 150,
              earnedGold: 15,
              earnedStat: 1,
              startDate: Date(),
              endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
              streak: 5,
              syncStatus: .pending)
    }
    
    static var oneOffMock: Quest {
        Quest(title: "Test",
              categories: [.strength],
              difficultyMultiplier: 1.5,
              frequency: .oneOff,
              status: .active,
              earnedXP: 150,
              earnedGold: 15,
              earnedStat: 1,
              startDate: Date(),
              endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
              streak: nil,
              syncStatus: .pending)
    }
    
    static var dailyUpcomingMock: Quest {
        Quest(title: "Test",
              categories: [.strength],
              difficultyMultiplier: 1.5,
              frequency: .daily,
              status: .upcoming,
              earnedXP: 150,
              earnedGold: 15,
              earnedStat: 1,
              startDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
              endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
              syncStatus: .pending)
    }
    
    static var dailyCompletedMock: Quest {
        Quest(title: "Test",
              categories: [.strength],
              difficultyMultiplier: 1.5,
              frequency: .daily,
              status: .completed,
              earnedXP: 150,
              earnedGold: 15,
              earnedStat: 1,
              syncStatus: .pending)
    }
    
    static var dailyAbandonedMock: Quest {
        Quest(title: "Test",
              categories: [.strength],
              difficultyMultiplier: 1.5,
              frequency: .daily,
              status: .abandoned,
              earnedXP: 150,
              earnedGold: 15,
              earnedStat: 1,
              endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
              streak: -10,
              syncStatus: .pending)
    }
}
