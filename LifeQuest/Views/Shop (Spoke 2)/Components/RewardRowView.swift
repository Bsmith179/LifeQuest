//
//  RewardRowView.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct RewardRowView: View {
    
    let reward: Reward
    
    @EnvironmentObject private var shopVM: ShopViewModel
    @EnvironmentObject private var characterVM: CharacterViewModel
    
    @State private var showInsufficientGoldAlert = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(reward.title)
                    .font(.headline)
                
                HStack{
                    Image(systemName: "circle.grid.hex.fill")
                        .foregroundColor(.yellow)
                    Text("\(reward.goldCost) Gold")
                        .font(.subheadline)
                        .bold()
                }
            }
            Spacer()
            
            Button("Buy"){
                let currentGold = characterVM.character.gold
                
                let success = shopVM.purchaseReward(rewardID: reward.id, currentGold: currentGold)
               
                if success{
                    characterVM.deductGold(amount: reward.goldCost)
                } else {
                    showInsufficientGoldAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)
            .foregroundColor(.black)
            .accessibilityIdentifier("BuyButton_\(reward.title)")
        }
        .padding(.vertical, 4)
        .alert("Not Enough Gold", isPresented: $showInsufficientGoldAlert){
            Button("OK", role: .cancel){}
                .accessibilityIdentifier("InsufficientGoldOKButton")
            
        } message: {
            let deficit = reward.goldCost - characterVM.character.gold
            Text("You need \(deficit) more gold to buy this.")
        }
    }
}
 
 
#Preview {
    RewardRowView(reward: .mockReward)
        .environmentObject(ShopViewModel())
        .environmentObject(CharacterViewModel())
        .padding()
}
