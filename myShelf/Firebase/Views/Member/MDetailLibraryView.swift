//
//  MDetailLibraryView.swift
//  myShelf
//
//  Created by user3 on 29/04/24.
//

import SwiftUI

struct MDetailLibraryView: View {
    var body: some View {
        VStack {
            Image("CrazyAsian")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 210)
                .cornerRadius(8)
                .clipped()
                .padding(.bottom,30)
            
            HStack{
                Text("Borrowed on")
                    .font(.custom("SFProText-Medium", size: 14))
                Spacer()
                Text("12 June 2024")
                    .font(.custom("SFProText-Medium", size: 14))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                
            }.padding(.horizontal)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity, maxHeight: 1)
              .background(Color(red: 0.19, green: 0.19, blue: 0.19))
              .padding(.horizontal)
              .padding(.top,20)
              .padding(.bottom,20)
            
            HStack{
                Text("Return due on")
                    .font(.custom("SFProText-Medium", size: 14))
                Spacer()
                Text("14 June 2024")
                    .font(.custom("SFProText-Medium", size: 14))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                
            }.padding(.horizontal)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity, maxHeight: 1)
              .background(Color(red: 0.19, green: 0.19, blue: 0.19))
              .padding(.horizontal)
              .padding(.top,20)
              .padding(.bottom,20)
            
            HStack{
                Text("Status")
                    .font(.custom("SFProText-Medium", size: 14))
                Spacer()
                Text("Overdue")
                    .font(.custom("SFProText-Medium", size: 14))
                    .foregroundColor(Color.red)
                
            }.padding(.horizontal)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity, maxHeight: 1)
              .background(Color(red: 0.19, green: 0.19, blue: 0.19))
              .padding(.horizontal)
              .padding(.top,20)
              .padding(.bottom,20)
            
            HStack{
                Text("Fine Amount")
                    .font(.custom("SFProText-Medium", size: 14))
                Spacer()
                Text("₹50")
                    .font(.custom("SFProText-Medium", size: 14))
                    .foregroundColor(Color.yellow)
                
            }.padding(.horizontal)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Pay Due and Return")
                    .foregroundColor(.red)
                    .padding(.top,30)
            })
            Spacer()
        }
        
    }
}

#Preview {
    MDetailLibraryView()
        .preferredColorScheme(.dark)
}
