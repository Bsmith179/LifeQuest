//
//  GameIntegrationTest.swift
//  LifeQuestTests
//
//  Created by Icy on 9/22/26.
//

import Testing
@testable import LifeQuest

struct GameIntegrationTest {
    
    @Test("Integrate quest completion with Character's XP, Gold, and stats", arguments:
            [
                (1.0, QuestFrequency.oneOff, [StatCategory.strength], 1, 100, 10, 1),
                (2.0, QuestFrequency.daily, [StatCategory.strength, StatCategory.focus], 1, 300, 30, 1),
                (5.0, QuestFrequency.weekly, [StatCategory.strength, StatCategory.focus, StatCategory.intelligence, StatCategory.charisma], 2, 0, 100, 2)
            ])
    
    func testQuestCompletion_AwardsCharacterXPGoldAndStats(difficulty: Double, frequency: QuestFrequency, categories: [StatCategory], expectedLevel: Int, expectedXP: Int, expectedGold: Int, expectedStat: Int){
        let characterVM = CharacterViewModel()
        let questVM = QuestViewModel()
        questVM.createNewQuest(title: "Test Quest", categories: categories, difficulty: difficulty, frequency: frequency)
        let quest = questVM.activeQuests.first!
        
        _ = questVM.completeQuest(questID: quest.id)
        characterVM.gainXP(amount: quest.earnedXP)
        for category in quest.categories {
            characterVM.addStat(category: category, amount: quest.earnedStat)
        }
        characterVM.addGold(amount: quest.earnedGold)
        
        #expect(characterVM.character.currentXP == expectedXP)
        #expect(characterVM.character.level == expectedLevel)
        #expect(characterVM.character.gold == expectedGold)
        for category in quest.categories {
            switch category {
            case .strength:
                #expect(characterVM.character.strength == expectedStat)
            case .focus:
                #expect(characterVM.character.focus == expectedStat)
            case .intelligence:
                #expect(characterVM.character.intelligence == expectedStat)
            case .charisma:
                #expect(characterVM.character.charisma == expectedStat)
            }
            
        }
    }
    
    @Test("Complete multiple quests to check power leveling", arguments:
            [
                (4,0,300,20,10)
            ])
    func testCompleteMultipleQuests_TriggersPowerLeveling(expectedLevel: Int, expectedXP: Int, expectedGold: Int, expectedStrengthStat: Int, expectedFocusStat: Int) {
        let characterVM = CharacterViewModel()
        let questVM = QuestViewModel()
        
        
        
        for value in 1...3 {
            if value % 2 == 0 {
                questVM.createNewQuest(title: "Quest \(value)", categories: [.focus], difficulty: 5.0, frequency: .weekly)
            }
            else{
                questVM.createNewQuest(title: "Quest \(value)", categories: [.strength], difficulty: 5.0, frequency: .weekly)
            }
        }
        
        questVM.activeQuests.forEach({
            _ = questVM.completeQuest(questID: $0.id)
            characterVM.gainXP(amount: $0.earnedXP)
            for category in $0.categories {
                characterVM.addStat(category: category, amount: $0.earnedStat)
            }
            characterVM.addGold(amount: $0.earnedGold)
        })
        
        #expect(characterVM.character.currentXP == expectedXP)
        #expect(characterVM.character.level == expectedLevel)
        #expect(characterVM.character.gold == expectedGold)
        #expect(characterVM.character.strength == expectedStrengthStat)
        #expect(characterVM.character.focus == expectedFocusStat)
        #expect(characterVM.character.intelligence == 0)
        #expect(characterVM.character.charisma == 0)
    }
    
    @Test("Failed Purchase doesn't affect Character's gold")
    func testFailedPurchase_ProtectsCharacterGold() {
        let characterVM = CharacterViewModel()
        let shopVM = ShopViewModel()
        characterVM.addGold(amount: 10)
        shopVM.createReward(name: "Test Reward", goldCost: 500)
        let reward = shopVM.availableRewards.first!
        
        _ = shopVM.purchaseReward(rewardID: reward.id, currentGold: characterVM.character.gold)
        
        #expect(characterVM.character.gold == 10)
        #expect(shopVM.availableRewards.count == 1)
        
    }
}
