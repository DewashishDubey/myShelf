//
//  LoginView.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "Member" // Default selection
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    
    let roles = ["Member", "Librarian", "Admin"] // Define roles
    
    var body: some View {
        NavigationView {
            VStack {
                // Image
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Form fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email address", placeholder: "name@example.com", isSecureField: false)
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    
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
                
                // Sign in button
                Button(action: {
                    Task {
                                            do {
                                                // Attempt to sign in with provided email and password
                                                try await viewModel.signIn(withEmail: email, password: password)
                                            } catch {
                                                // Handle sign-in error
                                               
                                                self.showAlert.toggle()
                                                print("Failed to sign in with error: \(error.localizedDescription)")
                                            }
                                        }
                }) {
                    HStack {
                        Text("Sign in")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 24)
                .alert(isPresented: $showAlert) {
                        return Alert(title: Text("Failed to register"), message: Text("Invalid login credentials"), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
                
                // Sign up button
                NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
