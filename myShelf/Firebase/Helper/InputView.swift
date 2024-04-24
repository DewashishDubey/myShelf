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
            .font(
            Font.custom("SF Pro", size: 14)
            .weight(.semibold)
            )
            .foregroundColor(.white)
            if isSecureField
            {
                SecureField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Image(systemName: "key")
                            .foregroundColor(.gray)
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading,25)
                }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .leading)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            else
            {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        if(title == "Full Name"){
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName: "at")
                                .foregroundColor(.gray)
                        }
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading,25)
                }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .leading)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))

                    .cornerRadius(8)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(.white)
            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "Name@example.com")
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
