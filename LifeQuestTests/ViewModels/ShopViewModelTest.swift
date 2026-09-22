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

}
