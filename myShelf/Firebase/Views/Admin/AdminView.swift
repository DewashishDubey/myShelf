//
//  AdminView.swift
//  myShelf
//
//  Created by user3 on 23/04/24.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        // Admin-specific profile view
        if let user = viewModel.currentUser{
            VStack{
                Text("This is the admin Page")
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
}

#Preview {
    AdminView()
}
