//
//  FirebaseManager.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import Foundation
import Firebase

class FirebaseManager: ObservableObject {
    @Published var books: [Book] = []
    
    private var db = Firestore.firestore()
    
    func fetchBooks() {
        db.collection("books").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = snapshot?.documents {
                    self.books = documents.compactMap { document in
                        let data = document.data()
                        guard let title = data["title"] as? String,
                              let authors = data["authors"] as? [String],
                              let description = data["description"] as? String,
                              let edition = data["edition"] as? String,
                              let genre = data["genre"] as? String,
                              let imageUrl = data["imageUrl"] as? String,
                              let language = data["language"] as? String,
                              let noOfCopies = data["noOfCopies"] as? String,
                              let noOfPages = data["noOfPages"] as? String,
                              let publicationDate = data["publicationDate"] as? String,
                              let publisher = data["publisher"] as? String,
                              let rating = data["rating"] as? String,
                              let shelfLocation = data["shelfLocation"] as? String,
                              let uid = data["uid"] as? String,
                              let noOfRatings = data["noOfRatings"] as? String,
                              let isActive = data["isActive"] as? Bool
                        else {
                            return nil
                        }
                        
                        return Book(title: title,
                                    authors: authors,
                                    description: description,
                                    edition: edition,
                                    genre: genre,
                                    imageUrl: imageUrl,
                                    language: language,
                                    noOfCopies: noOfCopies,
                                    noOfPages: noOfPages,
                                    publicationDate: publicationDate,
                                    publisher: publisher,
                                    rating: rating,
                                    shelfLocation: shelfLocation,
                                    uid: uid,
                                    noOfRatings: noOfRatings,
                                    isActive: isActive
                        )
                    }
                }
            }
        }
    }
}

