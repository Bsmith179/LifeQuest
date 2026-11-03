//
//  ActiveQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct ActiveQuestRow: View {
  
    let quest: Quest
 
    @EnvironmentObject private var questVM: QuestViewModel
    @EnvironmentObject private var characterVM: CharacterViewModel
 
    @State private var isShowingDateSheet: Bool = false
    @State private var showValidationError: Bool = false
 
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
          
            HStack{
                
                ChangeDateButton(questTitle: quest.title) {
                    isShowingDateSheet = true
                }
               
                Spacer()
                
                Button("Complete"){
                    if let completedQuest = questVM.completeQuest(questID: quest.id){
                        characterVM.gainXP(amount: completedQuest.earnedXP)
                        characterVM.addGold(amount: completedQuest.earnedGold)
 
                        for category in completedQuest.categories {
                            characterVM.addStat(category: category, amount: completedQuest.earnedStat)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .accessibilityIdentifier("CompleteButton_\(quest.title)")
               
            }
            .padding(.top, 4)
            .sheet(isPresented: $isShowingDateSheet){
                ChangeDateSheet(quest: quest){
                    newStart, newEnd in
                    let success = questVM.updateQuestDates(
                        questID: quest.id,
                        startDate: newStart,
                        endDate: newEnd
                    )
                   
                    if !success {
                        showValidationError = true
                    }
                }
            }
            .alert("Invalid Dates", isPresented: $showValidationError){
                Button("OK", role: .cancel){}
                    .accessibilityIdentifier("InvalidDatesOKButton")
            } message: {
                Text("The selected dates do not match the required frequency duration")
            }
        }
    }
}
 
 
 
 
#Preview {
    
    let questVM = QuestViewModel()
    
    questVM.createNewQuest(
        title: "Daily Mock",
        categories: [.strength],
        difficulty: 1.0,
        frequency: .daily,
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())
    )
    
    return ActiveQuestRow(quest:  questVM.activeQuests.first!)
        .environmentObject(questVM)
        .padding()
}
