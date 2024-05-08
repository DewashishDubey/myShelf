//
//  MWishlistView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI
import Firebase

struct MWishlistView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var wishlistBooks: [Book] = [] // Store book objects
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var showingSheet = false
    @State private var selectedBookUID: BookUID?
    var body: some View {
        if let user = viewModel.currentUser {
            ScrollView {
                VStack {
                    if !wishlistBooks.isEmpty {
                        HStack(alignment: .center) 
                        {
                            Text("My Wishlist")
                            .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                        Spacer()
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom,20)
                        ForEach(wishlistBooks, id: \.uid) 
                        { book in
                            HStack(alignment: .top, spacing: 15)
                            {
                                
                                    AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 186)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 186)
                                                .clipped()
                                        @unknown default:
                                            Text("Unknown")
                                        }
                                    }
                                        .frame(width: 120, height: 186)
                                        .clipped()
                                
                                
                                VStack(alignment: .leading,spacing: 10) {
                                    HStack{
                                        Text(book.title)
                                            .font(
                                                Font.custom("SF Pro Text", size: 18)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(.white)
                                            .frame(alignment: .topLeading)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Text(book.authors[0])
                                    .font(Font.custom("SF Pro Text", size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                                        
                                    Text(book.genre)
                                    .font(Font.custom("SF Pro Text", size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Text(book.description)
                                    .font(Font.custom("SF Pro Text", size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .lineLimit(5)
                                    .padding(.bottom,10)
                                    StarsView(rating: Float(book.rating) ?? 0.0, maxRating: 5)
                                    
                                }
                                .padding(0)
                                .frame(alignment: .leading)
                            }
                            .padding(.top,10)
                            .padding(.bottom,20)
                            .padding(0)
                            .onTapGesture {
                                showingSheet.toggle()
                                selectedBookUID = BookUID(id: book.uid)
                            }
                            .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                                            MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                                
                            }
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity,maxHeight: 1)
                            .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        }
                        
                    } else {
                        Text("Wishlist is empty")
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.black.ignoresSafeArea(.all))
            .onAppear {
                fetchWishlist(for: user.id)
                firebaseManager.fetchBooks()
            }
        }
    }
    private func fetchWishlist(for userID: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("members").document(userID)
        
        // Fetch initial wishlist data
        userRef.collection("wishlist").getDocuments { [self] snapshot, error in
            if let error = error {
                print("Error fetching wishlist: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Wishlist is empty")
                return
            }
            
            let bookUIDs = documents.compactMap { $0.documentID }
            
            if bookUIDs.isEmpty {
                print("No books in wishlist")
                return
            }
            
            // Fetch books using bookUIDs
            let booksRef = db.collection("books")
            booksRef.whereField("uid", in: bookUIDs).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No matching books found")
                    return
                }
                
                // Convert Firestore documents to Book objects
                self.wishlistBooks = documents.compactMap { document in
                    let data = document.data()
                    return Book(
                        title: data["title"] as? String ?? "",
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
                        uid: data["uid"] as? String ?? "",
                        noOfRatings: data["noOfRatings"] as? String ?? "",
                        isActive: data["isActive"] as? Bool ?? true
                    )
                }
            }
        }
        
        // Add a real-time listener to update the wishlist books locally whenever changes occur
        userRef.collection("wishlist").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching wishlist snapshot: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Wishlist snapshot is empty")
                return
            }
            
            let bookUIDs = documents.compactMap { $0.documentID }
            
            if bookUIDs.isEmpty {
                print("No books in wishlist snapshot")
                self.wishlistBooks = [] // Clear wishlist books
                return
            }
            
            // Fetch books using bookUIDs
            let booksRef = db.collection("books")
            booksRef.whereField("uid", in: bookUIDs).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No matching books found")
                    return
                }
                
                // Convert Firestore documents to Book objects
                self.wishlistBooks = documents.compactMap { document in
                    let data = document.data()
                    return Book(
                        title: data["title"] as? String ?? "",
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
                        uid: data["uid"] as? String ?? "",
                        noOfRatings: data["noOfRatings"] as? String ?? "",
                        isActive: data["isActive"] as? Bool ?? true
                    )
                }
            }
        }
    }

}


struct MWishlistView_Previews: PreviewProvider {
    static var previews: some View {
        MWishlistView()
    }
}
