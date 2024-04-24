//
//  ExplorePage.swift
//  myShelf
//
//  Created by user3 on 23/04/24.

import SwiftUI

struct PracticalFile: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var showScroll: Bool = false
    
    var body: some View {
        
        NavigationStack
        {
            ScrollView{
                
                ScrollView(.horizontal)
                {
                    HStack(alignment: .top){
                    TagView(text: "Thriller")
                    TagView(text: "Fiction")
                    TagView(text: "Fantansy")
                    TagView(text: "Classic")
                    TagView(text: "Suspense")
                    TagView(text: "Drama")
                    TagView(text: "Horror")
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading)
                {
                    HStack(alignment: .top, spacing: 15) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 120, height: 186)
                            .background(
                                Image("CrazyAsian")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 186)
                                    .clipped()
                            )
                            .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Crazy Rich Asians")
                                .font(
                                    Font.custom("SF Pro Text", size: 14)
                                        .weight(.bold)
                                )
                                .foregroundColor(.white)
                            
                            Text("Kevin Kwan")
                                .font(Font.custom("SF Pro Text", size: 12))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Text("2013 • Romantic Comedy")
                                .font(Font.custom("SF Pro Text", size: 12))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            //                              .padding(.bottom,5)
                            
                            Text("Follows the romantic escapades of Rachel Chu, an American-born Chinese woman, and her boyfriend, Nick Young, who hails from an ultra-wealthy Singaporean family. When Nick invites Rachel to meet his family in Singapore for a wedding, she discovers...")
                                .font(Font.custom("SF Pro Text", size: 10))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                            StarsView(rating: 4, maxRating: 5)
                        }
                    }.padding()
                    Spacer()
                }
                //        .frame(width: .infinity, height: .infinity)
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea(.all))
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        
    }
}



#Preview {
    PracticalFile()
}


