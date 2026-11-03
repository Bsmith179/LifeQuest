//
//  QuestBoardView.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import SwiftUI

struct QuestBoardView: View {
    
    @EnvironmentObject private var viewModel: QuestViewModel
    @State private var isShowingAddQuest: Bool = false
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
                        isShowingAddQuest = true
                    }){
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("AddQuestButton")
                }
            }
            .sheet(isPresented: $isShowingAddQuest){
                AddQuestSheet()
            }
        }
    }
}

#Preview {
    let previewViewModel = QuestViewModel(clock: SystemClock(), session: URLSession.shared)
    previewViewModel.activeQuests = [.dailyMock, .dailyCompletedMock, .dailyUpcomingMock, .dailyAbandonedMock]
    
    return QuestBoardView().environmentObject(previewViewModel)
}
