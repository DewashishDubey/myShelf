//
//  LibrarianView.swift
//  myShelf
//
//  Created by user3 on 23/04/24.
//

import SwiftUI

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

#Preview {
    LibrarianView()
}
