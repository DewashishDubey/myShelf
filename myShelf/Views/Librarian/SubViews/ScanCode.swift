//
//  ScanCode.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

/*
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

            
            if let scannedCode = scannedCode 
            {
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
}*/

import SwiftUI
import CodeScanner

struct ScanCode: View {
    @State private var isImagePickerPresented = false
    @State private var scannedCode: String?
    @State private var navigateToNextView = false // New state variable for navigation

    var body: some View {
        NavigationView { // Wrap the VStack in a NavigationView
            VStack {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(10)
                }
                
                
               
                // NavigationLink to navigate to another view only when scan is successful
                NavigationLink(destination: LMemebrDetailView(bookID: scannedCode ?? ""), isActive: $navigateToNextView) {
                    EmptyView()
                }
                .isDetailLink(false)
                .hidden()

                // Show the back button programmatically
                if navigateToNextView {
                    Button(action: {
                        navigateToNextView = false
                    }) {
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerCard(isImagePickerPresented: $isImagePickerPresented, scannedCode: $scannedCode, navigateToNextView: $navigateToNextView) // Pass the navigateToNextView binding
            }
        }
    }
}

struct ImagePickerCard: View {
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


struct ScanCode_Previews: PreviewProvider {
    static var previews: some View {
       ScanCode()
    }
}



