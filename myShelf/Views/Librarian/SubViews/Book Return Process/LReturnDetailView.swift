//
//  LReturnDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LReturnDetailView: View {
    let MemberID: String
    @State private var member: Member?
    @StateObject private var issuedBooksViewModel = IssuedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        VStack 
        {
            HStack{
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40,height: 40)
                    //.padding(.leading,10)
                VStack(alignment:.leading){
                        Text(member?.name ?? "")
                            .font(
                                Font.custom("SF Pro", size: 18)
                                    .weight(.medium)
                            )
                            .foregroundColor(.white)
                        
                    
                    if let member = member{
                        Text("\(member.isPremium ? "Premium Member" : "Basic Member")")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.02))
                    }
                }
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom,20)
            .padding(.top,20)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 353, height: 1)
                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
            VStack{
                ForEach(issuedBooksViewModel.issuedBooks)
                { issuedBook in
                    NavigationLink{
                        LReturnBookDetailView(docID: issuedBook.documentID, memberID: member?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1")
                    }label: {
                        VStack(alignment: .leading,spacing: 20)
                        {
                            
                            HStack(alignment: .top,spacing: 10)
                            {
                                
                                AsyncImage(url: URL(string: issuedBook.book.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 90)
                                            .clipped()
                                            .padding(.trailing,10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 90)
                                            .clipped()
                                            .padding(.trailing,10)
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .frame(width: 60, height: 90)
                                .clipped()
                                .padding(.trailing,10)
                                
                                HStack(alignment:.top,spacing: 10)
                                {
                                    VStack(alignment: .leading,spacing: 10){
                                        Text(issuedBook.book.title)
                                        /*.font(
                                         Font.custom("SF Pro Text", size: 14)
                                         .weight(.semibold)
                                         )*/
                                            .font(.custom("SFProText-Semibold", size: 14))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Text(issuedBook.book.authors[0])
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text("Borrowed on: \(trimTime(from: issuedBook.startDateString))")
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text("Returned Due on: \(trimTime(from: issuedBook.endDateString))")
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        
                                    }
                                    .padding(.leading,2)
                                    .padding(.top,4)
                                    
                                    Text("Borrowed")
                                        .font(
                                            Font.custom("SF Pro", size: 12)
                                                .weight(.semibold)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.02))
                                        .padding(.top,4)
                                }
                            }
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 353, height: 1)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                            //Spacer()
                        }
                        .padding(.horizontal)
                        
                    }
                    }
                       
                   
                    
                    
                    
            }
            Spacer()
        }
        .onAppear {
            fetchMemberDetails(memberID: MemberID)
            issuedBooksViewModel.fetchIssuedBooks(for: MemberID)
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
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
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
    
}

#Preview {
    LReturnDetailView(MemberID: "")
}

/*
 if let member = member {
     Text(member.id)
     Text("Member Name: \(member.name)")
     Text("Is Premium: \(member.isPremium ? "Yes" : "No")")
     Text("Last Read Genre: \(member.lastReadGenre)")
     Text("Number of Issued Books: \(member.numberOfIssuedBooks)")
     Text("Subscription Start Date: \(formattedDate(member.subscriptionStartDate))")
 } else {
     Text("Loading...")
 }
 Button(action: {
     
 }) {
     Text("Submit")
         .font(.title)
         .padding()
         .background(Color.blue)
         .foregroundColor(.white)
         .cornerRadius(10)
 }
 .padding(.top, 20)
 */
