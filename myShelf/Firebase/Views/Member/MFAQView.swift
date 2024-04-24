//
//  MFAQView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 24/04/24.
//

import SwiftUI

struct MFAQView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center, spacing: 10) {
                    Text("404")
                    .font(Font.custom("SF Pro", size: 30))
                    .foregroundColor(.white)

                }
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .background(Color(red: 0, green: 0.48, blue: 1))
                .cornerRadius(8)
                
                Text("Page not Found")
                .font(
                Font.custom("SF Pro", size: 20)
                .weight(.bold)
                )
                .foregroundColor(.white)
                
                Text("We’re still working on this feature.")
                .font(Font.custom("SF Pro Text", size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.5))
                
            }
            .padding(0)
        }
        .frame(maxWidth:.infinity)
        .background(Color.black.ignoresSafeArea(.all))
    }
}

#Preview {
    MFAQView()
}
