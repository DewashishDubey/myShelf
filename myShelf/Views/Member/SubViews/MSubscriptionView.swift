//
//  MSubscriptionView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 30/04/24.
//

import SwiftUI
import Firebase
import StoreKit

struct MSubscriptionView: View {
    @State private var isMonthlySelected = false
        @State private var isYearlySelected = false
        @State private var amt = 0
    
    @State var isPurchased = false
    @EnvironmentObject var storeVM: StoreVM
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        NavigationView{
            //ScrollView(showsIndicators: false)
            //{
                ZStack
            {
                //Color.black.ignoresSafeArea(.all)
                Image("back")
                    .resizable()
                
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0), Color.black.opacity(1.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
                VStack(alignment: .center, spacing:20){
                    HStack{
                        
                        Text("Myshelf")
                            .font(
                                Font.custom("SF Pro", size: 24)
                                    .weight(.bold)
                            )
                            .foregroundColor(.white)
                        Text("Premium")
                            .font(
                                Font.custom("SF Pro", size: 24)
                                    .weight(.bold)
                            )
                            .foregroundColor(.yellow)
                        
                    }
                    .padding(.top,10)
                    .padding(.bottom,20)
                    
                    Text("Choose your Plan")
                        .font(
                            Font.custom("SF Pro", size: 15)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .padding(.bottom,20)
                    
                    ForEach(storeVM.subscriptions) { product in
                        Button(action: {
                            Task {
                                await buy(product: product)
                                if(product.displayName == "Monthly")
                                {
                                    isMonthlySelected.toggle()
                                    isYearlySelected = false
                                    self.amt = 99
                                    let subscriptionStartDate = Calendar.current.date(byAdding: .month, value: isMonthlySelected ? 6 : 12, to: Date()) ?? Date()
                                    updateSubscriptionInFirestore(isPremium: true, subscriptionStartDate: subscriptionStartDate)
                                    updateAdminDocument(withAmount: amt)
                                    // Dismiss the view after Firestore update
                                    presentationMode.wrappedValue.dismiss()
                                }
                                else if(product.displayName == "Yearly")
                                {
                                    isYearlySelected.toggle()
                                    isMonthlySelected = false
                                    self.amt = 999
                                    let subscriptionStartDate = Calendar.current.date(byAdding: .month, value: isMonthlySelected ? 6 : 12, to: Date()) ?? Date()
                                    updateSubscriptionInFirestore(isPremium: true, subscriptionStartDate: subscriptionStartDate)
                                    updateAdminDocument(withAmount: amt)
                                    // Dismiss the view after Firestore update
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        })
                        {
                            
                            HStack(alignment: .center, spacing: 5) {
                                
                                
                                Text(product.displayName)
                                    .font(Font.custom("SF Pro", size: 19))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                
                                
                                Text(product.displayPrice)
                                    .font(Font.custom("SF Pro", size: 19))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .frame(width: 353, alignment: .leading)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                            //.padding(.bottom,20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isYearlySelected ? Color.blue : Color.clear, lineWidth: 1)
                            )
                            .padding(.bottom,20)
                            /*HStack {
                             Text(product.displayPrice)
                             Text(product.displayName)
                             }*/
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing:20){
                        HStack{
                            Image(systemName: "clock.arrow.circlepath")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                            
                                .frame(width: 20, alignment: .top)
                            
                            Text("Reserve books in advance")
                                .font(
                                    Font.custom("SF Pro Text", size: 15)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                            
                        }
                        
                        HStack{
                            Image(systemName: "square.stack.3d.up.fill")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                            
                                .frame(width: 20, alignment: .top)
                            
                            Text("Borrow up to 5 books simultaneously")
                                .font(
                                    Font.custom("SF Pro Text", size: 15)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                        }
                        HStack{
                            Image(systemName: "person.fill.badge.plus")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                            
                                .frame(width: 20, alignment: .top)
                            
                            Text("Priority access to high-profile events")
                                .font(
                                    Font.custom("SF Pro Text", size: 15)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                        }
                        HStack{
                            Image(systemName: "calendar")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                            
                                .frame(width: 20, alignment: .top)
                            
                            Text("Extended Borrowing Period")
                                .font(
                                    Font.custom("SF Pro Text", size: 15)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                    
                }
            }
                
            //}
        }
       
    }
    func updateSubscriptionInFirestore(isPremium: Bool, subscriptionStartDate: Date) {
            let db = Firestore.firestore()
            guard let user = Auth.auth().currentUser else {
                // User not logged in
                return
            }

            let userRef = db.collection("members").document(user.uid)
            userRef.updateData([
                "is_premium": isPremium,
                "subscription_start_date": subscriptionStartDate
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    
    func updateAdminDocument(withAmount amount: Int) {
            let db = Firestore.firestore()
            let adminDocumentRef = db.collection("admin").document("adminDocument")
            
            adminDocumentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    var currentRevenue = document.data()?["revenue"] as? Int ?? 0
                    currentRevenue += amount
                    
                    adminDocumentRef.updateData([
                        "revenue": currentRevenue
                    ]) { error in
                        if let error = error {
                            print("Error updating admin document: \(error)")
                        } else {
                            print("Admin document successfully updated with revenue \(currentRevenue)")
                        }
                    }
                } else {
                    print("Admin document does not exist")
                }
            }
        }
    
    func buy(product: Product) async {
        do {
            if try await storeVM.purchase(product) != nil {
                isPurchased = true
            }
        } catch {
            print("purchase failed")
        }
    }
}

struct RadioButtonView: View {
    @Binding var selected: Bool
    
    var body: some View {
        Button(action: {
            selected.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(selected ? Color.blue : Color.white)
                    .frame(width: 20, height: 20)
                
                if selected {
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct ButtonStyle2: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .frame(width: 353, height: 50, alignment: .leading)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .cornerRadius(8)
    }
}

#Preview {
    MSubscriptionView()
        .environmentObject( StoreVM())
        .preferredColorScheme(.dark)
}
