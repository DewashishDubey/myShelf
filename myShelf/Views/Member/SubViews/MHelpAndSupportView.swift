//
//  MHelpAndSupportView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 06/05/24.
//

import SwiftUI

struct MHelpAndSupportView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView{
            }
        }
    }
}

#Preview {
    MHelpAndSupportView()
}
