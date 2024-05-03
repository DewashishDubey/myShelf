//
//  LRenewalsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LRenewalsView: View {
    @ObservedObject var viewModel = ExtensionRequestViewModel()
    var body: some View {
        VStack 
        {
                   ForEach(viewModel.extensionRequests, id: \.documentID) { request in
                       VStack(alignment: .leading) 
                       {
                           HStack {
                               Image(systemName: "person.circle")
                                   .resizable()
                                   .frame(width: 40, height: 40)
                                   .padding(.leading,10)
                               
                               VStack(alignment: .leading) {
                                   Text(request.user?.name ?? "")
                                       .font(
                                       Font.custom("SF Pro", size: 14)
                                       .weight(.medium)
                                       )
                                       .foregroundColor(.white)
                                   Text(request.book?.title ?? "")
                                       .font(
                                       Font.custom("SF Pro", size: 12)
                                       .weight(.medium)
                                       )
                                       .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                               }
                               
                               Spacer()
                               
                                   HStack {
                                       Button{
                                           markRequestAsCompleted(request: request)
                                       }label: {
                                           Image(systemName: "checkmark.circle")
                                               .resizable()
                                               .frame(width: 20,height: 20)
                                               .foregroundColor(.green)
                                               
                                       }
                                       
                                       
                                       Button{
                                           markRequestAsRejected(request: request)
                                       }label: {
                                           Image(systemName: "x.circle")
                                               .resizable()
                                               .frame(width: 20,height: 20)
                                               .foregroundColor(.red)
                                               .padding(.leading,10)
                                       }

                                       
                               }
                           }
                           Rectangle()
                           .foregroundColor(.clear)
                           .frame(maxWidth: .infinity,maxHeight: 1)
                           .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                           .padding(.top,10)
                       }
                       .padding(.horizontal,10)
                   }
               }
               .onAppear {
                   viewModel.fetchData()
               }
               .padding(.top)
    }
    
    func markRequestAsCompleted(request: ExtensionRequestData) {
        let db = Firestore.firestore()
        
        // Update document in members collection
        let userRef = db.collection("members").document(request.userID).collection("issued_books").document(request.documentID)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                // Fetch existing end_date from Firestore
                var endDate = Date()
                if let existingEndDate = document["end_date"] as? Timestamp {
                    endDate = existingEndDate.dateValue()
                }
                // Add 7 days to the existing end_date
                endDate = Calendar.current.date(byAdding: .day, value: 7, to: endDate) ?? Date()
                
                // Update document with new end_date
                userRef.updateData(["end_date": endDate]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document in members collection successfully updated")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        let issuedBooksQuery = db.collection("books_issued")
               .whereField("bookID", isEqualTo: request.reservedBookID)
               .whereField("memberID", isEqualTo: request.userID)
           issuedBooksQuery.getDocuments { querySnapshot, error in
               if let error = error {
                   print("Error fetching documents: \(error)")
               } else {
                   for document in querySnapshot!.documents {
                       var endDate = Date()
                       if let existingEndDate = document["end_date"] as? Timestamp {
                           endDate = existingEndDate.dateValue()
                       }
                       endDate = Calendar.current.date(byAdding: .day, value: 7, to: endDate) ?? Date()
                       
                       let issuedBookRef = db.collection("books_issued").document(document.documentID)
                       issuedBookRef.updateData(["end_date": endDate]) { error in
                           if let error = error {
                               print("Error updating issued book document: \(error)")
                           } else {
                               print("Issued book document successfully updated")
                           }
                       }
                   }
               }
           }
        
        // Delete document from extension_requests collection
        let extensionRequestRef = db.collection("extension_requests").document(request.uid)
        extensionRequestRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document in extension_requests collection successfully deleted")
            }
        }
    }
    
    func markRequestAsRejected(request: ExtensionRequestData) {
        let db = Firestore.firestore()
        // Delete document from extension_requests collection
        let extensionRequestRef = db.collection("extension_requests").document(request.uid)
        extensionRequestRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document in extension_requests collection successfully deleted")
            }
        }
    }
}

#Preview {
    LRenewalsView()
}
