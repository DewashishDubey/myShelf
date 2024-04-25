import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    var body: some View {
        
        NavigationStack
        {
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        .preferredColorScheme(.dark)
    }
}



