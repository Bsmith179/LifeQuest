//
//  ActiveQuestRow.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct ActiveQuestRow: View {
    
    let quest: Quest
    
    var body: some View {
        VStack(alignment: .leading){
            QuestRowBaseInfo(quest: quest)
            
            HStack{
                ChangeDateButton {}
                
                Spacer()
                
                Button("Complete"){
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
            }
            .padding(.top, 4)
        }
    }
}
 
#Preview {
    ActiveQuestRow(quest: .dailyMock)
        .padding()
}
