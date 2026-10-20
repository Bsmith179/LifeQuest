//
//  PersistenceTest.swift
//  LifeQuestTests
//
//  Created by Icy on 10/20/26.
//

import Testing
import Foundation

@testable import LifeQuest

@MainActor
struct PersistenceTests {
    
    let manager: LocalPersistenceManager
    let fakeClock: FakeClock
    let mockSession: URLSession
    
    init(){
        self.manager = LocalPersistenceManager()
        self.fakeClock = FakeClock(currentDate: Date.testEpoch)
        self.mockSession = URLSession.shared
    }
    
    @Test("Saves and Loads Payload Data", arguments: [
        ([] as [Quest], 0),
        ([Quest(title: "Test", categories: [StatCategory.strength], difficultyMultiplier: 2.0, frequency: QuestFrequency.daily)], 1),
        ([Quest(title: "Test", categories: [StatCategory.intelligence], difficultyMultiplier: 1.0, frequency: QuestFrequency.oneOff),
          Quest(title: "Test2", categories: [StatCategory.focus], difficultyMultiplier: 1.5, frequency: QuestFrequency.daily)], 2)
    ])
    func testPersistence_SavesAndLoadsPayloads(payload: [Quest], expectedCount: Int) throws {
        //Arrange
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? FileManager.default.removeItem(at: tempURL)
        }
        
        try manager.save(payload, to: tempURL)
        
        //Act
        let loadedPayload: [Quest] = try manager.load(from: tempURL)
        
        //Assert
        #expect(loadedPayload.count == expectedCount)
        #expect(loadedPayload == payload)
    }
    
    @Test("Test that Quest View Model saves and restores Quests")
    func testQuestViewModel_SavesAndRestoresState() async throws {
        //Arrange
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        defer {
            try? FileManager.default.removeItem(at: tempURL)
        }
        
        let questViewModelA = QuestViewModel(
            clock: fakeClock,
            session: mockSession,
            saveURL: tempURL
        )
        questViewModelA.activeQuests.removeAll()
        
        questViewModelA.createNewQuest(title: "Test", categories: [.strength], difficulty: 2.0, frequency: .daily)
        questViewModelA.saveData()
        
        //Act
        let questViewModelB = QuestViewModel(
            clock: fakeClock,
            session: mockSession,
            saveURL: tempURL
        )
        
        //Assert
        #expect(questViewModelB.activeQuests.count == 1)
        #expect(questViewModelB.activeQuests.first?.title == "Test")
        
    }
    
}
