//
//  LReturnBookDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LReturnBookDetailView: View {
    var docID : String
    let memberID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var returned = false
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
                        
                        
                        
                        
                            Button(action: {
                                //requestExtension(reservedBookID: reservedBook.bookID)
                                returnBookAndPayFine(bookID: reservedBook.bookID)
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Pay fine and return")
                                    .font(Font.custom("SF Pro Text", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                            })
                            .alert(isPresented: $returned) {
                                Alert(title: Text("Book return successful"))
                            }
                            
                        
                       

                    }
                }
            }
        }
        .onAppear{
            bookViewModel.fetchReservedBook(for: memberID, documentID: docID)
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
    
    private func returnBookAndPayFine(bookID: String) {
        let db = Firestore.firestore()
        let memberRef = db.collection("members").document(memberID)
        
        let issuedBookRef = memberRef.collection("issued_books").document(docID)
        issuedBookRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                let fineAmount = data["fine"] as? Int ?? 0
                
                let previouslyIssuedBooksRef = memberRef.collection("previously_issued_books")
                
                previouslyIssuedBooksRef.addDocument(data: data.merging(["hasRated": false]) { _, new in new }) { error in
                    if let error = error {
                        print("Error adding document to previously_issued_books: \(error.localizedDescription)")
                    } else {
                        issuedBookRef.delete { error in
                            if let error = error {
                                print("Error deleting document from issued_books: \(error.localizedDescription)")
                            } else {
                                returned = true
                                memberRef.updateData(["no_of_issued_books": FieldValue.increment(Int64(-1)),
                                                      "books_read": FieldValue.increment(Int64(1))]) { error in
                                    if let error = error {
                                        print("Error updating no_of_issued_books in members collection: \(error.localizedDescription)")
                                    } else {
                                        print("no_of_issued_books updated successfully.")
                                    }
                                }
                                
                                // Remove document from books_issued collection
                                                          let booksIssuedRef = db.collection("books_issued")
                                                          booksIssuedRef.whereField("memberID", isEqualTo: memberID)
                                                              .whereField("bookID", isEqualTo: bookID)
                                                              .getDocuments { (querySnapshot, error) in
                                                                  if let error = error {
                                                                      print("Error getting documents: \(error.localizedDescription)")
                                                                  } else {
                                                                      for document in querySnapshot!.documents {
                                                                          booksIssuedRef.document(document.documentID).delete { error in
                                                                              if let error = error {
                                                                                  print("Error removing document: \(error.localizedDescription)")
                                                                              } else {
                                                                                  print("Document successfully removed from books_issued collection.")
                                                                              }
                                                                          }
                                                                      }
                                                                  }
                                                          }
                                
                                let bookRef = db.collection("books").document(bookID)
                                        bookRef.updateData(["issued": FieldValue.increment(Int64(-1))]) { error in
                                            if let error = error {
                                                print("Error decrementing issued count for the book: \(error.localizedDescription)")
                                            } else {
                                                print("Issued count decremented successfully for the book.")
                                            }
                                        }
                                
                                // Update revenue in admin collection
                                let adminRef = db.collection("admin").document("adminDocument")
                                db.runTransaction({ (transaction, errorPointer) -> Any? in
                                    let adminDocument: DocumentSnapshot
                                    do {
                                        try adminDocument = transaction.getDocument(adminRef)
                                    } catch let fetchError as NSError {
                                        errorPointer?.pointee = fetchError
                                        return nil
                                    }
                                    
                                    guard let oldRevenue = adminDocument.data()?["revenue"] as? Int else {
                                        errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve revenue from admin document"])
                                        return nil
                                    }
                                    
                                    let newRevenue = oldRevenue + fineAmount
                                    transaction.updateData(["revenue": newRevenue], forDocument: adminRef)
                                    
                                    return newRevenue
                                }) { (result, error) in
                                    if let error = error {
                                        print("Error updating revenue in admin collection: \(error.localizedDescription)")
                                    } else {
                                        print("Revenue updated successfully.")
                                        let memberRef = db.collection("members").document(memberID)
                                                memberRef.getDocument { (document, error) in
                                                    if let document = document, document.exists {
                                                        var currentDue = document.get("due") as? Int ?? 0
                                                        currentDue += fineAmount
                                                        
                                                        memberRef.updateData(["due": currentDue]) { error in
                                                            if let error = error {
                                                                print("Error updating due amount in members collection: \(error.localizedDescription)")
                                                            } else {
                                                                print("Due amount updated successfully.")
                                                            }
                                                        }
                                                    } else {
                                                        print("Member document not found.")
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
             else {
                if let error = error {
                    print("Error getting document: \(error.localizedDescription)")
                }
            }
        }
    }

    

}

#Preview {
    LReturnBookDetailView(docID: "", memberID: "")
}
