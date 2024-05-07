//
//  Participants.swift
//  myShelf
//
//  Created by Dewashish Dubey on 07/05/24.
//

import SwiftUI
import Firebase

struct Participant: Identifiable {
    var id = UUID()
    var eventID: String
    var memberID: String
    var user: User1?
}

class ParticipantsViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    
    func fetchParticipants(forEventWithID eventID: String) {
            let db = Firestore.firestore()
            
            db.collection("events").document(eventID).collection("participants").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching participants: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents in participants collection")
                        return
                    }
                    
                    self.participants = documents.compactMap { queryDocumentSnapshot -> Participant in
                        let data = queryDocumentSnapshot.data()
                        let eventID = data["eventID"] as? String ?? ""
                        let memberID = data["memberID"] as? String ?? ""
                        let participant = Participant(eventID: eventID, memberID: memberID)
                        return participant
                    }
                    
                    // Fetch user details for each participant
                    for index in 0..<self.participants.count {
                        self.fetchUserDetails(for: self.participants[index])
                    }
                }
            }
        }
        
        private func fetchUserDetails(for participant: Participant) {
            let db = Firestore.firestore()
            db.collection("members").document(participant.memberID).addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching user details: \(error)")
                } else if let document = documentSnapshot, document.exists {
                    let data = document.data()
                    let user = User1(
                        isPremium: data?["isPremium"] as? Bool ?? false,
                        lastReadGenre: data?["lastReadGenre"] as? String ?? "",
                        membershipDuration: data?["membershipDuration"] as? Int ?? 0,
                        name: data?["name"] as? String ?? "",
                        noOfIssuedBooks: data?["noOfIssuedBooks"] as? Int ?? 0,
                        subscriptionStartDate: data?["subscriptionStartDate"] as? Timestamp ?? Timestamp(),
                        gender: data?["gender"] as? String ?? ""
                    )
                    // Update participant with user details
                    if let index = self.participants.firstIndex(where: { $0.memberID == participant.memberID }) {
                        self.participants[index].user = user
                    }
                } else {
                    print("User document for ID \(participant.memberID) does not exist")
                }
            }
        }
}
