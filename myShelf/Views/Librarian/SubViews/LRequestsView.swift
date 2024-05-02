//
//  LRequestsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 01/05/24.
//


/*
import SwiftUI
import Firebase
struct LRequestsView: View {
    @ObservedObject var viewModel = ExtensionRequestViewModel()
    var body: some View {
        VStack {
                   ForEach(viewModel.extensionRequests, id: \.documentID) { request in
                       VStack(alignment: .leading) {
                           Text("Document ID: \(request.documentID)")
                           Text("Reserved Book ID: \(request.reservedBookID)")
                           Text("UID: \(request.uid)")
                           Text("User ID: \(request.userID)")
                           Button{
                               markRequestAsCompleted(request: request)
                           }label: {
                               Image(systemName: "checkmark.circle")
                                   .foregroundColor(.green)
                           }
                           .padding(.bottom,20)
                           
                           Button{
                               markRequestAsRejected(request: request)
                           }label: {
                               Image(systemName: "x.circle")
                                   .foregroundColor(.red)
                           }
                       }
                   }
               }
               .onAppear {
                   viewModel.fetchData()
               }
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
    LRequestsView()
}
*/

import SwiftUI

struct LRequestsView: View {
    @State private var selectedTab: Tab = .reservations
    @State private var searchText: String = ""
    @State private var showSortFilter: Bool = false
    
    enum Tab {
        case reservations, renewals
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("Select Tab")) {
                    Text("Reservations").tag(Tab.reservations)
                    Text("Renewals").tag(Tab.renewals)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
               
                HStack {
                   Text(selectedTab == .reservations ? "Reservations" : "Renewals")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        showSortFilter.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease")
                    }
                    .padding(.trailing)
                    .foregroundColor(.primary)
                }
                Spacer()
                // List of users in rectangular sections
                ScrollView {
                        UserRectangularSectionView(tab: selectedTab)
                }
            }
        }
    }
}

struct UserRectangularSectionView: View {
    let tab: LRequestsView.Tab
    
    var body: some View {
        VStack {
            if tab == .reservations {
                LReservationsView()
            }
            else
            {
                LRenewalsView()
            }
            /*HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text("User Name")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Book Title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if tab == .reservations {
                    Text("Date & Time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                        Button(action: {}) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding()*/
            
           // Divider()
            Spacer()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.trailing)
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        LRequestsView()
            .preferredColorScheme(.dark)
    }
}

