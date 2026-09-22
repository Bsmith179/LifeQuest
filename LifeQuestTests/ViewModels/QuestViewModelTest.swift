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
}
