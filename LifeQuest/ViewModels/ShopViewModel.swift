//
//  ShopViewModel.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
import Combine
 
class ShopViewModel: ObservableObject {
    @Published var availableRewards: [Reward] = []
    
    func createReward(name: String,  goldCost: Int) {}
    func purchaseReward(rewardID: UUID,  currentGold: Int) -> Bool {
        return false
    }
}
