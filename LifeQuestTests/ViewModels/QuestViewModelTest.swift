//
//  QuestViewModelTest.swift
//  LifeQuestTests
//
//  Created by Icy on 9/22/26.
//

import Testing
@testable import LifeQuest

struct QuestViewModelTest {
    
    @Test("Created quest gets added to active list")
    
    func testCreateNewQuest_AppendToActiveList(){
        let sut = QuestViewModel()
        
        sut.createNewQuest(title: "Test Quest", categories: [StatCategory.strength], difficulty: 2.0, frequency: QuestFrequency.daily)
        
        let quest = sut.activeQuests.first!
        #expect(!quest.isCompleted)
        #expect(sut.activeQuests.count == 1)
    }

    @Test("Cannot create a duplicate quest")
    
    func testCreateNewQuest_PreventDuplicates(){
        let sut = QuestViewModel()
        
        sut.createNewQuest(title: "Test Quest", categories: [StatCategory.strength], difficulty: 2.0, frequency: QuestFrequency.daily)
        
        sut.createNewQuest(title: "Test Quest", categories: [StatCategory.strength], difficulty: 2.0, frequency: QuestFrequency.daily)
        
        #expect(sut.activeQuests.count == 1)
    }
    
    @Test("Created quest has a difficulty between 1.0 and 5.0", arguments: [
        (0.0, 1.0),
        (3.0, 3.0),
        (5.0, 5.0),
        (10.0, 5.0)
    ])
    func testCreateNewQuest_ClampsDifficultyBoundaries(difficulty: Double, expected: Double){
        let sut = QuestViewModel()
        
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: difficulty, frequency: .daily)
        
        let quest = sut.activeQuests.first!
        #expect(quest.difficultyMultiplier == expected)
    }
    
    @Test("Created quest calculates Dynamic XP rewards", arguments: [
        (1.0, QuestFrequency.oneOff, 100),
        (2.0, QuestFrequency.daily, 300),
        (5.0, QuestFrequency.weekly, 1000),
    ])
    func testCreateNewQuest_CalculatesDynamicRewards(difficulty: Double, frequency: QuestFrequency, expectedXP: Int){
        let sut = QuestViewModel()
        
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: difficulty, frequency: frequency)
        
        let quest = sut.activeQuests.first!
        #expect(quest.earnedXP == expectedXP)
    }
    
    @Test("Created quest calculates Dynamic Gold", arguments: [
        (1.0, QuestFrequency.oneOff, 10),
        (2.0, QuestFrequency.daily, 30),
        (5.0, QuestFrequency.weekly, 100),
    ])
    func testCreateNewQuest_CalculatesDynamicGold(difficulty: Double, frequency: QuestFrequency, expectedGold: Int){
        let sut = QuestViewModel()
        
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: difficulty, frequency: frequency)
        
        let quest = sut.activeQuests.first!
        #expect(quest.earnedGold == expectedGold)
    }
}
