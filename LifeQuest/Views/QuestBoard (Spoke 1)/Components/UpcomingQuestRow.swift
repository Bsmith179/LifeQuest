//
//  UpcomingQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct UpcomingQuestRow: View {
    
    let quest: Quest
    
    @EnvironmentObject private var questVM: QuestViewModel
    
    @State private var isShowingDateSheet: Bool = false
    @State private var showValidationError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
            
            HStack{
                ChangeDateButton(questTitle: quest.title){
                    isShowingDateSheet = true
                }
                Spacer()
            }
            .padding(.top, 4)
            .sheet(isPresented: $isShowingDateSheet){
                ChangeDateSheet(quest: quest){
                    newStart, newEnd in
                    let success = questVM.updateQuestDates(
                        questID: quest.id,
                        startDate:newStart,
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
        title: "Future Quest",
        categories: [.strength],
        difficulty: 1.5,
        frequency: .daily,
        startDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
        endDate: Calendar.current.date(byAdding: .day, value: 9, to: Date())
    )
    return UpcomingQuestRow(quest: questVM.activeQuests.first!)
        .environmentObject(questVM)
        .padding()
}
