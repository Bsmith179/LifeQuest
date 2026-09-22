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
        
        #expect(cost == goldCost)
        #expect(cost >= 0)
    }
    
}
