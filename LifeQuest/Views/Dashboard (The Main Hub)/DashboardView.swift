//
//  CharacterViewModel.swift
//  LifeQuest
//
//  Created by Icy on 9/8/26.
//

import SwiftUI
 
struct DashboardView: View {
    
    @EnvironmentObject var characterVM: CharacterViewModel
    @EnvironmentObject var questVM: QuestViewModel
    @EnvironmentObject var shopVM: ShopViewModel
    
    var body: some View {
       NavigationStack {
           VStack(spacing: 20) {
               VStack{
                   HStack {
                       Text("Level: \(characterVM.character.level)")
                           .font(.system(size: 28, weight: .bold, design: .rounded))
                           .frame(maxWidth: .infinity, alignment: .leading)
                           .shadow(color: .black, radius: 0)
                        
                       Text("Gold: \(characterVM.character.gold)")
                           .font(.title2)
                           .foregroundColor(.yellow)
                           .fontWeight(.semibold)
                           .shadow(color: .black, radius: 1)
                   }
                   StatMeterView(title: "XP", current: characterVM.character.currentXP, max: 1000, color: .green)
                    
                   Divider()
                       .padding(.vertical)
                    
                   VStack(spacing: 16){
                       StatMeterView(title: "Strength", current: characterVM.character.strength, max: 99, color: .red)
                       StatMeterView(title: "Focus", current: characterVM.character.focus, max: 99, color: .yellow)
                       StatMeterView(title: "Intelligence", current: characterVM.character.strength, max: 99, color: .blue)
                       StatMeterView(title: "Charisma", current: characterVM.character.strength, max: 99, color: .purple)
                   }
               }
               .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 20){
                    NavigationLink(destination: Text("QuestBoard Placeholder")) {
                        Text("Quest Board")
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("QuestBoardViewButton")
                    
                    NavigationLink(destination: Text("Shop Placeholder")) {
                        Text("Reward Shop")
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier( "ShopViewButton")
                }
                .padding()
            }
           .navigationTitle("Dashboard")
        }
    }
}
 
#Preview {
    let previewCharacterVM = CharacterViewModel()
    
    previewCharacterVM.addGold(amount: 500)
    previewCharacterVM.gainXP(amount: 2500)
    previewCharacterVM.addStat(category: .strength, amount: 10)
    previewCharacterVM.addStat(category: .focus, amount: 25)
    previewCharacterVM.addStat(category: .intelligence, amount: 30)
    previewCharacterVM.addStat(category: .charisma, amount: 5)
    
    return DashboardView()
        .environmentObject(previewCharacterVM)
        .environmentObject(QuestViewModel())
        .environmentObject(ShopViewModel())
}
