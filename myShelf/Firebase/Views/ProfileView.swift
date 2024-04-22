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
                            LibrarianView()
                        case .admin:
                            AdminView()
                        }
                    }
    }
}

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

struct LibrarianView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        // Librarian-specific profile view
        if let user = viewModel.currentUser{
            VStack{
                Text("This is the librarian Page")
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
    ProfileView()
}
