//
//  MLibraryView.swift
//  myShelf
//
//  Created by user3 on 25/04/24.


import SwiftUI

struct MLibraryView_2: View {
    
    let books: [Book] = [
        Book(title: "Crazy Asians"/*, imageName: "girl_on_train"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "Crazy Asians"/*, imageName: "girl_on_train"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
        Book(title: "INFERNO"/*, imageName: "inferno"*/),
    ]
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
        
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(books) { book in
                        BookCoverView(book: book)
                    }
                }
                  
            }
            
        }
       // .searchable(text: $searchText, isPresented: $searchIsActive)
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


#Preview {
    MLibraryView_2()
        .preferredColorScheme(.dark)
}
