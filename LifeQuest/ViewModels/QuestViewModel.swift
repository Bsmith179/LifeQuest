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
            
            let quest = Quest(title: title, categories: categories, difficultyMultiplier: difficulty, frequency: frequency)
            activeQuests.append(quest)
        }

    }
 
    func completeQuest(questID: UUID) ->Quest? {
        return nil
    }
}
