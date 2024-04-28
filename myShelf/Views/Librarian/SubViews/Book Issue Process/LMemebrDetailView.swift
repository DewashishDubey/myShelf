//
//  LMemebrDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 28/04/24.
//

import SwiftUI

struct LMemebrDetailView: View {
    let bookID : String
    @ObservedObject var firebaseManager = FirebaseManager()
    var body: some View {
        VStack
        {
            Text(bookID)
            if let book = firebaseManager.books.first(where: { $0.uid == bookID })
            {
                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 230, height: 355)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 230, height: 355)
                            .clipped()
                            .cornerRadius(10)
                    @unknown default:
                        Text("Unknown")
                    }
                }
                .frame(width: 230, height: 355)
                .clipped()
                .cornerRadius(10)
                
                Text(book.title)
                    .font(Font.custom("SF Pro", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 313)
                    .padding(.top,30)
                
                if(Int(book.noOfCopies) ?? 0 > 0){
                    Text("Available")
                        .font(Font.custom("SF Pro Text", size: 18))
                        .foregroundColor(Color.green)
                    Text("Now can the memebre QR")
                    LScanMember(bookID: bookID)
                }
                else{
                    Text("Not Available")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(Color.red)
                }
                
            }
            
            Spacer()
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
    }
}

#Preview {
    LMemebrDetailView(bookID: "")
}
