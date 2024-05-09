//
//  PreviouslyIssuedBooks.swift
//  myShelf
//
//  Created by Dewashish Dubey on 29/04/24.
//

import Foundation
import Firebase

class PreviouslyReservedBooksViewModel: ObservableObject {
    @Published var reservedBooks: [ReservedBook] = []

    func fetchReservedBooks(for memberID: String) {
        let db = Firestore.firestore()
        let membersRef = db.collection("members")

        membersRef.document(memberID).collection("previously_issued_books").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching reserved books: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No reserved books found for member \(memberID)")
                return
            }

            var reservedBooks: [ReservedBook] = []
            let dispatchGroup = DispatchGroup() // Dispatch group to handle asynchronous tasks

            for document in documents {
                let bookID = document["bookID"] as? String ?? ""
                let documentID = document.documentID
                let endDateTimestamp = document["end_date"] as? Timestamp
                let startDateTimestamp = document["start_date"] as? Timestamp
                let fine = document["fine"] as? Int ?? 0
                let hasRated = document["hasRated"] as? Bool ?? false
                dispatchGroup.enter() // Enter the dispatch group

                // Fetch the details of the book using its bookID
                fetchBookDetails(for: bookID) { book in
                    let endDateString = self.formatDate(endDateTimestamp?.dateValue())
                    let startDateString = self.formatDate(startDateTimestamp?.dateValue())

                    reservedBooks.append(ReservedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, fine: fine, book: book, hasRated: hasRated))

                    dispatchGroup.leave() // Leave the dispatch group when finished
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.reservedBooks = reservedBooks
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
    
    func fetchReservedBook(for memberID: String, documentID: String) {
        let db = Firestore.firestore()
        let issuedBookRef = db.collection("members").document(memberID).collection("issued_books").document(documentID)

        issuedBookRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching issued book: \(error)")
                return
            }

            guard let document = document, document.exists else {
                print("No issued book found for document ID \(documentID)")
                return
            }

            let data = document.data()!
            let bookID = data["bookID"] as? String ?? ""
            let startDateTimestamp = data["start_date"] as? Timestamp
            let endDateTimestamp = data["end_date"] as? Timestamp
            let fine = data["fine"] as? Int ?? 0
            let hasRated = data["hasRated"] as? Bool ?? false

            // Fetch book details using bookID
            self.fetchBookDetails(for: bookID) { book in
                let startDateString = self.formatDate(startDateTimestamp?.dateValue())
                let endDateString = self.formatDate(endDateTimestamp?.dateValue())

                let reservedBook = ReservedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, fine: fine, book: book, hasRated: hasRated)

                // Append the fetched reserved book to the published property
                DispatchQueue.main.async {
                    self.reservedBooks.append(reservedBook)
                }
            }
        }
    }

    func fetchPreviouslyReservedBook(for memberID: String, documentID: String) {
        let db = Firestore.firestore()
        let issuedBookRef = db.collection("members").document(memberID).collection("previously_issued_books").document(documentID)

        issuedBookRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching issued book: \(error)")
                return
            }

            guard let document = document, document.exists else {
                print("No issued book found for document ID \(documentID)")
                return
            }

            let data = document.data()!
            let bookID = data["bookID"] as? String ?? ""
            let startDateTimestamp = data["start_date"] as? Timestamp
            let endDateTimestamp = data["end_date"] as? Timestamp
            let fine = data["fine"] as? Int ?? 0
            let hasRated = data["hasRated"] as? Bool ?? false

            // Fetch book details using bookID
            self.fetchBookDetails(for: bookID) { book in
                let startDateString = self.formatDate(startDateTimestamp?.dateValue())
                let endDateString = self.formatDate(endDateTimestamp?.dateValue())

                let reservedBook = ReservedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, fine: fine, book: book, hasRated: hasRated)

                // Append the fetched reserved book to the published property
                DispatchQueue.main.async {
                    self.reservedBooks.append(reservedBook)
                }
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

struct ReservedBook: Identifiable {
    let id = UUID()
    let bookID: String
    let documentID: String
    let startDateString: String
    let endDateString: String
    let fine: Int
    let book: Book
    let hasRated : Bool
}
