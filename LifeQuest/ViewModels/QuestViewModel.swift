//
//  QuestViewModel.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//


import Foundation
import Combine

class QuestViewModel: ObservableObject {
    
    @Published var activeQuests: [Quest] = []
    
    let clock: TimeProvider
    
    init(clock: TimeProvider = SystemClock()){
        self.clock = clock
    }
    
    func createNewQuest(title: String,  categories: [StatCategory],  difficulty: Double,  frequency: QuestFrequency, startDate: Date? = nil, endDate: Date? = nil) {
        guard !activeQuests.contains(where: { $0.title == title }) else {return}
        
        guard let dates = resolveAndValidateDates(frequency: frequency, proposedStart: startDate, proposedEnd: endDate) else {
            return
        }
        
        let difficulty = clampDifficulty(difficulty)
        let baseXP = 100
        let earnedXP: Int = calculateDynamicXP(difficulty: difficulty, frequency: frequency, baseXP: baseXP)
        let earnedGold: Int = Int(earnedXP/10)
        let statPool = earnedXP / 100
        let earnedStat: Int = categories.isEmpty ? 0 : max((statPool/categories.count), 1)
        let initialStatus = calculateQuestStatus(startDate: startDate)
        let initialStreak = determineStreakState(frequency: frequency, start: dates.start, end: dates.end, currentStreak: nil)
        let quest = Quest(
            title: title,
            categories: categories,
            difficultyMultiplier: difficulty,
            frequency: frequency,
            status: initialStatus,
            startDate: dates.start,
            endDate: dates.end,
            streak: initialStreak,
            earnedXP: earnedXP,
            earnedGold: earnedGold,
            earnedStat: earnedStat
        )
        
        activeQuests.append(quest)
        
    }
    
    private func resolveAndValidateDates(frequency: QuestFrequency, proposedStart: Date?, proposedEnd: Date?) -> (start: Date?, end: Date?)? {
        
        var start = proposedStart
        if start == nil && proposedEnd != nil {
            start = self.clock.now
        }
        
        guard validateQuestDates(frequency: frequency, start: start, end: proposedEnd, now: self.clock.now) else {
            return nil
        }
        
        return (start, proposedEnd)
        
    }
    
    func validateQuestDates(frequency: QuestFrequency, start: Date?, end: Date?, now: Date) -> Bool{
        if let start = start, start < now {return false}
        if let end = end, end < now {return false}
        
        if let start = start, let end = end {
            if end < start {return false}
            
            let duration = end.timeIntervalSince(start)
            
            switch frequency {
            case .daily:
                return duration >= 86_400
            case .weekly:
                return duration >= 604_800
            case .oneOff:
                return true
            }
        }
        return true
        
    }
    
    func updateQuestDates(questID: UUID, startDate: Date? = nil, endDate: Date? = nil) -> Bool{
        guard let index = activeQuests.firstIndex(where: { $0.id == questID }) else { return false}
        let quest = activeQuests[index]
        var proposedStart = startDate ?? quest.startDate
        let proposedEnd = endDate ?? quest.endDate
        
        
        guard let validDates = resolveAndValidateDates(frequency: quest.frequency, proposedStart: proposedStart, proposedEnd: proposedEnd) else {
            return false
        }
        activeQuests[index].startDate = validDates.start
        activeQuests[index].endDate = validDates.end
        activeQuests[index].status = calculateQuestStatus(startDate: validDates.start)
        activeQuests[index].streak = determineStreakState(frequency: quest.frequency, start: validDates.start, end: validDates.end, currentStreak: quest.streak
        )
        return true
    }
    
