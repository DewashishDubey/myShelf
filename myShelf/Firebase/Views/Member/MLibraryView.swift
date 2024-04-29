//
//  MLibraryView.swift
//  myShelf
//
//  Created by user3 on 25/04/24.


import SwiftUI
struct MLibraryView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var isGridViewActive = false // New state variable to track grid view

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    TagsView(text: "All Books")
                        .padding(.leading)
                    TagsView(text: "Borrowed")
                    TagsView(text: "Reserved")
                    Spacer()
                }
                HStack {
                    Text("All Books")
                        .font(Font.custom("SF Pro", size: 20))
                        .padding(.top,20)
                        .padding(.bottom,20)
                    
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
                     MLibraryView_2()// Display grid view
                } else {
                    BorrowedBooks() // Display list view
                }
            }
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        .preferredColorScheme(.dark)
    }
}


struct BorrowedBooks: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 20)
        {
            HStack(alignment: .top,spacing: 10){
 
                Image("CrazyAsian")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 90)
                    .clipped()
                    .padding(.trailing,10)
                
                HStack(alignment:.top,spacing: 10){
                    VStack(alignment: .leading,spacing: 10){
                        Text("Crazy Rich Asians")
                            /*.font(
                                Font.custom("SF Pro Text", size: 14)
                                    .weight(.semibold)
                            )*/
                            .font(.custom("SFProText-Semibold", size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Kevin Kwan")
                            .font(Font.custom("SF Pro Text", size: 12))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Text("Borrowed on: 20 Apr 24")
                            .font(Font.custom("SF Pro Text", size: 12))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Text("Returned Due on: 29 Apr 24")
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
        .preferredColorScheme(.dark)
}
