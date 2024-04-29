//
//  AHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI

struct AHomeView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject var adminViewModel = AdminViewModel()
    @ObservedObject var librarianManager = LibrarianManager()
    var body: some View {
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
                            Text("Admin")
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
                        Text("LIBRARIANS")
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
                
                HStack(spacing:15){
                    VStack(spacing:15){
                        Text("REVENUE")
                            .font(
                                Font.custom("SF Pro", size: 12)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        Text("\(adminViewModel.adminData?.revenue ?? 0)")
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
                        Text("MEMBERS")
                            .font(
                                Font.custom("SF Pro", size: 12)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        Text("\(adminViewModel.adminData?.members ?? 0)")
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
                    FinePolicyView()
                }label: {
                    HStack{
                        Text("Fine and Dues Policies")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "applescript")
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
                
                Text("Librarians")
                    .font(
                    Font.custom("SF Pro", size: 20)
                    .weight(.semibold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading,5)
                    .padding(.bottom,20)
                
                ForEach(librarianManager.librarians, id: \.uid) { librarian in
                    NavigationLink{
                        LibrarianDetailView(libID: librarian.uid)
                    }label: {
                        VStack
                        {
                            HStack{
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipped()
                                    .foregroundColor(.white)
                                    .padding(.leading,10)
                                VStack{
                                    Text(librarian.name)
                                        .font(
                                            Font.custom("SF Pro", size: 14)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(.white)
                                        .padding(.leading,10)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .padding(.trailing,10)
                            }
                           
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 353, height: 1)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                .padding(.top,10)
                        }
                        .padding(.bottom,10)
                    }
                }
            }.padding(.horizontal)
        }
        .onAppear {
                    adminViewModel.fetchData()
            librarianManager.fetchLibrarians()
                }
    }
}

#Preview {
    AHomeView()
}
