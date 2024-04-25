//
//  MemberView.swift
//  myShelf
//
//  Created by user3 on 23/04/24.
//

import SwiftUI


struct MemberView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        // Member-specific profile view
        if let user = viewModel.currentUser{
            VStack{
                Text("This is the member Page")
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
    MemberView()
}