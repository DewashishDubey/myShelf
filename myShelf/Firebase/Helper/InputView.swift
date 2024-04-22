//
//  InputView.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text : String
    let title : String
    let placeholder : String
    var isSecureField = false
    var body: some View {
        VStack(alignment : .leading,spacing: 12)
        {
            Text(title)
                .foregroundStyle(Color.gray)
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField
            {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .textContentType(.oneTimeCode)
            }
            else
            {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .textContentType(.oneTimeCode)
            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "Name@example.com")
}
