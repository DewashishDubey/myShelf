//
//  AEventsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI

struct AEventsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            ScrollView{
                VStack{
                    VStack{
                         Text("This is the Adnin Page")
                         Text(user.fullname)
                         Text(user.userType.rawValue)
                         Section("Account")
                         {
                             Button{
                                 viewModel.signOut()
                             } label: {
                                 SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                             }
                         }
                         Spacer()
                     }
                }
            }
            .frame(maxWidth : .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    AEventsView()
}
