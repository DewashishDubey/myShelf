//
//  MLibraryView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//

import SwiftUI
import FirebaseFirestore



struct MLibraryView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    
    var body: some View {
        List(firebaseManager.books, id: \.uid) { book in
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        Text("Unknown")
                    }
                }
                .frame(width: 100, height: 100) // Adjust size as needed
                
                Text(book.title)
                    .font(.headline)
                Text("Authors: \(book.authors.joined(separator: ", "))")
                    .font(.subheadline)
                Text("Description: \(book.description)")
                    .font(.subheadline)
                Text("Edition: \(book.edition)")
                    .font(.subheadline)
                Text("Genre: \(book.genre)")
                    .font(.subheadline)
                Text("Publication Date: \(book.publicationDate)")
                    .font(.subheadline)
                Text("Publisher: \(book.publisher)")
                    .font(.subheadline)
                Text("Rating: \(book.rating)")
                    .font(.subheadline)
                Text("Shelf Location: \(book.shelfLocation)")
                    .font(.subheadline)
                Text("Number of Pages: \(book.noOfPages)")
                    .font(.subheadline)
                Text("Number of Copies: \(book.noOfCopies)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MLibraryView()
    }
}


/*
import SwiftUI
import FirebaseFirestore

struct Book {
    let title: String
    let authors: [String]
    let description: String
    let edition: String
    let genre: String
    let imageUrl: String
    let language: String
    let noOfCopies: String
    let noOfPages: String
    let publicationDate: String
    let publisher: String
    let rating: String
    let shelfLocation: String
    let uid: String
}

class FirebaseManager: ObservableObject {
    @Published var books: [Book] = []
    
    private var db = Firestore.firestore()
    
    func fetchBooks() {
        db.collection("books").getDocuments { snapshot, error in
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
                              let uid = data["uid"] as? String else {
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
                                    uid: uid)
                    }
                }
            }
        }
    }
}

struct MLibraryView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    
    var body: some View {
        List(firebaseManager.books, id: \.uid) { book in
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.headline)
                Text("Authors: \(book.authors.joined(separator: ", "))")
                    .font(.subheadline)
                Text("Description: \(book.description)")
                    .font(.subheadline)
                Text("Edition: \(book.edition)")
                    .font(.subheadline)
                Text("Genre: \(book.genre)")
                    .font(.subheadline)
                Text("Publication Date: \(book.publicationDate)")
                    .font(.subheadline)
                Text("Publisher: \(book.publisher)")
                    .font(.subheadline)
                Text("Rating: \(book.rating)")
                    .font(.subheadline)
                Text("Shelf Location: \(book.shelfLocation)")
                    .font(.subheadline)
                Text("Number of Pages: \(book.noOfPages)")
                    .font(.subheadline)
                Text("Number of Copies: \(book.noOfCopies)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MLibraryView()
    }
}
*/


