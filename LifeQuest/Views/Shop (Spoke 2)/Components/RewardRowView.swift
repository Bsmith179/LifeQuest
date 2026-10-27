//
//  RewardRowView.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct RewardRowView: View {
    let reward: Reward
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title).font(.headline)
                HStack {
                    Image(systemName: "circle.grid.hex.fill").foregroundColor(.yellow)
                    Text("\(reward.goldCost) Gold").font(.subheadline).bold()
                }
            }
            Spacer()
            Button("Buy") { }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .foregroundColor(.black)
        }
        .padding(.vertical, 4)
    }
}
 
#Preview("Reward Row") {
    RewardRowView(reward: .mockReward)
        .padding()
}
