//
//  ExplorePage.swift
//  myShelf
//
//  Created by user3 on 23/04/24.

import SwiftUI

struct MExploreView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    var body: some View {
        NavigationStack
        {
            Color.black.ignoresSafeArea(.all)
            VStack{}
                .background(Color.gray.opacity(0.3))
            .searchable(text: $searchText, isPresented: $searchIsActive)
        }
    }
}


#Preview {
    MExploreView()
}


