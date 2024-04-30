//
//  MBorrowedBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 30/04/24.
//

import SwiftUI

struct MBorrowedBookView: View {
    let docID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        VStack{
            ForEach(bookViewModel.reservedBooks) { reservedBook in
                Text(reservedBook.book.title)
                    .foregroundStyle(Color.white)
            }
        }
        .onAppear{
            bookViewModel.fetchReservedBook(for: viewModel.currentUser?.id ?? "", documentID: docID)
        }
    }
    
}

#Preview {
    MBorrowedBookView(docID: "")
}
