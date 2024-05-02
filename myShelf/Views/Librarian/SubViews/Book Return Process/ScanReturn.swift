//
//  ScanReturn.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import CodeScanner
import Firebase
struct ScanReturn: View {
    @State private var isImagePickerPresented = false
    @State private var scannedCode: String?
    @State private var navigateToNextView = false
    var body: some View {
        VStack {
            Button(action: {
                isImagePickerPresented = true
            }) {
                HStack{
                    Text("Check-Out")
                        .font(
                        Font.custom("SF Pro", size: 14)
                        .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(maxWidth: 20,maxHeight: 20)
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(10)
                }
                .frame(maxWidth: .infinity,maxHeight: 40)
                .padding(20)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
            }

            Spacer()
            
            NavigationLink(destination: LReturnDetailView(MemberID: scannedCode ?? ""), isActive: $navigateToNextView) {
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


struct LScanReturn_Previews: PreviewProvider {
    static var previews: some View {
        ScanReturn()
    }
}

