//
//  TestView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//


//
//  A_FAQs.swift
//  myShelf
//
//  Created by user3 on 07/05/24.
//

import SwiftUI

struct UserDetailView: View {
    let userViewModel = UserViewModel()
    let memberID: String // Member ID for which to fetch user details
    @State private var memberData: MemberData?
    
    var body: some View {
        VStack {
            if let memberData = memberData {
                Text("Name: \(memberData.name)")
                Text("Gender: \(memberData.gender)")
                Text("Membership Duration: \(memberData.membershipDuration) months")
                Text("Last Read Genre: \(memberData.lastReadGenre)")
                Text("Number of Issued Books: \(memberData.noOfIssuedBooks)")
                Text("Premium: \(memberData.isPremium ? "Yes" : "No")")
            } else {
                Text("Loading user details...")
            }
        }
        .onAppear {
            // Fetch user details when the view appears
            userViewModel.fetchUserDetails(for: memberID) { fetchedMemberData in
                // Update memberData state variable with fetched user details
                memberData = fetchedMemberData
            }
        }
    }
    
    // Function to format Date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    UserDetailView(memberID: "")
        .preferredColorScheme(.dark)
}
