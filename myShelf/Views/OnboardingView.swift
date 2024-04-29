//
//  onboarding.swift
//  myShelf
//yes
//  Created by useerr2 on 22/04/24.
//
import SwiftUI

struct OnboardingView: View {
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                if isVisible {
                    onboarding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    isVisible = true
                }
            }
        }
    }
}

struct onboarding: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "books.vertical.fill")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .font(.system(size: 40))
                        .padding(.bottom, 10)
                    
                    Text("Welcome to MyShelf")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 60)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .imageScale(.large)
                                .foregroundColor(.indigo)
                                .font(.system(size: 25))
                            Text("Your gateway to the world of books and information.")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium))
                        }
                        .padding(.bottom, 15)
                        
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .imageScale(.large)
                                .foregroundColor(.indigo)
                                .font(.system(size: 25))
                            Text("Explore, Borrow and Return books from libraries")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium))
                        }
                        .padding(.bottom, 15)
                        
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .imageScale(.large)
                                .foregroundColor(.indigo)
                                .font(.system(size: 25))
                            Text("Seamlessly manage your library experience. ")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                    .padding(.bottom, 120)
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Get Started ->")
                            .foregroundStyle(Color(uiColor: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color(uiColor: .systemIndigo).opacity(0.9))
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                    }
                }
                .padding()
            }
        }
    }
}



struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
