//
//  ShopViewModelTest.swift
//  LifeQuestTests
//
//  Created by Icy on 9/22/26.
//

import Testing
@testable import LifeQuest

struct ShopViewModelTest {
    
    @Test("Created Reward gets added to list")
    func testCreateReward_AddToActiveList(){
        
        let sut = ShopViewModel()
        
        sut.createReward(name: "Test Reward", goldCost: 10)
        
        #expect(sut.availableRewards.count == 1)
        
    }
    
    @Test("No Duplicate rewards can be added")
    func testCreateReward_PreventDuplicates(){
        
        let sut = ShopViewModel()
        
        sut.createReward(name: "Test Reward", goldCost: 10)
        sut.createReward(name: "Test Reward", goldCost: 10)
        
        #expect(sut.availableRewards.count == 1)
        
    }
    
    @Test("Created Rewards cannot have a negative cost", arguments:
    [
        (50,50),
        (0,0),
        (-100,0)
    ])
    
    func testCreateReward_PreventsNegativeCosts(goldCost: Int, expectedCount: Int){
        
        let sut = ShopViewModel()
        
        sut.createReward(name: "Test Reward", goldCost: goldCost)
        
        let cost: Int = sut.availableRewards.first!.goldCost
        
        #expect(cost == expectedCount)
        #expect(cost >= 0)
    }
    
    @Test("Must have enough gold to purchase", arguments:
    [
        (49,false),
        (50,true),
        (150,true)
    ])
    
    func testPurchaseReward_PreventSequencBreaking(playerGold: Int, canAfford: Bool){
        let sut = ShopViewModel()
        sut.createReward(name: "Test Reward", goldCost: 50)
        let rewardID = sut.availableRewards.first!.id
        
        let ableToPurchase = sut.purchaseReward(rewardID: rewardID, currentGold: playerGold)
        
        #expect(ableToPurchase == canAfford)
    
    }
    
    @Test("Purchasing reward removes it from the list")
    
    func testPurchaseReward_REmovesFromAvailableList(){
        
        let sut = ShopViewModel()
        sut.createReward(name: "Test Reward", goldCost: 50)
        
        let rewardID = sut.availableRewards.first!.id
        
        _ = sut.purchaseReward(rewardID: rewardID, currentGold: 50)
        
        #expect(sut.availableRewards.count == 0)
    
    }
    
    
}
