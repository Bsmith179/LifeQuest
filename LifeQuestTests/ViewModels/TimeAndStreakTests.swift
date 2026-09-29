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
    
    //MARK: - Section A, Date Validation
    
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
    
    @Test("Create Quest assigns initial Status based on start Date", arguments: [
        (Date.testDate(dayOffset: 1), QuestStatus.upcoming),
        (Date.testDate(dayOffset: 0, hourOffset: 0), QuestStatus.active),
        (nil, QuestStatus.active)
    ])
    func testCreateQuest_AssignsInitialStatusBasedOnStartDate(startDate: Date?, expectedStatus: QuestStatus) throws {
        sut.createNewQuest(title: "Test Quests", categories: [.strength], difficulty: 2.0, frequency: .oneOff, startDate: startDate, endDate: nil )
        
        let quest = try #require(sut.activeQuests.first, "Quest should have been created but was not")
        #expect(quest.status == expectedStatus)
        
    }
    
    //MARK: - Section B, Streak Tests
    
    @Test("Streak activates with a date provided", arguments: [
        (QuestFrequency.daily, nil, nil, nil),
        (QuestFrequency.daily, Date.testDate(dayOffset: 0), nil, 0),
        (QuestFrequency.daily, nil, Date.testDate(dayOffset: 5), 0),
        (QuestFrequency.oneOff, Date.testDate(dayOffset: 0), Date.testDate(dayOffset: 5), nil)
    ])
    func testStreak_ActivatesIfAnyDateProvided(frequency: QuestFrequency, startDate: Date?, endDate: Date?, expectedStreak: Int?) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: frequency)
        let quest = sut.activeQuests.first!
        _ = sut.updateQuestDates(questID: quest.id, startDate: startDate, endDate: endDate)
        let updatedQuest = sut.activeQuests.first(where: { $0.id == quest.id })!
        #expect(updatedQuest.streak == expectedStreak)
    }
    
    //MARK: - Section C, Spawning
    
    @Test("Completing a reoccuring quest returns a completed and starts a new quest", arguments: [
        (QuestFrequency.daily, Date.testDate(dayOffset: 0), QuestStatus.completed, 1, Date.testDate(dayOffset: 1)),
        (QuestFrequency.weekly, Date.testDate(dayOffset: 0), QuestStatus.completed, 1, Date.testDate(dayOffset: 7)),
        (QuestFrequency.oneOff, Date.testDate(dayOffset: 0), QuestStatus.completed, 0, nil)
    ])
    func testCompleteQuest_SpawnsNewCycleAndUpdatesStatuses(
        frequency: QuestFrequency,
        startDate: Date,
        expectedFinalStatus: QuestStatus,
        expectedActiveQuests: Int,
        expectedNewStartDate: Date?
    ) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: frequency, startDate: startDate)
        let initialQuest = sut.activeQuests.first!
        let completedQuest = sut.completeQuest(questID: initialQuest.id)
        let newQuest = sut.activeQuests.first
        
        #expect(completedQuest?.status == expectedFinalStatus)
        #expect(sut.activeQuests.count == expectedActiveQuests)
        #expect(newQuest?.startDate == expectedNewStartDate)
        
    }
    
    //MARK: - Section D, Sweep Engine
    
    @Test("Check Upcoming transitions to active", arguments: [
        (Date.testDate(dayOffset: 0, hourOffset: 23), QuestStatus.upcoming),
        (Date.testDate(dayOffset: 1, hourOffset: 0), QuestStatus.active),
        (Date.testDate(dayOffset: 1, hourOffset: 1), QuestStatus.active)
    ])
    func testEvaluateTimePassage_TransitionsUpcomingToActive(currentDate: Date, expectedStatus: QuestStatus) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: .daily)
        let quest = sut.activeQuests.first!
        _ = sut.updateQuestDates(questID: quest.id, startDate: Date.testDate(dayOffset: 1))
        fakeClock.now = currentDate
        _ = sut.evaluateTimePassage()
        
        let updateQuest = sut.activeQuests.first(where: { $0.id == quest.id })!
        #expect(updateQuest.status == expectedStatus)
        
    }
    
    @Test("Check active transitions to expired", arguments: [
        (nil, nil, QuestStatus.active),
        (Date.testDate(dayOffset: 0), nil, QuestStatus.abandoned),
        (nil, Date.testDate(dayOffset: 5), QuestStatus.expired),
        (Date.testDate(dayOffset: 0), Date.testDate(dayOffset: 5), QuestStatus.expired)
    ])
    func testEvaluateTimePassage_MarkQuestsExpired(startDate: Date?, endDate: Date?, expectedStatus: QuestStatus) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: .daily)
        let quest = sut.activeQuests.first!
        _ = sut.updateQuestDates(questID: quest.id, startDate: startDate, endDate: endDate)
        fakeClock.now = Date.testDate(dayOffset: 30)
        _ = sut.evaluateTimePassage()
        let updateQuest = sut.activeQuests.first(where: { $0.id == quest.id })!
        #expect(updateQuest.status == expectedStatus)
        
    }
    
    @Test("Streak Penalties are applied for missing cycles to abandonment", arguments: [
        (5,1,0, QuestStatus.active),
        (5,3,-2, QuestStatus.active),
        (0,2,-2, QuestStatus.active),
        (-8,1,-9, QuestStatus.active),
        (-8,2,-10, QuestStatus.abandoned)
    ])
    func testEvaluateTimePassage_ExpiresQuestWhenEndDatePassed(initialStreak: Int, missedDays: Int, expectedStreak: Int, expectedStatus: QuestStatus) {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: .daily, startDate: Date.testDate(dayOffset: 0))
        let index = sut.activeQuests.startIndex
        sut.activeQuests[index].streak = initialStreak
        
        fakeClock.now = Date.testDate(dayOffset: missedDays)
        
        _ = sut.evaluateTimePassage()
        let quest = sut.activeQuests[index]
        #expect(quest.streak == expectedStreak)
        #expect(quest.status == expectedStatus)
        #expect(quest.startDate == fakeClock.now)
        
    }
    
    //MARK: - Section E, Player's choice
    
    @Test("Personally Abandoning a quest removes quest from active list and labels it abandoned")
    func testAbandonQuest_RemovesFromActiveAndReturnsAbandoned() {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: .daily, startDate: Date.testDate(dayOffset: 0),endDate: Date.testDate(dayOffset: 1))
        let index = sut.activeQuests.startIndex
        let quest = sut.activeQuests[index]
        
        fakeClock.now = Date.testDate(dayOffset: 2)
        
        let abandonedQuest = sut.abandonQuest(questID: quest.id)
        
        #expect(abandonedQuest?.status == .abandoned)
        #expect(sut.activeQuests.isEmpty)
    }
    
    @Test("Recommit an expired or abandoned quest archives old and spawns a new one")
    func testRecommitQuest_ArchivesOldQuestAndSpawnsNewCycle() {
        sut.createNewQuest(title: "Test Quest", categories: [.strength], difficulty: 2.0, frequency: .daily, startDate: Date.testDate(dayOffset: 0),endDate: Date.testDate(dayOffset: 1))
        let index = sut.activeQuests.startIndex
        let quest = sut.activeQuests[index]
        
        fakeClock.now = Date.testDate(dayOffset: 2)
        
        let archivedQuest = sut.recommitQuest(questID: quest.id, startDate: Date.testDate(dayOffset: 3), endDate: nil)
        let recommitedQuest = sut.activeQuests.first
        
        #expect(archivedQuest?.status == .abandoned)
        #expect(sut.activeQuests.count == 1)
        #expect(archivedQuest?.id != recommitedQuest?.id)
        #expect(recommitedQuest?.status == .upcoming)
        #expect(recommitedQuest?.streak == 0)
    }
    
}
