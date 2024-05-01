//
//  LRequestsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 01/05/24.
//

import SwiftUI

struct LRequestsView: View {
    @ObservedObject var viewModel = ExtensionRequestViewModel()
    var body: some View {
        ForEach(viewModel.extensionRequests, id: \.documentID) { request in
                        VStack(alignment: .leading) {
                            Text("Document ID: \(request.documentID)")
                            Text("Reserved Book ID: \(request.reservedBookID)")
                            Text("UID: \(request.uid)")
                            Text("User ID: \(request.userID)")
                        }
                    }
        .onAppear{
            viewModel.fetchData()
        }
    }
    
}

#Preview {
    LRequestsView()
}
