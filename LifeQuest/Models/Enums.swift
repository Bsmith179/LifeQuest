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
enum StatCategory: String, Codable {
    case intelligence, strength, focus, charisma
}
enum QuestFrequency: String, Codable {
    case oneOff, daily, weekly
}
