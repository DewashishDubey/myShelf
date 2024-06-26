//
//  AProfileView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 06/05/24.
//


import SwiftUI
import FirebaseFirestore
import CoreImage.CIFilterBuiltins

struct AProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPremiumMember: Bool = false
    
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        if let user = viewModel.currentUser{
            ScrollView
            {
                VStack{
                    HStack(alignment: .center, spacing: 15){
                        Image("female")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 10){
                            HStack(alignment: .center) {
                                Text(user.fullname)
                                    .font(
                                        Font.custom("SF Pro", size: 16)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            
                            Text(user.email)
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            Text("Admin")
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.medium)
                                )
                                .foregroundColor(.yellow)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))

                    .cornerRadius(10)
                }
                .frame(maxWidth:.infinity)
                .padding()
                
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    
                    NavigationLink {
                        AFAQView()
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "info.circle")
                            .foregroundColor(Color(red: 0, green: 0.48, blue: 1))

                            .frame(width: 25, alignment: .top)
                        // Space Between
                            Text("FAQs")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .foregroundColor(.white)
                        Spacer()
                        // Alternative Views and Spacers
                            Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal, 0)
                        .frame(width: 313, alignment: .center)
                        
                        
                    }
                    
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 313, height: 0.5)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                    

                    
                    NavigationLink {
                        AGriveanceView()
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "message")
                                .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                            
                                .frame(width: 25, alignment: .top)
                            // Space Between
                            Text("Help and Support")
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            // Alternative Views and Spacers
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal, 0)
                        .frame(width: 313, alignment: .center)
                    }
                    
                    
                }
                .padding(20)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(10)
                
                
                
                VStack(alignment:.leading) {
                    Button {
                        viewModel.signOut()
                        self.isPremiumMember = false
                    } label: {
                        Text("Logout")
                            .font(
                            Font.custom("SF Pro", size: 14)
                            .weight(.medium)
                            )
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                }

                
            }
            .onAppear {
                fetchMemberData()
            }
            .frame(maxWidth : .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }

    }
    
    func fetchMemberData() {
        if let userId = viewModel.currentUser?.id {
            if let qrImage = generateQRCode(from: userId) {
                            qrCodeImage = qrImage
                        }
            let membersRef = Firestore.firestore().collection("members").document(userId)
            membersRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let isPremium = document.data()?["is_premium"] as? Bool {
                        self.isPremiumMember = isPremium
                    }
                } else {
                    print("Member document does not exist or could not be retrieved: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    
}


#Preview {
    AProfileView()
}
