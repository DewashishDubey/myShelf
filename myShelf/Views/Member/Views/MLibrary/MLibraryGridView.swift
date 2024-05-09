//
//  MLibraryGridView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 29/04/24.
//

import SwiftUI
import Firebase

struct MLibraryGridView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var issuedBooksViewModel = IssuedBooksViewModel()
    @StateObject private var previouslyIssuedBooksViewModel = PreviouslyReservedBooksViewModel()
    @State private var searchText = ""
    @State private var searchIsActive = false
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(issuedBooksViewModel.issuedBooks) { issuedBook in
                        NavigationLink{
                            MBorrowedBookView(docID: issuedBook.documentID)
                        }label: {
                            AsyncImage(url: URL(string: issuedBook.book.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 104, height: 154.64)
                                        .padding(5)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 104, height: 154.64)
                                        .padding(5)
                                @unknown default:
                                    Text("Unknown")
                                }
                            }
                            .frame(width: 104, height: 154.64)
                            .padding(5)
                        }
                        
                    }
                    ForEach(previouslyIssuedBooksViewModel.reservedBooks) { PreviouslyReservedBook in
                        AsyncImage(url: URL(string: PreviouslyReservedBook.book.imageUrl)) { phase in
                            NavigationLink{
                                MPreviouslyIssuedBooksView(docID: PreviouslyReservedBook.documentID)
                            }label: {
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 104, height: 154.64)
                                        .padding(5)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 104, height: 154.64)
                                        .padding(5)
                                @unknown default:
                                    Text("Unknown")
                                }
                            }
                            .frame(width: 104, height: 154.64)
                            .padding(5)
                        }
                    }
                }
                .onAppear {
                    issuedBooksViewModel.fetchIssuedBooks(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1")
                    previouslyIssuedBooksViewModel.fetchReservedBooks(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1")
                }
            }
            //.searchable(text: $searchText, isPresented: $searchIsActive)
        }
    }
}




#Preview {
    MLibraryGridView()
}


/*
import SwiftUI
import Firebase

struct MLibraryGridView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Define a property to hold the issued books
    @State private var issuedBooks: [IssuedBook] = []
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            NavigationView {
                ScrollView(showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(issuedBooks) { book in
                            VStack(alignment: .leading) {
                                Text("Book ID: \(book.bookID)")
                                Text("Document ID: \(book.documentID)")
                                Text("Start Date: \(book.startDateString)")
                                Text("End Date: \(book.endDateString)")
                                Text("Fine: \(book.fine)")
                            }
                            .padding()
                        }
                    }
                }
               // .searchable(text: $searchText, isPresented: $searchIsActive)
                .onAppear {
                    fetchIssuedBooks()
                }
            }
        }
    }
    
    // Function to fetch issued books from Firestore
    func fetchIssuedBooks() {
        let db = Firestore.firestore()
        
        // Reference to the "members" collection
        let membersRef = db.collection("members")
        
        // Query for the member with the provided ID
        membersRef.whereField("id", isEqualTo: viewModel.currentUser?.id ?? "").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching member: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                let memberID = document.documentID
                
                // Check if the member has an "issued_books" sub-collection
                let issuedBooksRef = membersRef.document(memberID).collection("issued_books")
                issuedBooksRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching issued books: \(error)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("No issued books found for member \(memberID)")
                        return
                    }
                    
                    for bookDocument in documents {
                        // Extract attributes from each book document
                        let bookID = bookDocument["bookID"] as? String ?? ""
                        let documentID = bookDocument.documentID
                        let startDateTimestamp = bookDocument["start_date"] as? Timestamp
                        let endDateTimestamp = bookDocument["end_date"] as? Timestamp
                        let fine = bookDocument["fine"] as? Int ?? 0
                        
                        // Convert Timestamps to Date strings
                        let startDateString = formatDate(startDateTimestamp?.dateValue())
                        let endDateString = formatDate(endDateTimestamp?.dateValue())
                        
                        // Append IssuedBook object to the issuedBooks array
                        issuedBooks.append(IssuedBook(bookID: bookID, documentID: documentID, startDateString: startDateString, endDateString: endDateString, fine: fine))
                    }
                }
            }
        }
    }
    
    // Function to format Date
    func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
}

// Struct to represent Issued Book
struct IssuedBook: Identifiable {
    let id = UUID()
    let bookID: String
    let documentID: String
    let startDateString: String
    let endDateString: String
    let fine: Int
}

// Preview
struct MLibraryGridView_Previews: PreviewProvider {
    static var previews: some View {
        MLibraryGridView()
    }
}

*/
