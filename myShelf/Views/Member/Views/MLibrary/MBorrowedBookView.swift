//
//  MBorrowedBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 01/05/24.
//

//
//  MBorrowedBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 30/04/24.
//


import SwiftUI
import Firebase
struct MBorrowedBookView: View {
    var docID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var existingRequest = false
    @State private var alreadyRequested = false
    @State private var isPremium: Bool = false
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView{
               // Text(viewModel.currentUser?.id ?? "")
                VStack(spacing:20){
                    ForEach(bookViewModel.reservedBooks) { reservedBook in
                       // Text(reservedBook.documentID)
                        Text(reservedBook.book.title)
                            .font(
                            Font.custom("SF Pro Text", size: 20)
                            .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        AsyncImage(url: URL(string: reservedBook.book.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                        .frame(width: 240, height: 210)
                        .padding(5)
                        .padding(.bottom,20)
                        HStack{
                            Text("Borrowed On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.startDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Return due On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.endDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Fine Amount")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(reservedBook.fine)")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        
                        
                        
                        if(isPremium == true){
                            Button(action: {
                                requestExtension(reservedBookID: reservedBook.bookID)
                            }, label: {
                                Text("Request Extension")
                                    .font(Font.custom("SF Pro Text", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                            })
                            .alert(isPresented: $alreadyRequested) {
                                Alert(title: Text("Extension request made to librarian"))
                            }
                            
                        }

                    }
                }
            }
        }
        .onAppear{
            bookViewModel.fetchReservedBook(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1", documentID: docID)
            checkExistingExtensionRequest(reservedBooks: bookViewModel.reservedBooks)
            checkMembership()
        }
        
        
    }
    private func trimTime(from dateString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
           
           if let date = dateFormatter.date(from: dateString) {
               dateFormatter.dateFormat = "MMM d, yyyy"
               return dateFormatter.string(from: date)
           } else {
               return dateString // Return original string if unable to parse
           }
       }
    
    private func checkExistingExtensionRequest(reservedBooks: [ReservedBook]) {
        for reservedBook in reservedBooks {
            let db = Firestore.firestore()
            db.collection("extension_requests")
                .whereField("reservedBookID", isEqualTo: reservedBook.bookID)
                .whereField("userID", isEqualTo: viewModel.currentUser?.id ?? "")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        // Assume error means no document exists
                        existingRequest = false
                    } else {
                        existingRequest = !(querySnapshot?.documents.isEmpty ?? false)
                    }
                }
        }
    }
    private func requestExtension(reservedBookID: String) {
        guard let currentUserID = viewModel.currentUser?.id else {
            // Handle the case when currentUser is nil
            return
        }
        
        let db = Firestore.firestore()
        let extensionRequestsRef = db.collection("extension_requests")
        
        // Check if an extension request already exists for the reserved book
        extensionRequestsRef
            .whereField("reservedBookID", isEqualTo: reservedBookID)
            .whereField("userID", isEqualTo: currentUserID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    // Handle error gracefully if needed
                    return
                }
                
                // If no existing extension request found, add a new one
                if querySnapshot?.documents.isEmpty ?? true {
                    let extensionRequestRef = extensionRequestsRef.document()
                    extensionRequestRef.setData([
                        "userID": currentUserID,
                        "reservedBookID": reservedBookID,
                        "documentID": docID,
                        "uid": extensionRequestRef.documentID
                    ]) { error in
                        if let error = error {
                            // Handle any errors that occur while adding the document
                            print("Error adding document: \(error)")
                        } else {
                            // Document added successfully
                            let uid = extensionRequestRef.documentID
                            print("Extension request added successfully with UID: \(uid)")
                            // Show alert
                            alreadyRequested = true
                            existingRequest = true
                        }
                    }
                } else {
                    alreadyRequested = true
                    // If an existing extension request is found, do nothing or handle as needed
                    print("An extension request already exists for this book and user.")
                }
            }
    }
    
    func checkMembership() {
        guard let userID = viewModel.currentUser?.id else {
            print("User ID not available")
            return
        }
        
        let db = Firestore.firestore()
        let memberRef = db.collection("members").document(userID)
        
        memberRef.addSnapshotListener { document, error in
            if let document = document, document.exists {
                if let type = document.data()?["is_premium"] as? Bool {
                    self.isPremium = type
                } else {
                    self.isPremium = false
                }
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
               // self.lastReadGenre = "Error fetching data"
            }
        }
    }

}

#Preview {
    MBorrowedBookView(docID: "")
}

