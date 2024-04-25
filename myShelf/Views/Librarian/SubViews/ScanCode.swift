//
//  ScanCode.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI
import CodeScanner

struct ScanCode: View {
    @State private var isImagePickerPresented = false
    @State private var scannedCode: String?


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

            
            if let scannedCode = scannedCode {
                Text("Scanned Code: \(scannedCode)")
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerCard(isImagePickerPresented: $isImagePickerPresented, scannedCode: $scannedCode)
        }
    }
}

struct ImagePickerCard: View {
    @Binding var isImagePickerPresented: Bool
    @Binding var scannedCode: String?
    

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
                    
                    case .failure:
                        print("Scanning failed")
                    }
                }
            )
        }
    }
}

struct ScanCode_Previews: PreviewProvider {
    static var previews: some View {
       ScanCode()
    }
}


