//
//  AbandonedQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct AbandonedQuestRow: View {
    
    let quest: Quest
    @EnvironmentObject private var questVM: QuestViewModel
    
    @State private var isShowingRecommitSheet = false
    
    private var penaltyIntensity: Double{
        return abs(Double(quest.streak ?? 0))
    }
 
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
            
            HStack{
                Button("Abandon", role: .destructive){
                    _ = questVM.abandonQuest(questID: quest.id)
                }
                
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .accessibilityIdentifier("AbandonButton_\(quest.title)")
                              
                Spacer()
                
                Button("Recommit"){
                    isShowingRecommitSheet = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .accessibilityIdentifier("RecommitButton_\(quest.title)")
            }
            .padding(.top, 4)
        }
        .padding(8)
        .background(Color.red.opacity(0.1 + (0.08 * penaltyIntensity)))
        .cornerRadius(8)
        .sheet(isPresented: $isShowingRecommitSheet){
            ChangeDateSheet(quest: quest){ newStart, newEnd in
                _ = questVM.recommitQuest(
                    questID: quest.id,
                    startDate: newStart,
                    endDate: newEnd)
            }
        }
    }
}
 
#Preview {
    
    AbandonedQuestRow(quest: .dailyAbandonedMock)
        .environmentObject(QuestViewModel())
        .padding()
}

