//
//  Enums.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
 
enum QuestStatus: String, Equatable, Sendable, Codable {
    case active, completed, expired, abandoned, upcoming
}
enum SyncStatus: String, Equatable, Sendable, Codable {
    case synced
    case pending
}
enum StatCategory: String, Codable, CaseIterable {
    case intelligence, strength, focus, charisma
}
enum QuestFrequency: String, Codable, CaseIterable {
    case oneOff, daily, weekly
}
