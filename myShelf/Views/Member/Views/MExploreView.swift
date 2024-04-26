//
//  ExplorePage.swift
//  myShelf
//
//  Created by user3 on 23/04/24.

import SwiftUI

struct MExploreView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var showingSheet = false
    @State private var selectedBookUID: BookUID?
    @State private var selectedTag: String?
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView
            {
                
                NavigationStack
                {
                    
                    VStack{
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(alignment: .top){
                                TagView(text: "Thriller", selectedTag: $selectedTag)
                                TagView(text: "Fiction", selectedTag: $selectedTag)
                                TagView(text: "Fantansy", selectedTag: $selectedTag)
                                TagView(text: "Classic", selectedTag: $selectedTag)
                                TagView(text: "Suspense", selectedTag: $selectedTag)
                                TagView(text: "Drama", selectedTag: $selectedTag)
                                TagView(text: "Horror", selectedTag: $selectedTag)
                            }
                        }
                        .padding(.bottom,10)
                        
                        HStack(alignment: .center)
                        {
                            Text("Top Searches")
                            .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                        Spacer()
                        }
                        .padding(.bottom,10)
                        .padding(.leading,10)
                        
                        ForEach(firebaseManager.books.filter {
                            (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText.lowercased())) &&
                            (selectedTag == nil || $0.genre.lowercased() == selectedTag)
                        }, id: \.uid) { book in
                            // Your book row code here
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
                                            .frame(width: 120, height: 186)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 186)
                                            .clipped()
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .frame(width: 120, height: 186)
                                .clipped()
                                
                                
                                VStack(alignment: .leading,spacing: 10) {
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
                                    
                                    Text(book.description)
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .lineLimit(5)
                                        .padding(.bottom,10)
                                    StarsView(rating: Float(book.rating) ?? 0.0, maxRating: 5)
                                    
                                }
                                .padding(0)
                                .frame(alignment: .leading)
                            }
                            .padding(.top,10)
                            .padding(.bottom,20)
                            .padding(.horizontal)
                            .onTapGesture {
                                showingSheet.toggle()
                                selectedBookUID = BookUID(id: book.uid)
                            }
                            .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                                MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                                
                            }
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(maxWidth: .infinity,maxHeight: 1)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                
                        }
                        
                        Spacer()
                    }
                    .searchable(text: $searchText, isPresented: $searchIsActive)
                    .onAppear {
                        firebaseManager.fetchBooks()
                    }
                    
                }
            }
        }
    }
}

    struct TagView: View {
        let text: String
        @Binding var selectedTag: String?
        @State private var isSelected = false
        var body: some View {
            Button(action: {
                if isSelected {
                                isSelected = false
                                selectedTag = nil
                            } else {
                                isSelected = true
                                selectedTag = text.lowercased()
                            }
            }) {
                Text(text)
                    .font(Font.custom("SF Pro Text", size: 12))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(10)
                    .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    .cornerRadius(6)
            }
        }
    }

    
#Preview {
    MExploreView()
}


/*
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
                     .frame(width: 120, height: 186)
                     .clipped()
             case .failure:
                 Image(systemName: "photo")
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 120, height: 186)
                     .clipped()
             @unknown default:
                 Text("Unknown")
             }
         }
             .frame(width: 120, height: 186)
             .clipped()
     
     
     VStack(alignment: .leading,spacing: 10) {
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
         
         Text(book.description)
         .font(Font.custom("SF Pro Text", size: 12))
         .foregroundColor(.white.opacity(0.6))
         .frame(maxWidth: .infinity, alignment: .topLeading)
         .lineLimit(5)
         .padding(.bottom,10)
         StarsView(rating: Float(book.rating) ?? 0.0, maxRating: 5)
         
     }
     .padding(0)
     .frame(alignment: .leading)
 }
 .padding(.top,10)
 .padding(.bottom,20)
 .padding(0)
 .onTapGesture {
     showingSheet.toggle()
     selectedBookUID = BookUID(id: book.uid)
 }
 .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                 MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
     
 }
 Rectangle()
 .foregroundColor(.clear)
 .frame(maxWidth: .infinity,maxHeight: 1)
 .background(Color(red: 0.19, green: 0.19, blue: 0.19))
}
 */
