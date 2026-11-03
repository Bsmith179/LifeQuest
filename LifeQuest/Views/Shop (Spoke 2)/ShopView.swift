//
//  ShopView.swift
//  LifeQuest
//
//  Created by Brigitte on 9/8/26.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject private var shopViewModel: ShopViewModel
    @EnvironmentObject private var characterViewModel: CharacterViewModel
    
    @State private var isShowingAddReward = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "circle.grid.hex.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                    Text("Available Gold: \(characterViewModel.character.gold)")
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                List {
                    if shopViewModel.availableRewards.isEmpty {
                        Text("No rewards available. Time to add some motivation!")
                            .foregroundColor(.secondary)
                            .italic()
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(shopViewModel.availableRewards) { reward in
                            RewardRowView(reward: reward)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 2)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Reward Shop")
            .toolbar{
                ToolbarItem(placement: .primaryAction){
                    Button(action: {
                        isShowingAddReward = true
                    }){
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("AddRewardButton")
                }
            }
            .sheet(isPresented: $isShowingAddReward){
                AddRewardSheet()
            }
        }
    }
}

#Preview("Shop View") {
    let previewShopVM = ShopViewModel()
    let previewCharVM = CharacterViewModel()
    previewCharVM.character.gold = 120
    previewShopVM.availableRewards = [.mockReward]
    return ShopView()
        .environmentObject(previewShopVM)
        .environmentObject(previewCharVM)
}
