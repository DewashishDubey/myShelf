//
//  LoginView.swift
//  MultiUserTypeLoginTest
// Amogh Jain
//  Created by Dewashish Dubey on 20/04/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "Member" // Default selection
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var showSplash = true
    let roles = ["Member", "Librarian", "Admin"] // Define roles
    
    var body: some View {
        NavigationStack
        {
            if showSplash{
                OnboardingView()
            }
            else
            {
                ScrollView{
                    VStack(alignment: .center)
                    {
                        Text("User Login")
                            .font(
                                Font.custom("SF Pro", size: 20)
                            )
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom,30)
                        
                        Text("Login with your registered account or quick login with your Google account.")
                            .font(
                                Font.custom("SF Pro", size: 14)
                            )
                            .foregroundStyle(.gray)
                            .padding(.bottom,10)
                        
                        // Form fields
                        VStack(spacing: 24) {
                            InputView(text: $email, title: "Email address", placeholder: "name@example.com", isSecureField: false)
                                .autocapitalization(.none)
                            InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                                .padding(.bottom,20)
                            
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
                                Text("Log in")
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 18)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color(red:0.26,green:0.52,blue:0.96))
                                
                                    .cornerRadius(8)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        }
                        .padding(.bottom,25)
                        .alert(isPresented: $showAlert) {
                            return Alert(title: Text("Failed to register"), message: Text("Invalid login credentials"), dismissButton: .default(Text("OK")))
                        }
                        
                        // Sign up button
                        NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                            HStack(spacing: 3) {
                                Text("Don't have a member account?")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16))
                                    .padding(.leading,10)
                                Text("Create one!")
                                    .foregroundStyle(Color(red:0.26,green:0.52,blue:0.96))
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                            }
                            .font(.system(size: 14))
                        }
                    }
                    .padding(.top,40)
                }
                .frame(maxWidth : .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
           
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                withAnimation{
                    self.showSplash = false
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




//for refrence
/*
// NavigationView
// {
    ZStack{
        Color.black.ignoresSafeArea(.all)
        VStack(alignment: .center) {
            Text("User Login")
                .font(
                Font.custom("SF Pro", size: 20)
                .weight(.bold)
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
            
            Text("Login with your registered account or quick login with your Google account.")
                .foregroundStyle(.gray)
                .padding(.bottom,10)
            
            // Form fields
            VStack(spacing: 24) {
                InputView(text: $email, title: "Email address", placeholder: "name@example.com", isSecureField: false)
                    .autocapitalization(.none)
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    .padding(.bottom,20)
                
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
                    Text("Log in")
                        .foregroundStyle(Color(uiColor: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color(uiColor: .systemIndigo).opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .padding(.bottom,25)
            .alert(isPresented: $showAlert) {
                return Alert(title: Text("Failed to register"), message: Text("Invalid login credentials"), dismissButton: .default(Text("OK")))
            }
                                
            // Sign up button
            NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                HStack(spacing: 3) {
                    Text("Don't have a member account?")
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                        .padding(.leading,10)
                    Text("Create one!")
                        .foregroundStyle(.indigo)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .font(.system(size: 14))
            }
        }
    }
//}*/
