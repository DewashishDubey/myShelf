//
//  ALibrarianView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI

struct ALibrarianView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var showingSheet = false
    @State private var showingSheet1 = false
    @State private var selectedBookUID: BookUID?
    @ObservedObject var librarianManager = LibrarianManager()
   // @ObservedObject var viewModel : AuthViewModel
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView
            {
                
                NavigationStack
                {
                    VStack
                    {
                        HStack(alignment: .center) {
                        
                            Text("Add a New Librarian")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                        
                           Image(systemName: "plus.circle")
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,10)
                        .onTapGesture {
                            showingSheet.toggle()
                        }
                        .padding(20)
                        //.padding(.horizontal)
                        
                        HStack(alignment: .center)
                        {
                            Text("Librarians")
                            .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                        Spacer()
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom,10)
                        .padding(.leading,10)
                        .padding(.horizontal)
                        
                        ForEach(librarianManager.librarians, id: \.uid) { librarian in
                            NavigationLink{
                                LibrarianDetailView(libID: librarian.uid)
                            }label: {
                                VStack{
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
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .padding(.bottom,10)
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 353, height: 1)
                                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                }
                                .padding()
                            }
                            
                        }
                        
                    }
                    .searchable(text: $searchText, isPresented: $searchIsActive)
                    
                }
            }
            .sheet(isPresented: $showingSheet) {
                      AddLibrarianView()
                }
            .onAppear {
                        librarianManager.fetchLibrarians()
                    }
        }
    }
}

#Preview {
    ALibrarianView()
}
