//
//  AEventsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI
import Firebase
struct AEventsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var selectedTag: String?
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView
            {
                
                NavigationStack
                {
                    
                    VStack
                    {
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(alignment: .top){
                                TagView(text: "Ongoing", selectedTag: $selectedTag)
                                TagView(text: "Previous", selectedTag: $selectedTag)
                            }
                        }
                        .padding(.bottom,10)
                        .padding(.leading,10)
                        
                        HStack(alignment: .center)
                        {
                            Text("Events")
                                .font(
                                    Font.custom("SF Pro", size: 20)
                                        .weight(.semibold)
                                )
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.bottom,10)
                        .padding(.leading,10)
                        
                    }
                    .searchable(text: $searchText, isPresented: $searchIsActive)
                }
            }
        }
}

    /*var body: some View {
        if let user = viewModel.currentUser{
            ScrollView{
                VStack{
                    VStack{
                         Text("This is the Adnin Page")
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
            .frame(maxWidth : .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }*/
}

#Preview {
    AEventsView()
}
