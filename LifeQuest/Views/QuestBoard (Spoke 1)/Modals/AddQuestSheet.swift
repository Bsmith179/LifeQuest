//
//  AddQuestSheet.swift
//  LifeQuest
//
//  Created by Icy on 11/3/26.
//

import SwiftUI
 
struct AddQuestSheet: View {
 
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var questVM: QuestViewModel
 
    @State private var title: String = ""
    @State private var difficultyMultiplier: Double = 1.0
    @State private var frequency: QuestFrequency = .oneOff
    @State private var selectedCategories: Set<StatCategory> = []
 
    @State private var customStartDate: Date?
    @State private var customEndDate: Date?
 
    @State private var isShowingDateSheet = false
    @State private var showValidationError: Bool = false
 
    var tempQuest: Quest {
        Quest(title: title.isEmpty ? "New Quest" : title,
              categories: Array(selectedCategories),
              difficultyMultiplier: difficultyMultiplier,
              frequency: frequency,
              status: .upcoming,
              earnedXP: 0,
              earnedGold: 0,
              earnedStat: 0,
              startDate: customStartDate,
              endDate: customEndDate,
              streak: nil,
              syncStatus: .pending)
    }
 
    var body: some View {
 
        NavigationView{
            Form{
                Section(header: Text("Quest Details")){
 
                    TextField("Quest Title", text: $title)
                        .accessibilityIdentifier("QuestTitleTextField")
 
                    Picker("Frequency", selection: $frequency){
                        ForEach(QuestFrequency.allCases, id: \.self){
                            freq in Text(freq.rawValue.capitalized).tag(freq)
                        }
                    }
                    .accessibilityIdentifier("QuestFrequencyPicker")
 
                    Stepper(value: $difficultyMultiplier, in: 1.0...5.0, step: 0.5){
                        Text("Difficulty: \(difficultyMultiplier, specifier: "%.1f")x")
                    }
                    .accessibilityIdentifier("QuestDifficultyStepper")
                }
               
                Section(header: Text("Stat Categories")){
 
                    ForEach(StatCategory.allCases, id: \.self){
                        category in
                        Toggle(category.rawValue.capitalized, isOn: Binding(
                            get: {self.selectedCategories.contains(category)},
 
                            set: { isSelected in
                                if isSelected {
                                    self.selectedCategories.insert(category)
                                } else {
                                    self.selectedCategories.remove(category) }
                            }
                        ))
                        .accessibilityIdentifier("Category\(category.rawValue.capitalized)Toggle")
                    }
                }
 
                Section(header: Text("Schedule")){
 
                    Button(action: {
                        isShowingDateSheet = true
                    }){
                        Label("Set Custom Dates", systemImage: "calendar.badge.clock")
                    }
                    .accessibilityIdentifier("SetCustomDatesButton")
                  
                    if let start = customStartDate {
                        Text("Start: \(start.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption).foregroundColor(.secondary)
                    }
 
                    if let end = customEndDate {
                        Text("End: \(end.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("New Quest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
 
                ToolbarItem(placement: .cancellationAction){
 
                    Button("Cancel"){
                        dismiss()
                    }
                    .accessibilityIdentifier("CancelAddQuestButton")
                }
 
                ToolbarItem(placement: .confirmationAction){
 
                    Button("Add"){
                        let startingQuestCount = questVM.activeQuests.count
                        questVM.createNewQuest(
                            title: title,
                            categories: Array(selectedCategories),
                            difficulty: difficultyMultiplier,
                            frequency: frequency,
                            startDate: customStartDate,
                            endDate: customEndDate
                        )
                        if questVM.activeQuests.count > startingQuestCount {
                            dismiss()
                        } else {
                            showValidationError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty || selectedCategories.isEmpty)
                    .accessibilityIdentifier("SaveAddQuestButton")
                    .alert("Invalid Quest", isPresented: $showValidationError){
                        Button("OK", role: .cancel){}
                            .accessibilityIdentifier("InvalidQuestOKButton")
                    } message: {
                        Text("A quest with this title already exists, or the custom dates you provided are invalid for the frequency you selected.")
                    }
                }
            }
            .sheet(isPresented: $isShowingDateSheet){
                ChangeDateSheet(quest: tempQuest){ newStart, newEnd in
                    self.customStartDate = newStart
                    self.customEndDate = newEnd
 
                }
            }
        }
    }
}
   
    #Preview {
        AddQuestSheet()
            .environmentObject(QuestViewModel())
    }
