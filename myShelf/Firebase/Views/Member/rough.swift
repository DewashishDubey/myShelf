////
////  rough.swift
////  myShelf
////
////  Created by user3 on 29/04/24.
////
//
//import SwiftUI
//
//struct BorrowedBooks: View {
//    var body: some View {
//        VStack(alignment: .leading,spacing: 20){
//            HStack(alignment: .top,spacing: 10){
//                
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: 120, height: 200)
//                        .background(
//                            Image("CrazyAsian")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 60, height: 90)
//                                .clipped()
//                            
//                                .padding(.bottom,100)
//                        )
//                        .cornerRadius(6)
//                
//                HStack(alignment:.top,spacing: 10){
//                    VStack(alignment: .leading,spacing: 10){
//                        Text("Crazy Rich Asians")
//                            .font(
//                                Font.custom("SF Pro Text", size: 14)
//                                    .weight(.semibold)
//                            )
//                            .foregroundColor(.white)
//                        Text("Kevin Kwan")
//                            .font(Font.custom("SF Pro Text", size: 12))
//                            .foregroundColor(.white.opacity(0.6))
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                        
//                        Text("Borrowed on: 20 Apr 24")
//                            .font(Font.custom("SF Pro Text", size: 12))
//                            .foregroundColor(.white.opacity(0.6))
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                        
//                        Text("Returned Due on: 29 Apr 24")
//                            .font(Font.custom("SF Pro Text", size: 12))
//                            .foregroundColor(.white.opacity(0.6))
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                        
//                        
//                    }
//                    .padding(.leading,2)
//                    .padding(.top,4)
//                    
//                    Text("Borrowed")
//                        .font(
//                            Font.custom("SF Pro", size: 12)
//                                .weight(.semibold)
//                        )
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.02))
//                        .padding(.trailing,20)
//                        .padding(.top,4)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    BorrowedBooks()
//        .preferredColorScheme(.dark)
//}
