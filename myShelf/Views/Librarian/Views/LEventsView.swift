//
//  LEventsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI

struct LEventsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            ScrollView{
                VStack{
                    VStack{
                         Text("This is the Librarian Page")
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
    LEventsView()
}
