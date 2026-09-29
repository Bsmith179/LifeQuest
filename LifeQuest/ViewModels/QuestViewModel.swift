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
        let initialStatus = QuestStatus.active
        let initialStreak = 0
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
        if let start = start, start < now { return false}
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
    
    func completeQuest(questID: UUID) ->Quest? {
        let quest = activeQuests.first(where: { $0.id == questID})
        if var quest, quest.status == .active {
            quest.status = .completed
            activeQuests.removeAll(where: { $0.id == questID})
            return quest
        }
        return nil
    }
    
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
