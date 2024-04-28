//
//  LScanMember.swift
//  myShelf
//
//  Created by Dewashish Dubey on 28/04/24.
//

import SwiftUI
import CodeScanner

struct LScanMember: View {
    @State private var isImagePickerPresented = false
    @State private var scannedCode: String?
    @State private var navigateToNextView = false
    let bookID : String
    var body: some View {
        VStack {
            Button(action: {
                isImagePickerPresented = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .padding(10)
            }

            
            
            NavigationLink(destination: LBookIssueView(bookID: bookID, MemberID: scannedCode ?? ""), isActive: $navigateToNextView) {
                EmptyView()
            }
            .isDetailLink(false)
            .hidden()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerCard1(isImagePickerPresented: $isImagePickerPresented, scannedCode: $scannedCode, navigateToNextView: $navigateToNextView)
        }
    }
}

struct ImagePickerCard1: View {
    @Binding var isImagePickerPresented: Bool
    @Binding var scannedCode: String?
    @Binding var navigateToNextView: Bool
    var body: some View {
        VStack {
            CodeScannerView(
                codeTypes: [.qr],
                completion: { result in
                    isImagePickerPresented = false
                    switch result {
                    case let .success(scannedResult):
                        let scannedString = scannedResult.string
                        scannedCode = scannedString
                        navigateToNextView = true
                    case .failure:
                        print("Scanning failed")
                    }
                }
            )
        }
    }
}

struct LScanMember_Previews: PreviewProvider {
    static var previews: some View {
        LScanMember(bookID: "")
    }
}
