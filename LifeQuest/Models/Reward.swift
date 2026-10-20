//
//  Reward.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import Foundation

struct Reward: Identifiable, Codable, Equatable, Sendable {
    let id:  UUID
    var title: String
    var goldCost: Int
    init(id: UUID = UUID(),
         title: String,
         goldCost: Int){
        self.id = id
        self.title = title
        self.goldCost = goldCost
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case goldCost = "goldCost"
    }
    
}
