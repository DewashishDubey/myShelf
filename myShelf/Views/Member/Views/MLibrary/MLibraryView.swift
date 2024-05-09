//
//  MLibraryView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//


import SwiftUI

struct MLibraryView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var isGridViewActive = false // New state variable to track grid view
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            NavigationStack {
                ScrollView(showsIndicators: false) 
                {
                    /*HStack {
                        TagsView(text: "All Books")
                            .padding(.leading)
                        TagsView(text: "Borrowed")
                        TagsView(text: "Reserved")
                        Spacer()
                    }*/
                    HStack {
                        Text("\(isGridViewActive ? "myShelf" : "All Books")")
                            .font(Font.custom("SF Pro", size: 20))
                            .padding(.top,20)
                            .padding(.bottom,20)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            // Toggle between grid and list view
                            isGridViewActive = true
                        }, label: {
                            Image(systemName: "square.grid.2x2")
                                .foregroundColor(isGridViewActive ? .blue : .gray)
                        })
                        
                        Button(action: {
                            // Toggle between grid and list view
                            isGridViewActive = false
                        }, label: {
                            Image(systemName: "list.dash")
                                .foregroundColor(isGridViewActive ? .gray : .blue)
                        })
                    }
                    .padding(.horizontal)
                    
                    // Display different views based on the selected mode
                    if isGridViewActive {
                        MLibraryGridView()// Display grid view
                    } else {
                        BorrowedBooks() // Display list view
                    }
                }
                //.searchable(text: $searchText, isPresented: $searchIsActive)
            }
            
            //.preferredColorScheme(.dark)
        }
    }
}


struct BorrowedBooks: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject private var issuedBooksViewModel = IssuedBooksViewModel()
    @StateObject private var previouslyIssuedBooksViewModel = PreviouslyReservedBooksViewModel()
    
    var body: some View {
        VStack{
            ForEach(issuedBooksViewModel.issuedBooks)
            { issuedBook in
                NavigationLink{
                    MBorrowedBookView(docID: issuedBook.documentID)
                }label: {
                    VStack(alignment: .leading,spacing: 20)
                    {
                        
                        HStack(alignment: .top,spacing: 10)
                        {
                            
                            AsyncImage(url: URL(string: issuedBook.book.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 90)
                                        .clipped()
                                        .padding(.trailing,10)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 90)
                                        .clipped()
                                        .padding(.trailing,10)
                                @unknown default:
                                    Text("Unknown")
                                }
                            }
                            .frame(width: 60, height: 90)
                            .clipped()
                            .padding(.trailing,10)
                            
                            HStack(alignment:.top,spacing: 10){
                                VStack(alignment: .leading,spacing: 10){
                                    Text(issuedBook.book.title)
                                    /*.font(
                                     Font.custom("SF Pro Text", size: 14)
                                     .weight(.semibold)
                                     )*/
                                        .font(.custom("SFProText-Semibold", size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(issuedBook.book.authors[0])
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Text("Borrowed on: \(trimTime(from: issuedBook.startDateString))")
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Text("Return Due on: \(trimTime(from: issuedBook.endDateString))")
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    
                                }
                                .padding(.leading,2)
                                .padding(.top,4)
                                
                                Text("Borrowed")
                                    .font(
                                        Font.custom("SF Pro", size: 12)
                                            .weight(.semibold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.02))
                                    .padding(.top,4)
                            }
                        }
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 353, height: 1)
                            .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                }
                
            ForEach(previouslyIssuedBooksViewModel.reservedBooks)
            { issuedBook in
                NavigationLink{
                    MPreviouslyIssuedBooksView(docID: issuedBook.documentID)
                }label: {
                    VStack(alignment: .leading,spacing: 20)
                    {
                        HStack(alignment: .top,spacing: 10)
                        {
                            
                            AsyncImage(url: URL(string: issuedBook.book.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 90)
                                        .clipped()
                                        .padding(.trailing,10)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 90)
                                        .clipped()
                                        .padding(.trailing,10)
                                @unknown default:
                                    Text("Unknown")
                                }
                            }
                            .frame(width: 60, height: 90)
                            .clipped()
                            .padding(.trailing,10)
                            
                            HStack(alignment:.top,spacing: 10){
                                VStack(alignment: .leading,spacing: 10){
                                    Text(issuedBook.book.title)
                                    /*.font(
                                     Font.custom("SF Pro Text", size: 14)
                                     .weight(.semibold)
                                     )*/
                                        .font(.custom("SFProText-Semibold", size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text(issuedBook.book.authors[0])
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Text("Borrowed on: \(trimTime(from: issuedBook.startDateString))")
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Text("Returned on: \(trimTime(from: issuedBook.endDateString))")
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    
                                }
                                .padding(.leading,2)
                                .padding(.top,4)
                                
                                Text("Returned")
                                    .font(
                                        Font.custom("SF Pro", size: 12)
                                            .weight(.semibold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.green)
                                    .padding(.top,4)
                            }
                        }
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 353, height: 1)
                            .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                }
                
        }
        .onAppear {
            issuedBooksViewModel.fetchIssuedBooks(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1")
            previouslyIssuedBooksViewModel.fetchReservedBooks(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1")
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
        }
    }
}

#Preview {
    MLibraryView()
        //.preferredColorScheme(.dark)
}
