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
    
    
    func createNewQuest(title: String,  categories: [StatCategory],  difficulty: Double,  frequency: QuestFrequency) {
        if !activeQuests.contains(where: { $0.title == title}){
            let difficulty = clampDifficulty(difficulty)
            
            let baseXP = 100
            let earnedXP: Int = calculateDynamicXP(difficulty: difficulty, frequency: frequency, baseXP: baseXP)
            let quest = Quest(title: title, categories: categories, difficultyMultiplier: difficulty, frequency: frequency, earnedXP: earnedXP)
            activeQuests.append(quest)
        }

    }
 
    func completeQuest(questID: UUID) ->Quest? {
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
