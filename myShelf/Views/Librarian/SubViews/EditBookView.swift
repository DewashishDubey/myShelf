//
//  EditBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//

/*
import SwiftUI
import Firebase

struct EditBookView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    let bookUID: String
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isBookmarked = false
    @State private var newLocation: String = ""
    @State private var isEditing = false
    @State private var showAlert = false // State variable to control the alert
    
    init(bookUID: String) {
        self.bookUID = bookUID
        UINavigationBar.appearance().backgroundColor = .clear // Set navigation bar background color
    }
    
    var body: some View {
        ZStack{
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    if let book = firebaseManager.books.first(where: { $0.uid == bookUID }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 10)
                            
                            VStack {
                                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 140, height: 210)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 140, height: 210)
                                            .clipped()
                                            .cornerRadius(10)
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .padding()
                              
                                ButtonRow(title: "Book Activity", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                
                                ButtonRow(title: "Copies Available", detail: book.noOfCopies)
                                    .buttonStyle(PlainButtonStyle())
                                ButtonRow(title: "Currently Borrowed", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                ButtonRow(title: "Reservation Request", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                
                                EditableButtonRow(title: "Book Location", detail: book.shelfLocation, newLocation: $newLocation, isEditing: $isEditing) { newLocation in
                                    // Update book location in Firebase
                                    updateBookLocation(newLocation: newLocation, forBookUID: bookUID) { error in
                                        if let error = error {
                                            print("Error updating book location: \(error.localizedDescription)")
                                        } else {
                                            print("Book location updated successfully!")
                                            
                                        }
                                    }
                                }
                                
                                ButtonRow(title: "Print Book QR", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 5)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                firebaseManager.fetchBooks() // Fetch books when the view appears
            }
        }
        .navigationBarItems(trailing:
            Button(action: {
                deleteBook()
                dismiss()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Book Deleted"), message: Text("The book has been successfully deleted."), dismissButton: .default(Text("OK")))
            
        }
    }
    
    // Delete the book from Firebase and navigate back to the search page
    func deleteBook() {
        guard (viewModel.currentUser?.id) != nil else {
            return
        }
        
        // Reference to the Firebase database
        let db = Firestore.firestore()
        
        // Reference to the document of the book
        let bookRef = db.collection("books").document(bookUID)
        
        // Delete the document
        bookRef.delete { error in
            if let error = error {
                print("Error deleting book: \(error.localizedDescription)")
            } else {
                print("Book deleted successfully!")
                showAlert = true // Show the alert when the book is deleted successfully
                // Navigate back to the search page
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    // Function to update the location of a book in Firebase
    func updateBookLocation(newLocation: String, forBookUID bookUID: String, completion: @escaping (Error?) -> Void) {
        // Reference to the Firebase database
        let db = Firestore.firestore()
        
        // Reference to the document of the book
        let bookRef = db.collection("books").document(bookUID)
        
        // Update the location field of the document
        bookRef.updateData(["shelfLocation": newLocation]) { error in
            completion(error)
            
        }
    }
}

// Custom button row with a title and optional detail
struct ButtonRow: View {
    let title: String
    let detail: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(width: 353, height: 14)
                .padding(.vertical, 5)
            
            HStack {
                Text(title)
                Spacer()
                if let detail = detail {
                    Text(detail)
                }
                Image(systemName: "chevron.right")
            }
            
            .padding()
            .foregroundColor(.white)
        }
    }
}

// Custom editable button row with a title, detail, and editable field
struct EditableButtonRow: View {
    let title: String
    let detail: String?
    @Binding var newLocation: String
    @Binding var isEditing: Bool
    let onCommit: (String) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            
            HStack {
                Text(title)
                Spacer()
                if let detail = detail {
                    if isEditing {
                        TextField("", text: $newLocation) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            onCommit(newLocation)
                            isEditing = false
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onAppear {
                            newLocation = detail
                        }
                    } else {
                        Text(detail)
                    }
                }
                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isEditing.toggle()
                    }
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(bookUID: "")
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel()) // Inject your view model here
    }
}
*/

import SwiftUI
import Firebase

