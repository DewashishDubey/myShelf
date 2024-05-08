//
//  LLibraryView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//


import SwiftUI
import Firebase

struct LLibraryView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var showingSheet = false
    @State private var showingSheet1 = false
    @State private var selectedBookUID: BookUID?
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView
            {
                
                NavigationStack
                {
                    VStack{
                        HStack(alignment: .center) {
                        // Space Between
                            Text("Add a New Book")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                        // Alternative Views and Spacers
                           Image(systemName: "plus.circle")
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))


                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,10)
                        
                        HStack(alignment: .center)
                        {
                            Text("Library")
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
                        
                        
                        ForEach(firebaseManager.books.filter {
                            (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText.lowercased()))
                        }, id: \.uid) { book in
                            if book.isActive{
                                HStack(alignment: .top, spacing: 15)
                                {
                                    AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 90)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 90)
                                                .clipped()
                                        @unknown default:
                                            Text("Unknown")
                                        }
                                    }
                                    .frame(width: 60, height: 90)
                                    .clipped()
                                    
                                    
                                    VStack(alignment: .leading,spacing: 5) {
                                        HStack{
                                            Text(book.title)
                                                .font(
                                                    Font.custom("SF Pro Text", size: 18)
                                                        .weight(.bold)
                                                )
                                                .foregroundColor(.white)
                                                .frame(alignment: .topLeading)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        
                                        Text(book.authors[0])
                                            .font(Font.custom("SF Pro Text", size: 14))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text(book.genre)
                                            .font(Font.custom("SF Pro Text", size: 14))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text("Copies: \(book.noOfCopies)")
                                            .font(Font.custom("SF Pro Text", size: 14))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                    }
                                    .padding(0)
                                    .frame(alignment: .leading)
                                }
                                .padding(.top,10)
                                .padding(.bottom,20)
                                .padding(0)
                                .onTapGesture {
                                    showingSheet1.toggle()
                                    selectedBookUID = BookUID(id: book.uid)
                                }
                                .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                                    LBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                                    
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(maxWidth: .infinity,maxHeight: 1)
                                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                
                            }
                        }
                    }
                    .padding()
                    .searchable(text: $searchText, isPresented: $searchIsActive)
                    .onAppear {
                        firebaseManager.fetchBooks()
                    }
                    .onTapGesture {
                        showingSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                      AddBookView()
                }
        }
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        LLibraryView()
    }
}

