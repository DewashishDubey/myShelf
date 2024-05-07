//
//  MFAQView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 24/04/24.
//

import SwiftUI

struct MFAQView: View {
    @ObservedObject var viewModel = FAQViewModel()
    var body: some View {
        ZStack
        {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                      VStack(spacing: 20) {
                          ForEach(viewModel.FAQs) { faq in
                              MQuestions(questions: faq.question, answers: faq.solution,id : faq.id ?? "")
                          }
                      }
                      .padding()
                  }
                  .onAppear {
                      viewModel.fetchData()
                  }
                  .padding()
        }
        .navigationTitle("FAQ")
    }
}

struct MQuestions: View{
    let questions: String
    let answers: String
    let id : String
    @State private var offsets = [CGSize](repeating: CGSize.zero, count: 6)
    var body: some View{
        HStack{
            
            DisclosureGroup
            {
                
                Text(answers)
                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                    .font(.custom("SF Pro Text", size: 14))
                    .padding(.bottom,10)
               // Text(id)
            }
        label: {
            
            Text(questions)
                .foregroundColor(.white)
                .font(.custom("SF Pro Text", size: 16))
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(.white)
            
            
        }
        .padding(12)
        .frame(width: 353)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(8)
    }
}

#Preview {
    MFAQView()
}
