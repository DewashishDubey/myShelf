//
//  AllIssuedBooks.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//

struct AllIssuedBook: Identifiable {
    let id = UUID()
    let bookID: String
    let documentID: String
    let startDateString: String
    let endDateString: String
    let memberID: String
    let book: Book // Details of the book
    var user: User1?
}


import Foundation
import Firebase
class AllIssuedBooksViewModel: ObservableObject {
    @Published var issuedBooks: [AllIssuedBook] = []
    
    func fetchIssuedBooks() {
        let db = Firestore.firestore()
        
        db.collection("books_issued").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching issued books: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No issued books found")
                return
            }
            
            var issuedBooks: [AllIssuedBook] = []
            let dispatchGroup = DispatchGroup() // Dispatch group to handle asynchronous tasks
            
            for document in documents {
                let bookID = document["bookID"] as? String ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1"
                let documentID = document.documentID
                let startDateTimestamp = document["start_date"] as? Timestamp
                let endDateTimestamp = document["end_date"] as? Timestamp
                let memberID = document["memberID"] as? String ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1"
                
                dispatchGroup.enter() // Enter the dispatch group
                
                // Fetch the details of the book using its bookID
                fetchBookDetails(for: bookID, memberID: memberID) { book, user in
                    let startDateString = self.formatDate(startDateTimestamp?.dateValue())
                    let endDateString = self.formatDate(endDateTimestamp?.dateValue())
                    
                    issuedBooks.append(AllIssuedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, memberID: memberID, book: book, user: user))
                    
                    dispatchGroup.leave() // Leave the dispatch group when finished
                }

            }
            
            dispatchGroup.notify(queue: .main) {
                self.issuedBooks = issuedBooks
            }
        }
    }

    func fetchBookDetails(for bookID: String, memberID: String, completion: @escaping (Book, User1) -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookID)
        let userRef = db.collection("members").document(memberID)
        
        var book: Book?
        var user: User1?
        
        // Create a DispatchGroup to handle asynchronous fetching of book and user data
        let dispatchGroup = DispatchGroup()
        
        // Fetch book details
        dispatchGroup.enter()
        bookRef.getDocument { document, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                print("Error fetching document for book ID \(bookID): \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist for book ID \(bookID)")
                return
            }
            
            let data = document.data()!
            book = Book(
                title: data["title"] as! String,
                authors: data["authors"] as! [String],
                description: data["description"] as! String,
                edition: data["edition"] as! String,
                genre: data["genre"] as! String,
                imageUrl: data["imageUrl"] as! String,
                language: data["language"] as! String,
                noOfCopies: data["noOfCopies"] as! String,
                noOfPages: data["noOfPages"] as! String,
                publicationDate: data["publicationDate"] as! String,
                publisher: data["publisher"] as! String,
                rating: data["rating"] as! String,
                shelfLocation: data["shelfLocation"] as! String,
                uid: data["uid"] as! String,
                noOfRatings: data["noOfRatings"] as! String,
                isActive: data["isActive"] as! Bool
            )
        }
        
        // Fetch user details
        dispatchGroup.enter()
        userRef.getDocument { document, error in
            defer {
                dispatchGroup.leave()
            }
            if let document = document, document.exists {
                guard let data = document.data() else {
                    return
                }
                // Parse fetched data and create a User object
                user = User1(
                    isPremium: data["is_premium"] as? Bool ?? false,
                    lastReadGenre: data["lastReadGenre"] as? String ?? "",
                    membershipDuration: data["membership_duration"] as? Int ?? 0,
                    name: data["name"] as? String ?? "",
                    noOfIssuedBooks: data["no_of_issued_books"] as? Int ?? 0,
                    subscriptionStartDate: data["subscription_start_date"] as? Timestamp ?? Timestamp(),
                    gender: data["gender"] as? String ?? ""
                )
            }
        }
        
        // Notify completion when both book and user data are fetched
        dispatchGroup.notify(queue: .main) {
            if let book = book, let user = user {
                completion(book, user)
            }
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
    
}

