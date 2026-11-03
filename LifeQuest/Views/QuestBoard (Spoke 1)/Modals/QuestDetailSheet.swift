//
//  QuestDetailSheet.swift
//  LifeQuest
//
//  Created by Icy on 11/3/26.
//

import SwiftUI
 
struct QuestDetailSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    let quest: Quest
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading, spacing: 16){
                    HStack{
                        Text("Status: \(quest.status.rawValue.capitalized)")
                        Spacer()
                        Text("Frequency: \(quest.frequency.rawValue.capitalized)")
                        if let streak = quest.streak {
                            Spacer()
                            let duration: String =  quest.frequency == .daily ? "days" : "weeks"
                            Text("Streak: \(streak) \(duration)")
                                .foregroundColor(.orange)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                   
                    Divider()
                    
                    VStack(alignment: .center, spacing: 8){
                        Text("Rewards")
                            .font(.headline)
                        HStack{
                            Text("\(quest.earnedXP) XP")
                            Spacer()
                            Text("\(quest.earnedGold) Gold")
                        }
                        .font(.subheadline)
 
                        HStack{
                            let categoryNames = quest.categories.map{
                                $0.rawValue.capitalized}.joined(separator: ", ")
                            Text("\(categoryNames)")
                                Spacer()
                                 Text("+\(quest.earnedStat) points each")
                        }
                        .font(.subheadline)
                    }
                    Divider()
 
                    VStack(alignment: .center, spacing: 8){
                        Text("Schedule")
                            .font(.headline)
                        if let start = quest.startDate {
                            LabeledContent("Start", value: start.formatted(date: .abbreviated, time: .shortened))
                        } else {
                            Text("No Start Date")
                                .foregroundColor(.secondary)
                        }
                        
                        if let end = quest.endDate {
                            LabeledContent("End", value: end.formatted(date: .abbreviated, time: .shortened))
                        } else {
                            Text("No End Date")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle(quest.title)
            .navigationBarTitleDisplayMode( .inline )
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        dismiss()
                    }
                    .accessibilityIdentifier("CloseQuestDetailButton")
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
 
#Preview {
    QuestDetailSheet(quest: .dailyMock)
}
