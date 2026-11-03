//
//  QuestRowBaseInfo.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct QuestRowBaseInfo: View {
    
    let quest: Quest
    @State private var isShowingDetailSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(quest.title)
                .font(.headline)
            
            HStack{
                Text(quest.frequency.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
                
                if let streak = quest.streak {
                    Text("Streak: \(streak)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingDetailSheet = true
        }
        .accessibilityIdentifier("QuestRowBaseInfo_\(quest.title)")
        .sheet(isPresented: $isShowingDetailSheet){
            QuestDetailSheet(quest: quest)
        }
    }
}
 
#Preview {
    
    QuestRowBaseInfo(quest: .dailyMock)
    QuestRowBaseInfo(quest: .dailyMock)
    QuestRowBaseInfo(quest: .oneOffMock)
}

