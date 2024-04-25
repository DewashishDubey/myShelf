//
//  LProfileView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI

struct LProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            ScrollView{
                VStack{
                    Text(user.fullname)
                }
            }
            .frame(maxWidth : .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    LProfileView()
}
