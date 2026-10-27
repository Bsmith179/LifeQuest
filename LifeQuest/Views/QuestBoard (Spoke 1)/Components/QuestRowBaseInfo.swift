//
//  QuestRowBaseInfo.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct QuestRowBaseInfo: View {
    
    let quest: Quest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(quest.title)
                .font(.headline)
            
            HStack{
                let backgroundColor =
                switch(quest.frequency){
                case .oneOff:
                    Color.red.opacity(0.2)
                case .daily:
                    Color.orange.opacity(0.2)
                case .weekly:
                    Color.yellow.opacity(0.2)
                }
                Text(quest.frequency.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(backgroundColor)
                    .cornerRadius(4)
                
                if let streak = quest.streak {
                    Text("Streak: \(streak)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
 
#Preview {
    QuestRowBaseInfo(quest: .dailyMock)
    QuestRowBaseInfo(quest: .dailyMock)
    QuestRowBaseInfo(quest: .oneOffMock)
}
