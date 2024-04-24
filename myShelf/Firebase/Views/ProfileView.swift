//
//  ProfileView.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//

import SwiftUI

/*
struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            VStack{
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
*/

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
                        switch user.userType {
                        case .member:
                            MemberView()
                        case .librarian:
                            //ContentView1()
                            LibrarianView()
                        case .admin:
                            AdminView()
                        }
                    }
    }
}



#Preview {
    ProfileView()
}
