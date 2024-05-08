//
//  ExtensionRequests.swift
//  myShelf
//
//  Created by Dewashish Dubey on 01/05/24.
//



import SwiftUI
import FirebaseFirestore
import Combine

struct ExtensionRequestData {
    var documentID: String
    var reservedBookID: String
    var uid: String
    var userID: String
    var book: Book? // Add a property to hold the associated book data
    var user: User1? // Add a property to hold the associated user data
}

class ExtensionRequestViewModel: ObservableObject {
    @Published var extensionRequests: [ExtensionRequestData] = []
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchData() {
        listenerRegistration = db.collection("extension_requests").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.extensionRequests = documents.compactMap { document in
                let data = document.data()
                guard let documentID = data["documentID"] as? String,
                      let reservedBookID = data["reservedBookID"] as? String,
                      let uid = data["uid"] as? String,
                      let userID = data["userID"] as? String else {
                    return nil
                }
                return ExtensionRequestData(documentID: documentID,
                                            reservedBookID: reservedBookID,
                                            uid: uid,
                                            userID: userID,
                                            book: nil, // Initialize book as nil
                                            user: nil) // Initialize user as nil
            }
            
            // Fetch book and user data for each extension request
            self.fetchDataForExtensionRequests()
        }
    }
    
    private func fetchDataForExtensionRequests() {
        for index in 0..<extensionRequests.count {
            let request = extensionRequests[index]
            
            // Fetch book data
            request.fetchBookData { result in
                switch result {
                case .success(let book):
                    // Update the extension request with fetched book data
                    self.extensionRequests[index].book = book
                case .failure(let error):
                    print("Error fetching book data: \(error)")
                }
            }
            
            // Fetch user data
            request.fetchUserData { result in
                switch result {
                case .success(let user):
                    // Update the extension request with fetched user data
                    self.extensionRequests[index].user = user
                case .failure(let error):
                    print("Error fetching user data: \(error)")
                }
            }
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

extension ExtensionRequestData {
    func fetchBookData(completion: @escaping (Result<Book, Error>) -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(reservedBookID)
        
        bookRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    completion(.failure(FirebaseError.invalidData))
                    return
                }
                // Parse fetched data and create a Book object
                let fetchedBook = Book(title: data["title"] as? String ?? "",
                                       authors: data["authors"] as? [String] ?? [],
                                       description: data["description"] as? String ?? "",
                                       edition: data["edition"] as? String ?? "",
                                       genre: data["genre"] as? String ?? "",
                                       imageUrl: data["imageUrl"] as? String ?? "",
                                       language: data["language"] as? String ?? "",
                                       noOfCopies: data["noOfCopies"] as? String ?? "",
                                       noOfPages: data["noOfPages"] as? String ?? "",
                                       publicationDate: data["publicationDate"] as? String ?? "",
                                       publisher: data["publisher"] as? String ?? "",
                                       rating: data["rating"] as? String ?? "",
                                       shelfLocation: data["shelfLocation"] as? String ?? "",
                                       uid: document.documentID,
                                       noOfRatings: data["noOfRatings"] as? String ?? "",
                                       isActive: data["isActive"] as? Bool ?? true
                )
                completion(.success(fetchedBook))
            } else {
                completion(.failure(error ?? FirebaseError.unknownError))
            }
        }
    }
    
    func fetchUserData(completion: @escaping (Result<User1, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("members").document(userID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    completion(.failure(FirebaseError.invalidData))
                    return
                }
                // Parse fetched data and create a User object
                let fetchedUser = User1(isPremium: data["is_premium"] as? Bool ?? false,
                                        lastReadGenre: data["lastReadGenre"] as? String ?? "",
                                        membershipDuration: data["membership_duration"] as? Int ?? 0,
                                        name: data["name"] as? String ?? "",
                                        noOfIssuedBooks: data["no_of_issued_books"] as? Int ?? 0,
                                        subscriptionStartDate: data["subscription_start_date"] as? Timestamp ?? Timestamp(),
                                        gender: data["gender"] as? String ?? ""
                )
                completion(.success(fetchedUser))
            } else {
                completion(.failure(error ?? FirebaseError.unknownError))
            }
        }
    }
}

struct User1 {
    let isPremium: Bool
    let lastReadGenre: String
    let membershipDuration: Int
    let name: String
    let noOfIssuedBooks: Int
    let subscriptionStartDate: Timestamp
    let gender : String
}



enum FirebaseError: Error {
    case invalidData
    case unknownError
}

