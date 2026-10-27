//
//  UpcomingQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct UpcomingQuestRow: View {
    
    let quest: Quest
    
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
            
            HStack{
                ChangeDateButton{}
                Spacer()
            }
            .padding(.top, 4)
        }
    }
}
 
#Preview {
    UpcomingQuestRow(quest: .dailyUpcomingMock)
        .padding()
}
