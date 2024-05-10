//
//  LHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI
import Firebase
struct LHomeView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject var adminViewModel = AdminViewModel()
    @ObservedObject var librarianManager = LibrarianManager()
    @StateObject var allBooksViewModel = AllIssuedBooksViewModel()
    @State private var isPremiumMember: Bool = false
    @State private var gender = ""
    var body: some View {
       // if let user = viewModel.currentUser{
            ZStack{
                Color.black.ignoresSafeArea(.all)
                ScrollView{
                    VStack{
                        if let user = viewModel.currentUser{
                            HStack {
                                VStack(alignment: .leading) {
                                    let name = Name(fullName: user.fullname)
                                    Text("Welcome, \(name.first)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Librarian")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                
                                /*Image(systemName: "bell")
                                    .foregroundColor(.white)*/
                                NavigationLink(destination: LProfileView().navigationBarBackButtonHidden(false)) {
                                    Image(gender == "male" ? "male" : "female")
                                        .resizable()
                                        .frame(width: 36,height: 36)
                                        .foregroundColor(.white)
                                }
                                
                            }
                            .padding()
                            .padding(.top,10)
                        }
                        HStack(spacing:15){
                            VStack(spacing:15){
                                Text("BOOKS")
                                    .font(
                                        Font.custom("SF Pro", size: 12)
                                            .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                Text("\(adminViewModel.adminData?.books ?? 0)")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                            
                            VStack(spacing:15){
                                Text("OVERDUE")
                                    .font(
                                        Font.custom("SF Pro", size: 12)
                                            .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                Text("\(adminViewModel.adminData?.librarians ?? 0)")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                        }
                        .padding(.bottom,10)
                        
                        NavigationLink{
                            LRequestsView()
                        }label: {
                            HStack{
                                Text("Requests")
                                    .font(
                                        Font.custom("SF Pro", size: 14)
                                            .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                        }
                        .padding(.bottom,10)
                        
                        HStack{
                            ScanCode()
                            Spacer()
                            ScanReturn()
                            Spacer()
                        }
                        
                        Text("Recent Activity")
                            .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                            .padding(.bottom,20)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.top,20)
                         if !allBooksViewModel.issuedBooks.isEmpty {
                                        ForEach(allBooksViewModel.issuedBooks) { issuedBook in
                                            VStack(alignment: .leading) {
                                                HStack{
                                                    Image(issuedBook.user?.gender == "male" ? "male" : "female")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 40, height: 40)
                                                        .clipped()
                                                    VStack(spacing: 10){
                                                        HStack{
                                                            Text(issuedBook.user?.name ?? "")
                                                                .font(
                                                                Font.custom("SF Pro", size: 14)
                                                                .weight(.medium)
                                                                )
                                                                .foregroundColor(.white)
                                                            Spacer()
                                                            Text("Borrowed")
                                                                .font(
                                                                Font.custom("SF Pro", size: 12)
                                                                .weight(.medium)
                                                                )
                                                                .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.02))
                                                        }
                                                        Text(issuedBook.book.title)
                                                            .font(
                                                            Font.custom("SF Pro", size: 12)
                                                            .weight(.medium)
                                                            )
                                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                            .frame(maxWidth: .infinity,alignment: .leading)
                                                    }
                                                }
                                                Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 353, height: 1)
                                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                                .padding(.top,10)
                                                .padding(.bottom,10)
                                                // Add more details as needed
                                                
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.bottom,20)
                                            
                                            
                                        }
                                    } else {
                                        Text("Loading...") // Show loading indicator while data is being fetched
                                    }
                    }.padding(.horizontal)
                }
                .onAppear {
                            adminViewModel.fetchData()
                    librarianManager.fetchLibrarians()
                    allBooksViewModel.fetchIssuedBooks()
                        fetchMemberData()
                        }
                /*
                ScrollView{
                    VStack{
                        NavigationLink{
                            LRequestsView()
                        }label: {
                            HStack(alignment: .center) {
                                Text("Requests")
                                    .font(
                                    Font.custom("SF Pro", size: 14)
                                    .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                            .frame(width: 353, alignment: .center)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                            .padding(.horizontal,20)
                        }
                        HStack{
                            ScanCode()
                        }
                        .frame(maxWidth: .infinity,maxHeight: 40)
                        Text(user.fullname)
                       
                        Spacer()
                    }
                }*/
            }
        //}
    }
    func fetchMemberData() {
        if let userId = viewModel.currentUser?.id {
            let membersRef = Firestore.firestore().collection("librarians").document(userId)
            membersRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let isPremium = document.data()?["is_premium"] as? Bool {
                        self.isPremiumMember = isPremium
                    }
                    if let gender = document.data()?["gender"] as? String {
                        self.gender = gender
                    }
                } else {
                    print("Member document does not exist or could not be retrieved: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

#Preview {
    LHomeView()
}
