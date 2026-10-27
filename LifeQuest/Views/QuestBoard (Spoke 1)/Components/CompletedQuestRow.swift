//
//  CompletedQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct CompletedQuestRow: View {
    let quest: Quest
    var body: some View {
        VStack(alignment: .leading) {
            QuestRowBaseInfo(quest: quest)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.secondary.opacity(0.15))
        .cornerRadius(8)
        .opacity(0.6)
    }
}
 
#Preview("Completed Row") {
    CompletedQuestRow(quest: .dailyCompletedMock)
        .padding()
}
