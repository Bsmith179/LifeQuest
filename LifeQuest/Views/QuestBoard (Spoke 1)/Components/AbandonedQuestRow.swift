//
//  AbandonedQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct AbandonedQuestRow: View {
    
    let quest: Quest
    
    private var penaltyIntensity: Double{
        return abs(Double(quest.streak ?? 0))
    }
    
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
            
            HStack{
                Button("Abandon"){
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                
                Spacer()
                
                Button("Recommit"){
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.top, 4)
        }
        .padding(8)
        .background(Color.red.opacity(0.1 + (0.08 * penaltyIntensity)))
        .cornerRadius(8)
    }
}
 
#Preview {
    AbandonedQuestRow(quest: .dailyAbandonedMock)
        .padding()
}

