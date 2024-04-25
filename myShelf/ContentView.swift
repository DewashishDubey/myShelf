//
//  ContentView.swift
//  myShelf
// amogh jain 
//  Created by Dewashish Dubey on 22/04/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
//        Group{
//            if viewModel.userSession != nil{
//                ProfileView()
//            }
//            else{
//                LoginView()
//            }
//        }
        MLibraryView()
    }
}

#Preview {
    ContentView()
}
