//
//  QuestRowView.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct QuestRowView: View {
    let quest: Quest
    
    var body: some View {
        switch quest.status {
        case .active:
            ActiveQuestRow(quest: quest)
        case .upcoming:
            UpcomingQuestRow(quest: quest)
        case .completed:
            CompletedQuestRow(quest: quest)
        case .abandoned, .expired:
            AbandonedQuestRow(quest: quest)
        }
    }
}
 
#Preview {
    QuestRowView(quest: .dailyMock)
        .padding()
    QuestRowView(quest: .dailyUpcomingMock)
        .padding()
    QuestRowView(quest: .dailyCompletedMock)
        .padding()
    QuestRowView(quest: .dailyAbandonedMock)
        .padding()
}
