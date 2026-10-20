//
//  ShopViewModel.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
import Combine
 
class ShopViewModel: ObservableObject {
    
    @Published var availableRewards: [Reward]
        private let persistenceManager = LocalPersistenceManager()
        private let saveURL: URL
     
        init(saveURL: URL? = nil){
            if let customURL = saveURL {
                self.saveURL = customURL
            } else {
                self.saveURL = LocalPersistenceManager.documentsURL(for: "rewards.json")
            }
     
            availableRewards = []
        }
     
    func saveData(){
            print("SaveData() called but not yet implemented")
        }
     
     func loadData(){
            print("loadData() called but not yet implemented")
        }
    
    func createReward(name: String,  goldCost: Int) {
        var goldCost = goldCost
        goldCost = max(0, goldCost)
        if !availableRewards.contains(where: { $0.title == name}){
            
            let newReward = Reward(title: name, goldCost: goldCost)
            availableRewards.append(newReward)
        }
    }
    
    func purchaseReward(rewardID: UUID,  currentGold: Int) -> Bool {
        let reward = availableRewards.first(where: { $0.id == rewardID})
        if let reward, currentGold >= reward.goldCost {
            availableRewards.removeAll(where:{ $0.id == rewardID })
            return true
        }
        return false
    }
}
