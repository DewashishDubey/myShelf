//
//  MProfileView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//

import SwiftUI

struct MProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        VStack
        {
            Button{
                viewModel.signOut()
            } label: {
                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
            }
        }
    }
}

#Preview {
    MProfileView()
}
