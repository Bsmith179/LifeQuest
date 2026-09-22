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
    
    func createReward(name: String,  goldCost: Int) {
        var goldCost = goldCost
        goldCost = max(0, goldCost)
        if !availableRewards.contains(where: { $0.title == name}){
            
            let newReward = Reward(title: name, goldCost: goldCost)
            availableRewards.append(newReward)
        }
    }
    
    func purchaseReward(rewardID: UUID,  currentGold: Int) -> Bool {
        return false
    }
}
