//
//  EditBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//

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
    @State private var newCopies: String = "" // State variable to hold the new number of copies
    @State private var isEditingCopies = false // State variable to track if the copies available is being edited
    @State private var qrCodeImage: UIImage?
    @State private var isShareSheetPresented = false // State variable to track if the share sheet is presented
    let qrCodeGenerator = CIFilter.qrCodeGenerator()
    @State private var issuedCount: Int?
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
                                
                                
                                
                                EditableButtonRow_ForNoOfCopies(title: "Copies Available", detail: book.noOfCopies, newValue: $newCopies, isEditing: $isEditingCopies) { newValue in
                                    updateCopiesAvailable(newCopies: newValue, forBookUID: bookUID) { error in
                                        if let error = error {
                                            print("Error updating copies available: \(error.localizedDescription)")
                                        } else {
                                            print("Copies available updated successfully!")
                                        }
                                    }
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.clear)
                                        .frame(width: 353, height: 14)
                                        .padding(.vertical, 5)
                                    
                                    HStack {
                                        Text("Currently Borrowed")
                                        Spacer()
                                        
                                        Text("\(issuedCount ?? 0)")
                                        
                                    
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                }

                               
                                
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
                                
                                Button(action: {
                                    qrCodeImage = generateQRCode(from: bookUID)
                                    isShareSheetPresented = true
                                }) {
                                    HStack {
                                        Text("Print Book QR")
                                        Spacer()
                                        Image(systemName: "printer")
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.bottom, 5)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                firebaseManager.fetchBooks() // Fetch books when the view appears
                fetchIssuedAttribute(forBookUID: bookUID)
                    
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
        }
        .sheet(isPresented: $isShareSheetPresented) {
           shareSheet
        }
    }
    
    /*
    // Delete the book from Firebase and navigate back to the search page
    func deleteBook() {
        
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
    }*/
    func deleteBook() {
        // Reference to the Firebase database
        let db = Firestore.firestore()
        
        // Reference to the document of the book
        let bookRef = db.collection("books").document(bookUID)
        
        // Fetch the document
        bookRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if the "issued" attribute is 0
                if let issuedCount = document.data()?["issued"] as? Int, issuedCount == 0 {
                    // Update the document to mark it as inactive
                    bookRef.updateData(["isActive": false]) { error in
                        if let error = error {
                            print("Error deactivating book: \(error.localizedDescription)")
                        } else {
                            print("Book deactivated successfully!")
                            showAlert = true // Show the alert when the book is deactivated successfully
                            isDeleted = true // Set the flag to indicate that the book is deactivated
                            alertMsg = "Book deactivated successfully"
                        }
                    }
                } else {
                    // "issued" attribute is not 0, so don't deactivate the book
                    print("Book cannot be deactivated because it is currently issued.")
                    showAlert = true // Show an alert indicating that the book cannot be deactivated
                    isDeleted = false // Set the flag to indicate that the book is not deactivated
                    alertMsg = "Can't deactivate, Book is borrowed by someone"
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
    
    func updateCopiesAvailable(newCopies: String, forBookUID bookUID: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookUID)
        bookRef.updateData(["noOfCopies": newCopies]) { error in
            completion(error)
        }
    }
    private var shareSheet: some View {
        NavigationView {
            VStack {
                if let qrImage = generateQRCode(from: bookUID) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    Text("Failed to generate QR code")
                        .padding()
                }

                ShareSheet(activityItems: [qrCodeImage ?? UIImage()], applicationActivities: nil)
                    .navigationBarItems(trailing: Button("Done") {
                        isShareSheetPresented = false
                        presentationMode.wrappedValue.dismiss()
                    })
            }
        }
    }
    
    private func generateQRCode(from bookUID: String) -> UIImage? {
        let bookData = Data(bookUID.utf8)
        qrCodeGenerator.setValue(bookData, forKey: "inputMessage")
        
        if let ciImage = qrCodeGenerator.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }

    // Function to fetch the "issued" attribute for a specific book UID from Firebase
    func fetchIssuedAttribute(forBookUID bookUID: String) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookUID)

        bookRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let issuedCount = document.data()?["issued"] as? Int {
                    print("Issued count for \(bookUID): \(issuedCount)")
                    // Store the fetched issued count in a variable
                    self.issuedCount = issuedCount
                } else {
                    print("Issued attribute does not exist or is not an integer")
                }
            } else {
                print("Document for book UID \(bookUID) does not exist")
            }
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

struct EditableButtonRow_ForNoOfCopies: View {
    let title: String
    let detail: String?
    @Binding var newValue: String
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
                        TextField("", text: $newValue) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            onCommit(newValue)
                            isEditing = false
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onAppear {
                            newValue = detail
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

struct ShareSheet: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(bookUID: "")
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel()) // Inject your view model here
    }
}