struct EditBookView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    let bookUID: String
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isBookmarked = false
    @State private var newLocation: String = ""
    @State private var isEditing = false
    @State private var showAlert = false // State variable to control the alert
    @State private var isDeleted = false // State variable to track if the book is deleted
    @State private var alertMsg = ""
    init(bookUID: String) {
        self.bookUID = bookUID
        UINavigationBar.appearance().backgroundColor = .clear // Set navigation bar background color
    }
    
    var body: some View {
        ZStack{
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    if let book = firebaseManager.books.first(where: { $0.uid == bookUID }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 10)
                            
                            VStack {
                                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 140, height: 210)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 140, height: 210)
                                            .clipped()
                                            .cornerRadius(10)
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .padding()
                              
                                ButtonRow(title: "Book Activity", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                
                                ButtonRow(title: "Copies Available", detail: book.noOfCopies)
                                    .buttonStyle(PlainButtonStyle())
                                ButtonRow(title: "Currently Borrowed", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                ButtonRow(title: "Reservation Request", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                                
                                EditableButtonRow(title: "Book Location", detail: book.shelfLocation, newLocation: $newLocation, isEditing: $isEditing) { newLocation in
                                    // Update book location in Firebase
                                    updateBookLocation(newLocation: newLocation, forBookUID: bookUID) { error in
                                        if let error = error {
                                            print("Error updating book location: \(error.localizedDescription)")
                                        } else {
                                            print("Book location updated successfully!")
                                            
                                        }
                                    }
                                }
                                
                                ButtonRow(title: "Print Book QR", detail: nil)
                                    .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 5)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                firebaseManager.fetchBooks() // Fetch books when the view appears
            }
        }
        .navigationBarItems(trailing:
            Button(action: {
                deleteBook()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Book Deleted"),
                message: Text("\(alertMsg)"),
                dismissButton: .default(Text("OK")) {
                    // Dismiss the sheet after the alert is dismissed
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }    }
    
    // Delete the book from Firebase and navigate back to the search page
    func deleteBook() {
        guard let userUID = viewModel.currentUser?.id else {
            return
        }
        
        // Reference to the Firebase database
        let db = Firestore.firestore()
        
        // Reference to the document of the book
        let bookRef = db.collection("books").document(bookUID)
        
        // Fetch the document
        bookRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if the "issued" attribute is 0
                if let issuedCount = document.data()?["issued"] as? Int, issuedCount == 0 {
                    // Delete the document
                    bookRef.delete { error in
                        if let error = error {
                            print("Error deleting book: \(error.localizedDescription)")
                        } else {
                            print("Book deleted successfully!")
                            showAlert = true // Show the alert when the book is deleted successfully
                            isDeleted = true // Set the flag to indicate that the book is deleted
                            alertMsg = "Book deleted Sucessfully"
                        }
                    }
                } else {
                    // "issued" attribute is not 0, so don't delete the book
                    print("Book cannot be deleted because it is currently issued.")
                    showAlert = true // Show an alert indicating that the book cannot be deleted
                    isDeleted = false // Set the flag to indicate that the book is not deleted
                    alertMsg = "Can't delete,Book is borrowed by someone"
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    
    // Function to update the location of a book in Firebase
    func updateBookLocation(newLocation: String, forBookUID bookUID: String, completion: @escaping (Error?) -> Void) {
        // Reference to the Firebase database
        let db = Firestore.firestore()
        
        // Reference to the document of the book
        let bookRef = db.collection("books").document(bookUID)
        
        // Update the location field of the document
        bookRef.updateData(["shelfLocation": newLocation]) { error in
            completion(error)
        }
    }
}

// Custom button row with a title and optional detail
struct ButtonRow: View {
    let title: String
    let detail: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(width: 353, height: 14)
                .padding(.vertical, 5)
            
            HStack {
                Text(title)
                Spacer()
                if let detail = detail {
                    Text(detail)
                }
                Image(systemName: "chevron.right")
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

// Custom editable button row with a title, detail, and editable field
struct EditableButtonRow: View {
    let title: String
    let detail: String?
    @Binding var newLocation: String
    @Binding var isEditing: Bool
    let onCommit: (String) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            
            HStack {
                Text(title)
                Spacer()
                if let detail = detail {
                    if isEditing {
                        TextField("", text: $newLocation) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            onCommit(newLocation)
                            isEditing = false
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onAppear {
                            newLocation = detail
                        }
                    } else {
                        Text(detail)
                    }
                }
                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isEditing.toggle()
                    }
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(bookUID: "")
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel()) // Inject your view model here
    }
}


