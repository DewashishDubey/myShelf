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
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
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
                
                /*HStack(spacing:130){
                    Text("Select Role")
                    // Picker for roles
                    Picker("Select Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                }*/
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button(action: {
                Task {
                    // Convert the selected role string to UserType enum
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
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}


