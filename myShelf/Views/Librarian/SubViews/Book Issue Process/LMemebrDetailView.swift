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
                            .frame(width: 140, height: 210)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 140, height: 210)
                            .clipped()
                            .cornerRadius(10)
                    @unknown default:
                        Text("Unknown")
                    }
                }
                .frame(width: 140, height: 210)
                .clipped()
                .cornerRadius(10)
                
                Text(book.title)
                    .font(Font.custom("SF Pro", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 313)
                    .padding(.top,30)
                    .padding(.bottom,30)
                
                HStack{
                    Text("No of Copies Available")
                    Spacer()
                    Text(book.noOfCopies)
                }
                .padding(.horizontal)
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 353, height: 1)
                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                HStack{
                    Text("Book Location")
                    Spacer()
                    Text(book.shelfLocation)
                }
                .padding(.horizontal)
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 353, height: 1)
                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                if(Int(book.noOfCopies) ?? 0 > 0){
                    /*Text("Available")
                        .font(Font.custom("SF Pro Text", size: 18))
                        .foregroundColor(Color.green)*/
                    LScanMember(bookID: bookID)
                        .padding(.top,20)
                }
                else{
                    /*Text("Not Available")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(Color.red)*/
                }
                
            }
            else{
                Text("Scan the Book QR First!")
                
            }
            
            Spacer()
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
        .navigationTitle("Scan Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    LMemebrDetailView(bookID: "")
}
