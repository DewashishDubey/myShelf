//
//  MemberView.swift
//  myShelf
//
//  Created by user3 on 23/04/24.
//

import SwiftUI


struct MemberView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    //@StateObject var storeVM = StoreVM()
    var body: some View {
        // Member-specific profile view
        if viewModel.currentUser != nil{
            TabView{
                Group{
                    NavigationStack{
                        MHomeView()
                    }
                    .tabItem {  Label("Home", systemImage: "book") }
                    
                    NavigationStack{
                        MExploreView()
                    }
                    .tabItem {  Label("Explore", systemImage: "magnifyingglass") }
                    
                    NavigationStack{
                        MEventsView()
                    }
                    .tabItem {  Label("Events", systemImage: "theatermasks") }
                    
                    NavigationStack{
                        MLibraryView()
                        //TestView()
                    }
                    .tabItem {  Label("My Library", systemImage: "books.vertical") }
                }
                //.environmentObject(storeVM)
                .toolbarBackground(.black, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
           /* VStack{
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
            }*/
        }
    }
}

struct TabViewAccentColor: UIViewRepresentable {
    var accentColor: UIColor
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = accentColor
    }
}

#Preview {
    MemberView()
}
