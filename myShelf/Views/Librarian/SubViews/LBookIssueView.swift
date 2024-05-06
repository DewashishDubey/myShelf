//
//  LBookIssueView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 28/04/24.
//

/*
import SwiftUI

struct LBookIssueView: View {
    let bookID : String
    let MemberID : String
    var body: some View {
        VStack{
            Text(bookID)
            Text(MemberID)
        }
    }
}

#Preview {
    LBookIssueView(bookID: "", MemberID: "")
}*/

/*
import SwiftUI
import FirebaseFirestore

struct Member {
    let id: String
    let isPremium: Bool
    let lastReadGenre: String
    let name: String
    let numberOfIssuedBooks: Int
    let subscriptionStartDate: Date
}

struct LBookIssueView: View {
    let bookID: String
    let MemberID: String
    @State private var member: Member?
    
    var body: some View {
        VStack {
            if let member = member {
                Text("Member Name: \(member.name)")
                Text("Is Premium: \(member.isPremium ? "Yes" : "No")")
                Text("Last Read Genre: \(member.lastReadGenre)")
                Text("Number of Issued Books: \(member.numberOfIssuedBooks)")
                Text("Subscription Start Date: \(formattedDate(member.subscriptionStartDate))")
            } else {
                Text("Loading...")
            }
            Button(action: {
                           // Add your action here, such as submitting the form
                       }) {
                           Text("Submit")
                               .font(.title)
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .cornerRadius(10)
                       }
                       .padding(.top, 20)
        }
        .onAppear {
            fetchMemberDetails(memberID: MemberID)
        }
    }
    
    func fetchMemberDetails(memberID: String) {
        let db = Firestore.firestore()
        let membersRef = db.collection("members")
        
        membersRef.document(memberID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let isPremium = data?["is_premium"] as? Bool ?? false
                let lastReadGenre = data?["lastReadGenre"] as? String ?? ""
                let name = data?["name"] as? String ?? ""
                let numberOfIssuedBooks = data?["no_of_issued_books"] as? Int ?? 0
                
                // Assuming the subscription_start_date is stored as a Timestamp
                let subscriptionStartDateTimestamp = data?["subscription_start_date"] as? Timestamp ?? Timestamp(date: Date())
                let subscriptionStartDate = subscriptionStartDateTimestamp.dateValue()
                
                self.member = Member(id: id, isPremium: isPremium, lastReadGenre: lastReadGenre, name: name, numberOfIssuedBooks: numberOfIssuedBooks, subscriptionStartDate: subscriptionStartDate)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
}

struct LBookIssueView_Previews: PreviewProvider {
    static var previews: some View {
        LBookIssueView(bookID: "", MemberID: "")
    }
}
*/

import SwiftUI
import FirebaseFirestore

struct Member {
    let id: String
    let isPremium: Bool
    let lastReadGenre: String
    let name: String
    let numberOfIssuedBooks: Int
    let subscriptionStartDate: Date
}

