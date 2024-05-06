//
//  MPayFineView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 06/05/24.
//

import SwiftUI
import Firebase
import StoreKit
struct MPayFineView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var dueAmount: Int = 0
    @StateObject var storeVM = StoreVM()
    var body: some View {
        ZStack
        {
            Color.black.ignoresSafeArea(.all)
            ScrollView{
                VStack
                {
                    if dueAmount>0
                    {
                        ForEach(Array(storeVM.consumables.enumerated()), id: \.element.id) { index, product in
                            Button(action: {
                                purchaseConsumable(product: product)
                            }) {
                                HStack{
                                    Text("Pay Dues")
                                        .font(
                                            Font.custom("SF Pro", size: 12)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(dueAmount)")
                                        .font(
                                            Font.custom("SF Pro", size: 12)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                                .cornerRadius(8)
                                .padding(.horizontal,10)
                            }
                        }
                    }
                    else
                    {
                        Text("No Payment Requests")
                    }
                }
                .padding(.top,20)
            }
        }
        .onAppear {
                   fetchDueAmount() // Fetch due amount when the view appears
               }
    }
    func fetchDueAmount() {
           guard let currentUserID = viewModel.currentUser?.id else {
               print("Current user ID is nil.")
               return
           }
           
           let db = Firestore.firestore()
           let memberRef = db.collection("members").document(currentUserID)
           
           memberRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   if let due = document.get("due") as? Int {
                       self.dueAmount = due // Update dueAmount state variable
                   } else {
                       print("Due attribute not found or not of type Int.")
                   }
               } else {
                   print("Member document not found.")
               }
           }
       }
    
    func purchaseConsumable(product: Product) {
        storeVM.purchaseConsumable(product: product) { error in
            if let error = error {
                // Handle error
                print("Error purchasing  \(error)")
            } else {
                // Purchase succeeded, you may want to update the UI or perform other actions
                print("Successfully purchased ")
            }
        }
    }
}

#Preview {
    MPayFineView()
}
