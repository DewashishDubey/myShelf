//
//  LReturnBookDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LReturnBookDetailView: View {
    var docID : String
    let memberID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var returned = false
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
                        
                        
                        
                        
                            Button(action: {
                                //requestExtension(reservedBookID: reservedBook.bookID)
                            }, label: {
                                Text("Pay fine and return")
                                    .font(Font.custom("SF Pro Text", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                            })
                            .alert(isPresented: $returned) {
                                Alert(title: Text("Extension request made to librarian"))
                            }
                            
                        
                       

                    }
                }
            }
        }
        .onAppear{
            bookViewModel.fetchReservedBook(for: memberID, documentID: docID)
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
    LReturnBookDetailView(docID: "", memberID: "")
}
