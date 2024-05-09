//
//  TestView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//


//
//  A_FAQs.swift
//  myShelf
//
//  Created by user3 on 07/05/24.
//

import SwiftUI

struct TestView: View {
    @State private var memberData: MemberData?
    
    var body: some View {
        BooksAnalyticsView()
    }
}

#Preview {
    TestView()
        .preferredColorScheme(.dark)
}
