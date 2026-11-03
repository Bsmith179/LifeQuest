//
//  AddRewardSheet.swift
//  LifeQuest
//
//  Created by Icy on 11/3/26.
//


import SwiftUI
 
struct AddRewardSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var shopVM: ShopViewModel
    
    @State private var title: String = ""
    @State private var cost: Int = 10
    
    @State private var showValidationError: Bool = false    
 
    var tempReward: Reward{
        Reward(title: title.isEmpty ? "New Reward" : title,
               goldCost: cost)
    }
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Reward Title", text: $title)
                    .accessibilityIdentifier("RewardTitleTextField")
                
                Stepper(value: $cost, in: 10...99999, step: 10){
                    Text("Cost: by $\(cost, specifier: "%d")")
                }
                .accessibilityIdentifier("RewardCostStepper")
            }
            .navigationTitle("Add Reward")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                    .accessibilityIdentifier("CancelAddRewardButton")
                }
                
                ToolbarItem(placement: .confirmationAction){
                    Button("Add"){
                        let startingRewardCount = shopVM.availableRewards.count
                        
                        shopVM.createReward(name: title, goldCost: cost)                        
                        if shopVM.availableRewards.count >  startingRewardCount {
                            dismiss()
                        } else {
                            showValidationError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty)
                    .accessibilityIdentifier("SaveAddRewardButton")
                    .alert("Invalid Reward", isPresented: $showValidationError){
                        Button("OK", role: .cancel){}
                            .accessibilityIdentifier("DuplicateRewardOKButton")
                    } message: {
                        Text("A reward with this title already exists.")
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
 
#Preview {
    AddRewardSheet()
        .environmentObject(ShopViewModel())
}
