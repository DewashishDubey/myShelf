//
//  MCheckMembershipView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 04/05/24.
//

import SwiftUI
import Firebase

struct MCheckMembershipView: View {
    @State private var isPremium: Bool?
    @State private var subscriptionStartDate: Date?
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var AlertMsg = ""
    var body: some View {
        VStack {
            if let isPremium = isPremium {
                if isPremium {
                    NavigationView{
                        ZStack{
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
                                
                                VStack(alignment:.leading,spacing:5){
                                    Text("You’re on a")
                                        .font(
                                            Font.custom("SF Pro", size: 24)
                                                .weight(.semibold)
                                        )
                                        .foregroundColor(.white)
                                    
                                    HStack(alignment:.center,spacing:5){
                                        Text("Myshelf")
                                            .font(
                                                Font.custom("SF Pro", size: 24)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.white)
                                        
                                        Text("Premium")
                                            .font(
                                                Font.custom("SF Pro", size: 24)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.yellow)
                                    }
                                    HStack(alignment:.center,spacing: 5){
                                        
                                        Text("Plan till")
                                            .font(
                                                Font.custom("SF Pro", size: 24)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.white)
                                        Text("\(subscriptionStartDate ?? Date.now, formatter: dateFormatter)")
                                            .font(
                                                Font.custom("SF Pro", size: 24)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.white)
                                            .background(.red)
                                    }
                                    
                                }
                                .padding(.bottom,190)
                                
                                /*Text("204 days left for your next billing")
                                    .font(
                                        Font.custom("SF Pro", size: 14)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(.white)
                                    .padding(.bottom,150)*/
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
                                .padding(.bottom,20)
                                  
                                Button{
                                    cancelSubscription()
                                }label: {
                                    Text("Cancel Subscription →")
                                        .foregroundStyle(Color(uiColor: .white))
                                        .padding(10)
                                        .frame(width: 350,height: 50)
                                        .background(Color(red: 0.26, green: 0.52, blue: 0.96)).cornerRadius(8)
                                        .padding(.bottom,20)
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Success"), message: Text("\(AlertMsg)"), dismissButton: .default(Text("OK")){presentationMode.wrappedValue.dismiss()})
                                            }
                                    
                                
                                
                            }
                            
                        }
                        
                    }
                } else {
                    MSubscriptionView()
                }
            } else {
                ProgressView("Checking Premium Status...")
            }
        }
        .onAppear {
            checkPremiumStatus()
        }
    }
    
    func checkPremiumStatus() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            // User not logged in
            return
        }

        let userRef = db.collection("members").document(user.uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.isPremium = document.data()?["is_premium"] as? Bool
                self.subscriptionStartDate = (document.data()?["subscription_start_date"] as? Timestamp)?.dateValue()
            } else {
                print("Member document does not exist")
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .long
           formatter.timeStyle = .none
           return formatter
       }()
    
    func cancelSubscription() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            // User not logged in
            return
        }

        let userRef = db.collection("members").document(user.uid)
        userRef.updateData(["is_premium": false]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                // Handle error
            } else {
                print("Subscription cancelled successfully")
                // Optionally, you may want to update the local state to reflect the change
                //self.isPremium = false
                AlertMsg = "Subscription Revoked Successfully"
                showAlert = true
            }
        }
    }
}


#Preview {
    MCheckMembershipView()
}
