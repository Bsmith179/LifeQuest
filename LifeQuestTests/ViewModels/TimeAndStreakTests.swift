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
    
    @Test("Updating quest dates validates start and end boundaries", arguments: [
        (QuestFrequency.daily,
         Date.testDate(dayOffset: 0, hourOffset: -1),
         Date.testDate(dayOffset: 5), false),
        (QuestFrequency.daily,
         Date.testDate(dayOffset: 0, hourOffset: 0),
         Date.testDate(dayOffset: 5), true),
        (QuestFrequency.daily,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 1, hourOffset: 23), false),
        (QuestFrequency.daily,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 2, hourOffset: 0), true),
        (QuestFrequency.daily, Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 2, hourOffset: 1), true),
        (QuestFrequency.weekly,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 7, hourOffset: 23), false),
        (QuestFrequency.weekly,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 8), true),
        (QuestFrequency.weekly,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 8, hourOffset: 1), true),
        (QuestFrequency.oneOff,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 1, hourOffset: 1), true),
        (QuestFrequency.oneOff,
         Date.testDate(dayOffset: 1),
         Date.testDate(dayOffset: 0, hourOffset: 23), false)])
    func testUpdateQuestDates_ValidatesStartAndEndBoundaries(frequency: QuestFrequency, attemptedStart: Date, attemptedEnd: Date, expectedSuccess: Bool) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: frequency)
        let quest = sut.activeQuests.first!
        
        let result = sut.updateQuestDates(questID: quest.id, startDate: attemptedStart, endDate: attemptedEnd)
        
        #expect(result == expectedSuccess)
        
    }
    
    
}
