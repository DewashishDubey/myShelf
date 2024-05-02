//
//  LReturnDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LReturnDetailView: View {
    let MemberID: String
    @State private var member: Member?
    var body: some View {
        VStack {
            if let member = member {
                Text("Member Name: \(member.name)")
                Text("Is Premium: \(member.isPremium ? "Yes" : "No")")
                Text("Last Read Genre: \(member.lastReadGenre)")
                Text("Number of Issued Books: \(member.numberOfIssuedBooks)")
                Text("Subscription Start Date: \(formattedDate(member.subscriptionStartDate))")
            } else {
                Text("Loading...")
            }
            Button(action: {
                
            }) {
                Text("Submit")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .onAppear {
            fetchMemberDetails(memberID: MemberID)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
    
    func fetchMemberDetails(memberID: String) {
        let db = Firestore.firestore()
        let membersRef = db.collection("members")
        
        membersRef.document(memberID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let isPremium = data?["is_premium"] as? Bool ?? false
                let lastReadGenre = data?["lastReadGenre"] as? String ?? ""
                let name = data?["name"] as? String ?? ""
                let numberOfIssuedBooks = data?["no_of_issued_books"] as? Int ?? 0
                
                // Assuming the subscription_start_date is stored as a Timestamp
                let subscriptionStartDateTimestamp = data?["subscription_start_date"] as? Timestamp ?? Timestamp(date: Date())
                let subscriptionStartDate = subscriptionStartDateTimestamp.dateValue()
                
                self.member = Member(id: id, isPremium: isPremium, lastReadGenre: lastReadGenre, name: name, numberOfIssuedBooks: numberOfIssuedBooks, subscriptionStartDate: subscriptionStartDate)
            } else {
                print("Document does not exist")
            }
        }
    }
    
}

#Preview {
    LReturnDetailView(MemberID: "")
}