struct LBookIssueView: View {
    let bookID: String
    let MemberID: String
    @State private var member: Member?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @ObservedObject var firebaseManager = FirebaseManager()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing:10) {
            if let book = firebaseManager.books.first(where: { $0.uid == bookID })
            {
                Text("BOOK")
                    .font(
                        Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom,10)
                HStack(alignment: .top) {
                    // Space Between
                    AsyncImage(url: URL(string: book.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 140)
                                .clipped()
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 140)
                                .clipped()
                                .cornerRadius(10)
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                    .frame(width: 90, height: 140)
                    .clipped()
                    .cornerRadius(10)
                    
                    VStack(alignment:.leading,spacing:5){
                        Text(book.title)
                            .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                            .padding(.top,20)
                        Text(book.authors[0])
                            .font(
                            Font.custom("SF Pro", size: 16)
                            .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        Text(book.genre)
                            .font(
                            Font.custom("SF Pro", size: 16)
                            .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        Text(book.publisher)
                            .font(
                            Font.custom("SF Pro", size: 16)
                            .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 353, height: 1)
                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                .padding(.bottom,10)
                Text("USER")
                    .font(
                        Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom,10)
                if let member = member {
                    HStack{
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40,height: 40)
                        VStack(alignment:.leading){
                            Text(member.name)
                                .font(
                                Font.custom("SF Pro", size: 20)
                                .weight(.semibold)
                                )
                                .foregroundColor(.white)
                            Text(member.isPremium == true  ? "Premium Member" : "Basic Memebr")
                                .font(
                                Font.custom("SF Pro", size: 16)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 353, height: 1)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                } else {
                    Text("Loading...")
                }
                Button(action: {
                    submitButtonTapped()
                }) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Issue Book")
                        .font(
                        Font.custom("SF Pro Text", size: 14)
                        .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    }
                    .padding(20)
                    .frame(width: 353, alignment: .center)
                    .background(Color(red: 0.26, green: 0.52, blue: 0.96))
                    .cornerRadius(6)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")){
                        presentationMode.wrappedValue.dismiss()
                    })
            }
            Spacer()
        }
       
        }
        .onAppear {
            fetchMemberDetails(memberID: MemberID)
            firebaseManager.fetchBooks()
        }
    }
    
    func submitButtonTapped() {
        guard let member = member else {
            return
        }
        
        if member.numberOfIssuedBooks != 0 {
            if member.isPremium && member.numberOfIssuedBooks < 5 {
                // Issue the book for premium member
                issueBook(startDate: Date(), endDate: Date().addingTimeInterval(15 * 24 * 60 * 60))
               
            } else {
                showAlert = true
                alertMessage = "Book issue limit reached"
            }
        } else {
            if !member.isPremium && member.numberOfIssuedBooks < 1 {
                // Issue the book for non-premium member
                issueBook(startDate: Date(), endDate: Date().addingTimeInterval(7 * 24 * 60 * 60))
                
            }
            else if member.isPremium
            {
                issueBook(startDate: Date(), endDate: Date().addingTimeInterval(15 * 24 * 60 * 60))
               
            }
        }
    }
    
    func fetchMemberDetails(memberID: String) {
        let db = Firestore.firestore()
        let membersRef = db.collection("members")
        
        membersRef.document(memberID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let isPremium = data?["is_premium"] as? Bool ?? false
                let lastReadGenre = data?["lastReadGenre"] as? String ?? ""
                let name = data?["name"] as? String ?? ""
                let numberOfIssuedBooks = data?["no_of_issued_books"] as? Int ?? 0
                
                // Assuming the subscription_start_date is stored as a Timestamp
                let subscriptionStartDateTimestamp = data?["subscription_start_date"] as? Timestamp ?? Timestamp(date: Date())
                let subscriptionStartDate = subscriptionStartDateTimestamp.dateValue()
                
                self.member = Member(id: id, isPremium: isPremium, lastReadGenre: lastReadGenre, name: name, numberOfIssuedBooks: numberOfIssuedBooks, subscriptionStartDate: subscriptionStartDate)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func issueBook(startDate: Date, endDate: Date) {
        let db = Firestore.firestore()
        let issuedBooksRef = db.collection("members").document(MemberID).collection("issued_books")
        let booksRef = db.collection("books").document(bookID)
        let memberRef = db.collection("members").document(MemberID)
        let booksIssuedRef = db.collection("books_issued") // New collection reference
        // Add the issued book document
        issuedBooksRef.addDocument(data: [
            "bookID": bookID,
            "start_date": startDate,
            "end_date": endDate,
            "fine": 0,
            "documentID": "", // Placeholder for the UID
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                issuedBooksRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else if let snapshot = snapshot {
                        guard let document = snapshot.documents.first else {
                            print("Document does not exist")
                            return
                        }
                        let documentID = document.documentID
                        showAlert = true
                        alertMessage = "Book issued Successfully"
                        // Update the document with the UID
                        issuedBooksRef.document(documentID).setData(["documentID": documentID], merge: true) { error in
                            if let error = error {
                                print("Error updating document with UID: \(error)")
                            } else {
                                print("UID added successfully to the document")
                            }
                        }
                    }
                }

                // Add the issued book document to books_issued collection
                    booksIssuedRef.addDocument(data: [
                        "memberID": MemberID, // Add MemberID
                        "bookID": bookID,
                        "start_date": startDate,
                        "end_date": endDate,
                        "documentID": "", // Placeholder for the UID
                    ]) { (error) in
                        if let error = error {
                            print("Error adding document to books_issued: \(error)")
                        } else {
                            booksIssuedRef.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("Error getting documents: \(error)")
                                } else if let snapshot = snapshot {
                                    guard let document = snapshot.documents.first else {
                                        print("Document does not exist")
                                        return
                                    }
                                    let documentID = document.documentID
                                    
                                    // Update the document with the UID
                                    booksIssuedRef.document(documentID).setData(["documentID": documentID], merge: true) { error in
                                        if let error = error {
                                            print("Error updating document with UID: \(error)")
                                        } else {
                                            print("UID added successfully to the document")
                                        }
                                    }
                                }
                            }
                        }
                    }
                
                // Update the number of copies for the book
                booksRef.getDocument { document, error in
                    if let document = document, document.exists {
                        var bookData = document.data() ?? [:]
                        if let noOfCopiesString = bookData["noOfCopies"] as? String,
                            var noOfCopies = Int(noOfCopiesString) {
                            noOfCopies -= 1
                            bookData["noOfCopies"] = String(noOfCopies)
                            var issued = bookData["issued"] as? Int ?? 0
                            issued += 1
                            bookData["issued"] = issued
                            // Update the book document with reduced number of copies
                            booksRef.setData(bookData) { error in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    memberRef.updateData(["no_of_issued_books": FieldValue.increment(Int64(1))])
                                    
                                    if let genre = bookData["genre"] as? String {
                                        // Update lastReadGenre in member document
                                        memberRef.updateData(["lastReadGenre": genre])
                                    }
                                    print("Document updated successfully")
                                }
                            }
                        }
                    } else {
                        print("Book document does not exist")
                    }
                }
            }
        }
    }


    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
}

struct LBookIssueView_Previews: PreviewProvider {
    static var previews: some View {
        LBookIssueView(bookID: "", MemberID: "")
    }
}
