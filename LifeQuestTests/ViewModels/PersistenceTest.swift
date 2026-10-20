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
    
}
