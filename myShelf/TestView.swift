//
//  TestView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//


//
//  A_FAQs.swift
//  myShelf
//
//  Created by user3 on 07/05/24.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var questionText = ""
    @State private var solutionText = ""

    var body: some View {
        VStack(spacing: 40){
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 36, height: 5)
              .background(Color(red: 0.76, green: 0.76, blue: 0.76).opacity(0.5))
              .background(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.4))
              .cornerRadius(2.5)
              .padding(.top,15)
            
            HStack{
                Button("Cancel") {
                    dismiss()
                }
                    .font(Font.custom("SF Pro Text", size: 16))
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                Spacer()
                
                Text("Add FAQ")
                  .font(.custom("SF Pro Text", size: 16))
                  .padding(.trailing,15)
                Spacer()
                
                Button("Save") {
                    dismiss()
                }
                .font(Font.custom("SF Pro Text", size: 16))
                .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
            }.padding(.horizontal)
            
            VStack(alignment: .center, spacing: 15) {
                TextField("Question", text: $questionText)
                    .font(.custom("SF Pro Text", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 329, height: 1)
                  .background(Color(red: 0.25, green: 0.25, blue: 0.25))

                TextField("Solution", text: $solutionText)
                    .font(Font.custom("SF Pro Text", size: 14))
                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            .padding(12)
            .frame(width: 353, alignment: .center)
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(8)
        }
        Spacer()
    }
}

struct WontentView: View {
    @State private var showingSheet = false

    var body: some View {
        Button("Add") {
            showingSheet.toggle()
        }
        .font(Font.custom("SF Pro Text", size: 14))
        .sheet(isPresented: $showingSheet) {
            SheetView()
        }
    }
}

#Preview {
    WontentView()
        .preferredColorScheme(.dark)
}
