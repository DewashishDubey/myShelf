//
//  AGriveanceView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 08/05/24.
//

import SwiftUI
import Firebase
struct AGriveanceView: View {
    @StateObject var viewModel = GrievanceViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.grievances) { grievance in
                        if (grievance.category == "Others" || grievance.category == "Membership" || grievance.category == "Library") {
                            AGrievanceItem(grievance: grievance)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchGrievances()
        }
    }
}

struct AGrievanceItem: View {
    let grievance: GrievanceEntry
    @State private var isExpanded = false
    @StateObject var viewModel = GrievanceViewModel()
    @State private var memberData: MemberData?
    @State private var memberEmail: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack{
                    Text("\(grievance.description)")
                        //.foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                        .foregroundStyle(Color.white)
                        .font(.custom("SF Pro Text", size: 14))
                        .padding(.bottom,10)
                    Button("Delete Grievance"){deleteGrievance(grievanceID: grievance.id ?? "")}
                        .font(.custom("SF Pro Text", size: 14))
                        .padding(.bottom,10)
                        .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                        .frame(maxWidth: .infinity,alignment: .center)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top,10)
            } label: {
                HStack{
                    if let memberData = memberData {
                        Image(memberData.gender == "male" ? "male" : "female")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipped()
                    }
                    VStack(spacing:5){
                        if let memberData = memberData {
                            Text(memberData.name)
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,alignment: .leading)
                            
                            Text(memberEmail ?? "")
                                .font(
                                    Font.custom("SF Pro Text", size: 12)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                .frame(maxWidth: .infinity,alignment: .leading)
                            
                            Text("Category: \(grievance.category)")
                                .font(
                                    Font.custom("SF Pro Text", size: 12)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                .frame(maxWidth: .infinity,alignment: .leading)
                            Text("Issue: \(grievance.subject)")
                                .font(
                                    Font.custom("SF Pro Text", size: 12)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .accentColor(.white)
        }
        .onAppear {
            // Fetch user details when the view appears
            viewModel.fetchUserDetails(for: grievance.memberID) { fetchedMemberData in
                // Update memberData state variable with fetched user details
                memberData = fetchedMemberData
            }
            fetchMemberEmail(for: grievance.memberID)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(8)
    }
    
    private func fetchMemberEmail(for memberID: String) {
           let db = Firestore.firestore()
           let usersCollection = db.collection("users")
           
           usersCollection.document(memberID).getDocument { (document, error) in
               if let error = error {
                   print("Error fetching user document: \(error.localizedDescription)")
                   return
               }
               
               if let document = document, document.exists {
                   if let email = document["email"] as? String {
                       memberEmail = email
                   } else {
                       print("Email not found for user with ID \(memberID)")
                   }
               } else {
                   print("User document does not exist for ID \(memberID)")
               }
           }
       }
    
    
    private func deleteGrievance(grievanceID: String) {
        let db = Firestore.firestore()
        let grievancesCollection = db.collection("grievance")
        
        // Delete the document with the provided grievanceID
        grievancesCollection.document(grievanceID).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
                // Optionally, you can also perform any additional actions after deletion
            }
        }
    }
}


#Preview {
    AGriveanceView()
}
