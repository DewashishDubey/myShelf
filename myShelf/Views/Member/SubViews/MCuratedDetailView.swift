//
//  MCuratedDetailView.swift
//  myShelf
//
//  Created by Vansh Pitalia on 08/05/24.
//

import SwiftUI

struct MCuratedDetailView: View {
    let genre: String
    @State private var showingSheet = false
    @State private var selectedBookUID: BookUID?
    @ObservedObject var firebaseManager = FirebaseManager()
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators : false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(firebaseManager.books, id: \.uid)
                    { book in
                        
                        if(book.genre.lowercased() == genre.lowercased())
                        {
                            VStack
                            {
                                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 217)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 217)
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 217)
                                .cornerRadius(5)
                                
                                Text(book.title)
                                    .lineLimit(1)
                                    .padding(.trailing,20)
                                    .padding(.bottom,12)
                                    .padding(.leading)
                                /*Image(book.image)
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(width: 140, height: 217)
                             .clipped()
                             .padding(.bottom,4)
                                 Text(book.title)
                                 .lineLimit(nil)
                                 .padding(.trailing,20)
                                 .padding(.bottom,12)
                                 .padding(.leading)*/
                            }
                            .onTapGesture {
                                showingSheet.toggle()
                                selectedBookUID = BookUID(id: book.uid)
                            }
                        }
                        
                        
                    }
                   
                    .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                        MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                    }
                    
                }
            }
            .padding()
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
        .navigationTitle(genre.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}


/*
struct BookCard: View {
    var body: some View {
        VStack {
            Image("Book2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 217)
            .clipped()
            Text("The Quiet Part Out Loud")
                .frame(width: 140)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing,20)
        }
    }
}*/

#Preview {
    MCuratedDetailView(genre: "")
}
