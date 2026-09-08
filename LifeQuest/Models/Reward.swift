//
//  Reward.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
 
struct Reward: Identifiable {
    let id = UUID()
    var title: String
    var goldCost: Int
}
