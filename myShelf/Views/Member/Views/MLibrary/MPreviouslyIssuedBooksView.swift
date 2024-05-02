//
//  MPreviouslyIssuedBooksView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//


import SwiftUI
import Firebase
struct MPreviouslyIssuedBooksView: View {
    var docID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var existingRequest = false
    @State private var alreadyRequested = false
    @State private var isPremium: Bool = false
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView{
               // Text(viewModel.currentUser?.id ?? "")
                VStack(spacing:20){
                    ForEach(bookViewModel.reservedBooks) { reservedBook in
                       // Text(reservedBook.documentID)
                        Text(reservedBook.book.title)
                            .font(
                            Font.custom("SF Pro Text", size: 20)
                            .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        AsyncImage(url: URL(string: reservedBook.book.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                        .frame(width: 240, height: 210)
                        .padding(5)
                        .padding(.bottom,20)
                        HStack{
                            Text("Borrowed On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.startDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Return due On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.endDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Fine Amount")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(reservedBook.fine)")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        
                        
                        
                    }
                }
            }
        }
        .onAppear{
            bookViewModel.fetchPreviouslyReservedBook(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1", documentID: docID)
        }
        
        
    }
    private func trimTime(from dateString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
           
           if let date = dateFormatter.date(from: dateString) {
               dateFormatter.dateFormat = "MMM d, yyyy"
               return dateFormatter.string(from: date)
           } else {
               return dateString // Return original string if unable to parse
           }
       }
    
}

#Preview {
    MPreviouslyIssuedBooksView(docID: "")
}

