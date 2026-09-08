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
    
    func createNewQuest(title: String,  category: StatCategory,  difficulty: Double,  frequency: QuestFrequency) {}
 
    func completeQuest(questID: UUID) {}
}
