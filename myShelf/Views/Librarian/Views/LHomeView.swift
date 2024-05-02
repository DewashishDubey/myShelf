//
//  LHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI

struct LHomeView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject var adminViewModel = AdminViewModel()
    @ObservedObject var librarianManager = LibrarianManager()
    var body: some View {
        if let user = viewModel.currentUser{
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
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                                NavigationLink(destination: MProfileView().navigationBarBackButtonHidden(false)) {
                                    Image(systemName: "person.crop.circle")
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
                                Text("BORROWED")
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
                        }
                    }.padding(.horizontal)
                }
                .onAppear {
                            adminViewModel.fetchData()
                    librarianManager.fetchLibrarians()
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
        }
    }
}

#Preview {
    LHomeView()
}
