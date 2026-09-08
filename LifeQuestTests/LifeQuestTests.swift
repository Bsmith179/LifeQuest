//
//  LifeQuestTests.swift
//  LifeQuestTests
//
//  Created by Icy on 9/8/26.
//

import Testing
@testable import LifeQuest

struct LifeQuestTests {
    
    @Test("Test Can Run")
    func testEnvironment_IsRunningTests(){
        #expect(true,"This test always passes")
    }
    
    @Test("MVVM Is Setup And Ready For Testing")
    func testEnvironment_IsConfiguredAndRunning(){
        let sut = CharacterViewModel()
        #expect(sut.character.level == 1, "Character should start at level 1")
    }
}