    func completeQuest(questID: UUID) ->Quest? {
        guard let index = activeQuests.firstIndex(where: {$0.id == questID}),
              activeQuests[index].status == .active else {
            return nil
        }
        
        let oldQuest = activeQuests[index]
        
        if oldQuest.frequency != .oneOff, let oldStart = oldQuest.startDate {
            let timeShift: TimeInterval = oldQuest.frequency == .daily ? 86_400 : 604_800
            let shiftStart = oldStart.addingTimeInterval(timeShift)
            let continuedEnd = oldQuest.endDate
            
            if let validated = resolveAndValidateDates(frequency: oldQuest.frequency, proposedStart: shiftStart, proposedEnd: continuedEnd){
                
                let newStatus = calculateQuestStatus(startDate: validated.start)
                let inheritedStreak = (oldQuest.streak ?? 0) + 1
                let spawnedQuest = Quest(
                    title: oldQuest.title,
                    categories: oldQuest.categories,
                    difficultyMultiplier: oldQuest.difficultyMultiplier,
                    frequency: oldQuest.frequency,
                    status: newStatus,
                    startDate: validated.start,
                    endDate: validated.end,
                    streak: inheritedStreak,
                    earnedXP: oldQuest.earnedXP,
                    earnedGold: oldQuest.earnedGold,
                    earnedStat: oldQuest.earnedStat
                )
                activeQuests.append(spawnedQuest)
            }
        }
        
        var completedQuest = activeQuests.remove(at: index)
        completedQuest.status = .completed
        return completedQuest
    }
    
    func determineStreakState(frequency: QuestFrequency, start: Date?, end: Date?, currentStreak: Int?) -> Int?{
        
        if frequency != .oneOff && (start != nil || end != nil) {
            return currentStreak ?? 0
        }
        else {
            return nil
        }
    }
    
    func calculateQuestStatus(startDate: Date?) -> QuestStatus {
        if let startDate = startDate, self.clock.now < startDate {
            return .upcoming
        }
        return .active
        
    }
    
    func evaluateTimePassage() -> Int {
        var totalXPDrain = 0
        
        for index in activeQuests.indices {
            let quest = activeQuests[index]
            if let end = quest.endDate,
               end < self.clock.now {
                activeQuests[index].status = .expired
                continue
            }
            
            if let start = quest.startDate,
               start <= self.clock.now, quest.status == .upcoming {
                activeQuests[index].status = .active
            }
            if quest.status == .active || quest.status == .abandoned, quest.frequency != .oneOff,
               let start = quest.startDate,
               let currentStreak = quest.streak {
                
                let duration: TimeInterval = switch quest.frequency {
                case .daily: 86_400
                case .weekly: 604_800
                case.oneOff: 0
                }
                let timeSinceStart = self.clock.now.timeIntervalSince(start)
                
                if timeSinceStart >= duration {
                    let missedCycles = Int(timeSinceStart / duration)
                    
                    var newStreak = currentStreak
                    
                    for _ in 0..<missedCycles {
                        if newStreak > 0 {
                            newStreak = 0
                        } else {
                            newStreak -= 1
                        }
                        
                        
                        if newStreak < 0 {
                            let penaltyMultiplier = min(Double(abs(newStreak)) * 0.20, 2.0)
                            let cyclePenalty = Int(Double(quest.earnedXP) * penaltyMultiplier)
                            totalXPDrain += cyclePenalty
                        }
                    }
                    activeQuests[index].streak = newStreak
                    
                    let timeShift = duration * Double(missedCycles)
                    activeQuests[index].startDate = start.addingTimeInterval(timeShift)
                    
                    if newStreak <= -10 {
                        activeQuests[index].status = .abandoned
                    }
                }
            }
        }
        return totalXPDrain
    }
    
    func abandonQuest(questID: UUID) ->Quest?{return nil}
    
    private func clampDifficulty(_ difficulty: Double) -> Double {
        return min(max(difficulty, 1.0),5.0)
    }
    
    private func calculateDynamicXP(difficulty: Double, frequency: QuestFrequency, baseXP: Int) -> Int{
        
        let frequencyMultiplier: Double = switch frequency {
        case .daily:
            1.5
        case .weekly:
            2.0
        case .oneOff:
            1.0
        }
        return Int(Double(baseXP) * difficulty * frequencyMultiplier)
    }
    
}
