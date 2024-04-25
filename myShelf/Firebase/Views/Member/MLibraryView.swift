//
//  MLibraryView.swift
//  myShelf
//
//  Created by user3 on 25/04/24.
//

import SwiftUI

struct MLibraryView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    let books: [Book] = [
        Book(title: "Crazy Asians"/*, imageName: "girl_on_train"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
    ]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack {
                    TagsView(text: "All Books")
                    Spacer()
                    TagsView(text: "Categories")
                    Spacer()
                    TagsView(text: "Borrowed")
                    Spacer()
                    TagsView(text: "Reserved")
                }
                Text("All Books")
                  .font(Font.custom("SF Pro", size: 20))
                  .padding(.top)
                  .padding(.trailing,270)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(books) { book in
                        BookCoverView(book: book)
                    }
                }
                .padding()
                  
            }
            
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        .preferredColorScheme(.dark)
    }
}



struct Book: Identifiable {
    let id = UUID()
    let title: String
}

struct BookCoverView: View {
    let book: Book

    var body: some View {
        VStack {
            Image("CrazyAsian")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 104, height: 154.64)
                .padding(5)
        }
    }
}




struct TagsView: View {
    let text: String
    
    var body: some View {
        Button(action: {
            
        }) {
            Text(text)
                .font(Font.custom("SF Pro Text", size: 12))
                .foregroundColor(.white.opacity(0.6))
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
        }.padding(.leading)
    }
}

#Preview {
    MLibraryView()
}
