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
    var body: some View {
        VStack {
            if let isPremium = isPremium {
                if isPremium {
                    Text("You are a premium member. Subscription End Date: \(subscriptionStartDate ?? Date.now, formatter: dateFormatter)")
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
}


#Preview {
    MCheckMembershipView()
}
