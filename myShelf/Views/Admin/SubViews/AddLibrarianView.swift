//
//  AddLibrarianView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI


import SwiftUI
enum Gender {
    case male
    case female
}

struct AddLibrarianView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State var selectedGender: Gender = .male
    @State private var selectedRole = "Librarian"
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var salary = ""
    @State private var phoneNumber: String = ""
    @Environment(\.dismiss) var dismiss
    private var genders = [
    "female",
    "male"]
    
    var body: some View {
        NavigationView{
        ZStack{
            Color.black
                .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20)
            {
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.indigo)
                                .padding(.trailing,38)
                        }
                        Text("Add a New Librarian")
                            .font(
                                Font.custom("SF Pro Text", size: 18)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.trailing,38)
                        
                        Button(action: {
                            Task {
                                guard let userType = UserType(rawValue: selectedRole) else {
                                    print("Invalid role: \(selectedRole)")
                                    return
                                }
                                // Pass the UserType enum to createUser function
                                try await viewModel.createUser(withEmail: email, password: password, fullname: name, userType: userType, gender: selectedGender)
                                dismiss()
                            }                        }) {
                            Text("Save")
                                .font(Font.custom("SF Pro Text", size: 20))
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.indigo)
                        }
                        
                    }.padding(.leading,10)
                        .padding(.bottom,20)
                        .padding(.top,20)
                    VStack(alignment: .center, spacing: 20) {
                        /*
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 100, height: 100)
                            .background(
                                selectedGender == .male ?
                                                        Image("photo").resizable()
                                    
                                    .aspectRatio(contentMode: .fill) :
                                                        Image("photo3").resizable().aspectRatio(contentMode: .fill)
                                    
//                                Image("photo")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 100)
//                                    .clipped()
                            )
                            .cornerRadius(100)
                            .padding(.leading,0)
                            .padding(.bottom,20)*/
                        
                        
                        HStack(alignment: .center, spacing: 15) {Image(systemName: "person.fill")
                                .foregroundColor(.indigo)
                            Text("Name")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing,20)
                            HStack(alignment: .center, spacing: 10) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 1, height: 20)
                                    .background(.gray)
                                    .padding(.trailing,15)
                                TextField("Enter Name", text: $name)
                                    .foregroundColor(.white)
                                    .padding(0)
                                    .frame(width: 110)
                                    .accentColor(.white)
                                
                            }
                            .padding(0)
                            .frame(width: 110, alignment: .leading)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(width: 353, height: 50, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,20)
                        
                        
                        HStack(alignment: .center, spacing: 15) {Image(systemName: "person.crop.square.fill")
                                .foregroundColor(.indigo)
                            Text("Gender")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing,7)
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 1, height: 20)
                                .background(.gray)
                                .padding(.trailing,15)
                            VStack {
                                            Picker("", selection: $selectedGender) {
                                                Text("Male").tag(Gender.male)
                                                Text("Female").tag(Gender.female)
                                            }
                                            .pickerStyle(DefaultPickerStyle())
                                            .foregroundColor(.white)
                                            .padding(0)
                                            .frame(width: 110)
                                            .accentColor(.white)
                                        }
//                            HStack(alignment: .center, spacing: 10) {
                                
//                                    .foregroundColor(.white)
//                                    .padding(0)
//                                    .frame(width: 110)
//                                    .accentColor(.white)
//
//                            }
//                            .padding(0)
//                            .frame(width: 110, alignment: .leading)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(width: 353, height: 50, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,20)
                        
                        HStack(alignment: .center, spacing: 15) {Image(systemName: "envelope.fill")
                                .foregroundColor(.indigo)
                            Text("Email")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing,20)
                            HStack(alignment: .center, spacing: 10) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 1, height: 20)
                                    .background(.gray)
                                    .padding(.trailing,15)
                                TextField("Enter Email", text: $email)
                                    .foregroundColor(.white)
                                    .padding(0)
                                    .frame(width: 110)
                                    .accentColor(.white)
                                
                            }
                            .padding(0)
                            .frame(width: 110, alignment: .leading)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(width: 353, height: 50, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,20)
                        
                        HStack(alignment: .center, spacing: 15) {Image(systemName: "key.fill")
                                .foregroundColor(.indigo)
                            Text("Password")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing,-2)
                            HStack(alignment: .center, spacing: 10) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 1, height: 20)
                                    .background(.gray)
                                    .padding(.trailing,15)
                                TextField("Enter password", text: $password)
                                    .foregroundColor(.white)
                                    .padding(0)
                                    .frame(width: 110)
                                    .accentColor(.white)
                                    
                                
                            }
                            .padding(0)
                            .frame(width: 110, alignment: .leading)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(width: 353, height: 50, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,20)
                        
                        
                        
                        
                        
                    }
                    Spacer()
                    
                   
                    
                }
            
            
            }

            
            
        
        }
       
    }
}



#Preview {
    AddLibrarianView()
}
