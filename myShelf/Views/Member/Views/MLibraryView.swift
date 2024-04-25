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



