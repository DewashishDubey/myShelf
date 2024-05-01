//
//  LHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI

struct LHomeView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            ZStack{
                Color.black.ignoresSafeArea(.all)
                ScrollView{
                    VStack{
                        NavigationLink{
                            LRequestsView()
                        }label: {
                            HStack(alignment: .center) {
                                Text("Requests")
                                    .font(
                                    Font.custom("SF Pro", size: 14)
                                    .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                            .frame(width: 353, alignment: .center)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(8)
                            .padding(.horizontal,20)
                        }
                       
                        Text(user.fullname)
                        ScanCode()
                    }
                }
            }
        }
    }
}

#Preview {
    LHomeView()
}
