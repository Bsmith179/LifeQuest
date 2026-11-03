//
//  ChangeDateSheet.swift
//  LifeQuest
//
//  Created by Icy on 11/3/26.
//

import SwiftUI
 
struct ChangeDateSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var questVM: QuestViewModel
  
    let quest: Quest
    let onSave: (Date?, Date?) -> Void
  
    @State private var hasStartDate: Bool
    @State private var hasEndDate: Bool
 
    @State private var startDate: Date
    @State private var endDate: Date
    
    init(quest: Quest, onSave: @escaping (Date?, Date?) -> Void){
        self.quest = quest
        self.onSave = onSave
      
        _hasStartDate = State(initialValue: quest.startDate != nil)
        _hasEndDate = State(initialValue: quest.endDate != nil)
        
        _startDate = State(initialValue: quest.startDate ?? Date())
 
        let calculatedEndDate: Date
 
        switch(quest.frequency){
        case .daily:
            calculatedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        case .weekly:
            calculatedEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        case .oneOff:
            calculatedEndDate = Date()
        }
   
        _endDate = State(initialValue: quest.endDate ?? calculatedEndDate)
    }
 
    var body: some View {
        NavigationView {
            Form {
 
                Section(header: Text("Start Date")){
                    Toggle("Has Start Date", isOn: $hasStartDate)
                        .accessibilityIdentifier("HasStartDateToggle")
 
                    if hasStartDate {
                        DatePicker("Start",
                                   selection: $startDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        .accessibilityIdentifier("StartDatePicker")
                    }
                }
 
                Section(header: Text("End Date")){
                    
                    Toggle("Has End Date", isOn: $hasEndDate)
                        .accessibilityIdentifier("HasEndDateToggle")
                    if hasEndDate {
                        DatePicker("End",
                                   selection: $endDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        .accessibilityIdentifier("EndDatePicker")
                    }
                }
            }
            
            .navigationTitle("Change Dates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                    .accessibilityIdentifier("CancelChangeDateButton")
                }
 
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let finalStart = hasStartDate ? startDate : nil
                        let finalEnd = hasEndDate ? endDate : nil
                     
                        onSave(finalStart,finalEnd)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("SaveChangeDateButton")
                }
            }
        }
    }
}
 
    #Preview {
    
        return ChangeDateSheet(quest: .dailyMock, onSave: {(_, _) in })
            .environmentObject(QuestViewModel())
    }
