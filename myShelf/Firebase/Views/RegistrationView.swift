//
//  RegistrationView.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedRole = "Member" // Default selection
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    let roles = ["Member", "Librarian", "Admin"] // Define roles
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Register")
                    .font(
                        Font.custom("SF Pro", size: 20)
                    )
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom,30)
                
                Text("Enter your details below to create a new account.")
                    .font(
                        Font.custom("SF Pro", size: 14)
                    )
                    .foregroundStyle(.gray)
                    .padding(.bottom,10)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading,15)
                
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email address", placeholder: "name@example.com", isSecureField: false)
                        .autocapitalization(.none)
                    
                    InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name", isSecureField: false)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Password", placeholder: "Confirm your password", isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                    
    //                HStack(spacing:130){
    //                    Text("Select Role")
    //                    // Picker for roles
    //                    Picker("Select Role", selection: $selectedRole) {
    //                        ForEach(roles, id: \.self) { role in
    //                            Text(role)
    //                        }
    //                    }
    //                    .pickerStyle(.menu)
    //                    .padding(.horizontal)
    //                }
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button(action: {
                    Task {
                        guard let userType = UserType(rawValue: selectedRole) else {
                            print("Invalid role: \(selectedRole)")
                            return
                        }
                        // Pass the UserType enum to createUser function
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, userType: userType)
                    }
                }) {
                    HStack {
                        Text("Sign up")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.indigo)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .foregroundStyle(Color.white)
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.indigo)
                    }
                    .font(.system(size: 14))
                }
            }
            .padding(.top,40)
        }
        .frame(maxWidth : .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
        /*
        VStack {
            VStack(spacing: 24) {
                InputView(text: $email, title: "Email address", placeholder: "name@example.com", isSecureField: false)
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name", isSecureField: false)
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword, title: "Password", placeholder: "Confirm your password", isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                        }
                    }
                }
                
//                HStack(spacing:130){
//                    Text("Select Role")
//                    // Picker for roles
//                    Picker("Select Role", selection: $selectedRole) {
//                        ForEach(roles, id: \.self) { role in
//                            Text(role)
//                        }
//                    }
//                    .pickerStyle(.menu)
//                    .padding(.horizontal)
//                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button(action: {
                Task {
                    guard let userType = UserType(rawValue: selectedRole) else {
                        print("Invalid role: \(selectedRole)")
                        return
                    }
                    // Pass the UserType enum to createUser function
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, userType: userType)
                }
            }) {
                HStack {
                    Text("Sign up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }*/
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}


