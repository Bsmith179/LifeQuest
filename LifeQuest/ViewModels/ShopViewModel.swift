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
        loadData()
    }
    
    func saveData(){
        do {
            try persistenceManager.save(availableRewards, to: saveURL)
        } catch {
            print("Failed to save rewards: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        do {
            availableRewards = try persistenceManager.load(from: saveURL)
        } catch {
            print("Failed to load rewards, starting with empty board: \(error.localizedDescription)")
        }
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
