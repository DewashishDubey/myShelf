//
//  Member.swift
//  myShelf
//
//  Created by Dewashish Dubey on 08/05/24.
//

import FirebaseFirestore

struct MemberData {
    let id: String
    let isPremium: Bool
    let lastReadGenre: String
    let membershipDuration: Int
    let name: String
    let noOfIssuedBooks: Int
    let subscriptionStartDate: Timestamp
    let gender: String
}

struct UserViewModel {
    // Function to fetch user details for a given memberID
    func fetchUserDetails(for memberID: String, completion: @escaping (MemberData?) -> Void) {
        // Assuming you're fetching data from Firestore
        let db = Firestore.firestore()
        let usersCollection = db.collection("members")
        
        // Query Firestore to get the user document with the given memberID
        usersCollection.document(memberID).getDocument { (document, error) in
            // Check for errors
            if let error = error {
                print("Error fetching user details: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check if document exists
            guard let document = document, document.exists else {
                print("User document does not exist")
                completion(nil)
                return
            }
            
            // Parse user data from the document
            if let userData = document.data(),
               let id = userData["id"] as? String,
               let isPremium = userData["is_premium"] as? Bool,
               let lastReadGenre = userData["lastReadGenre"] as? String,
               let membershipDuration = userData["membership_duration"] as? Int,
               let name = userData["name"] as? String,
               let noOfIssuedBooks = userData["no_of_issued_books"] as? Int,
               let subscriptionStartDateTimestamp = userData["subscription_start_date"] as? Timestamp,
               let gender = userData["gender"] as? String {
                
                // Convert Timestamp to Date
                
                // Create MemberData object
                let memberData = MemberData(id: id,
                                            isPremium: isPremium,
                                            lastReadGenre: lastReadGenre,
                                            membershipDuration: membershipDuration,
                                            name: name,
                                            noOfIssuedBooks: noOfIssuedBooks,
                                            subscriptionStartDate: subscriptionStartDateTimestamp,
                                            gender: gender)
                
                // Call completion handler with user details
                completion(memberData)
            } else {
                print("Failed to parse user data")
                completion(nil)
            }
        }
    }
}
