//
//  TimeAndStreakTests.swift
//  LifeQuestTests
//
//  Created by Icy on 9/29/26.
//

import Foundation
import Testing
@testable import LifeQuest

struct TimeAndStreakTests {
    
    let fakeClock: FakeClock
    let sut: QuestViewModel
    
    init(){
        fakeClock = FakeClock(currentDate: Date.testEpoch)
        sut = QuestViewModel(clock: fakeClock)
    }
    
    @Test("Ensure Fake Clock is working", arguments:
            [
                (0,23,82800.0),
                (1,0,86400.0),
                (1,1,90000.0)
            ])
    func testDeterministicDateHelper_CalculatesAccurateOffsets(dayOffset: Int, hourOffset: Int, expectSecondsFromNow: Double){
        let testDate = Date.testDate(dayOffset: dayOffset, hourOffset: hourOffset)
        #expect(testDate.timeIntervalSince(fakeClock.now) == expectSecondsFromNow)
    }
    
    @Test("Creating a quest with an end date auto creates start date", arguments:
            [
                (nil,Date.testDate(dayOffset: 5),Date.testEpoch),
                (Date.testDate(dayOffset: 2),Date.testDate(dayOffset: 5),Date.testDate(dayOffset: 2))
            ])
    func testCreateQuest_DefaultsStartDateIfOnlyEndDateProvided(startDate: Date?, endDate: Date, expectedStartDate: Date){
        sut.createNewQuest(title: "Test Quests", categories: [.strength], difficulty: 2.0, frequency: .oneOff, startDate: startDate, endDate: endDate )
        
        let quest = sut.activeQuests.first!
        #expect(quest.startDate == expectedStartDate)
        
        
    }
    
    
}
