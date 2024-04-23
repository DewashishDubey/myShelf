//
//  ExplorePage.swift
//  myShelf
//
//  Created by user3 on 23/04/24.
//

import SwiftUI

struct ExplorePage: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    var body: some View {
        ZStack{
            NavigationStack {
//                Text("Searching for \(searchText)")
            }
            .searchable(text: $searchText, isPresented: $searchIsActive)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ExplorePage()
}
