//
//  IssuedBooks.swift
//  myShelf
//
//  Created by Dewashish Dubey on 29/04/24.
//

import Foundation
import Firebase

struct IssuedBook: Identifiable {
    let id = UUID()
    let bookID: String
    let documentID: String
    let startDateString: String
    let endDateString: String
    let fine: Int
    let book: Book // Details of the book
}

class IssuedBooksViewModel: ObservableObject {
    @Published var issuedBooks: [IssuedBook] = []
    
    func fetchIssuedBooks(for memberID: String) {
        let db = Firestore.firestore()
        let membersRef = db.collection("members")
        
        membersRef.document(memberID).collection("issued_books").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching issued books: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No issued books found for member \(memberID)")
                return
            }
            
            var issuedBooks: [IssuedBook] = []
            let dispatchGroup = DispatchGroup() // Dispatch group to handle asynchronous tasks
            
            for document in documents {
                let bookID = document["bookID"] as? String ?? ""
                let documentID = document.documentID
                let startDateTimestamp = document["start_date"] as? Timestamp
                let endDateTimestamp = document["end_date"] as? Timestamp
                let fine = document["fine"] as? Int ?? 0
                
                dispatchGroup.enter() // Enter the dispatch group
                
                // Fetch the details of the book using its bookID
                fetchBookDetails(for: bookID) { book in
                    let startDateString = self.formatDate(startDateTimestamp?.dateValue())
                    let endDateString = self.formatDate(endDateTimestamp?.dateValue())
                    
                    issuedBooks.append(IssuedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, fine: fine, book: book))
                    
                    dispatchGroup.leave() // Leave the dispatch group when finished
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.issuedBooks = issuedBooks
            }
        }
    }

    func fetchBookDetails(for bookID: String, completion: @escaping (Book) -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookID)
        
        bookRef.getDocument { document, error in
            if let error = error {
                print("Error fetching document for book ID \(bookID): \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist for book ID \(bookID)")
                return
            }
            
            let data = document.data()!
            let book = Book(
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
            
            completion(book)
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


