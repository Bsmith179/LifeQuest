//
//  QuestBoardView.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import SwiftUI
 
struct QuestBoardView: View {
    
   @EnvironmentObject private var viewModel: QuestViewModel
    
    var body: some View {
        NavigationView {
            List{
                if viewModel.activeQuests.isEmpty {
                    Text("No active quests. Time to start a new One!")
                        .foregroundColor(.secondary)
                        .italic()
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.activeQuests) { quest in
                       QuestRowView(quest: quest)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 2)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Quest Board")
            .toolbar{
                ToolbarItem(placement: .primaryAction){
                    Button(action: {
                        
                    }){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
 
#Preview {
    let previewViewModel = QuestViewModel(clock: SystemClock(), session: URLSession.shared)
    previewViewModel.activeQuests = [.dailyMock, .dailyCompletedMock, .dailyUpcomingMock, .dailyAbandonedMock]
    
    return QuestBoardView().environmentObject(previewViewModel)
}
