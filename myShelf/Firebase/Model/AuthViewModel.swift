//
//  AuthViewModel.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//


import Foundation
import Firebase
import FirebaseFirestore

enum UserType: String, Codable {
    case member = "Member"
    case librarian = "Librarian"
    case admin = "Admin"
}

struct User: Identifiable, Codable {
    var id: String
    var fullname: String
    var email: String
    var userType: UserType
}

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        self.userSession = Auth.auth().currentUser

        Task {
            await fetchUser()
        }
    }

    /*
    func signIn(withEmail email: String, password: String, userType: UserType) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
            // Check if the fetched user's userType matches the desired userType
            if let currentUser = self.currentUser, currentUser.userType != userType {
                throw NSError(domain: "AuthViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not of the desired type."])
            }
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
     */
    func signIn(withEmail email: String, password: String, userType: UserType) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
            // Check if the fetched user's userType matches the desired userType
            if let currentUser = self.currentUser, currentUser.userType == userType {
                // If both email, password, and userType match, login is successful
                print("Login successful")
            } else {
                // If userType doesn't match, sign out the user and throw an error
                try await Auth.auth().signOut()
                self.userSession = nil
                throw NSError(domain: "AuthViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not of the desired type."])
            }
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func createUser(withEmail email: String, password: String, fullname: String, userType: UserType) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, userType: userType)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out error : \(error.localizedDescription)")
        }
    }

    func deleteAccount() {}

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}


