//
//  AuthViewModel.swift
//  MultiUserTypeLoginTest
//
//  Created by Dewashish Dubey on 20/04/24.
//

/*
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
    }*/
    
    func signIn(withEmail email: String, password: String) async throws {
        guard userSession == nil else {
                print("Another user is already signed in. Please sign out first.")
                return
            }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    /*
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
    }*/
    
    func createUser(withEmail email: String, password: String, fullname: String, userType: UserType, gender: Gender? = nil) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Create user document in Firestore under "users" collection
            let newUser = User(id: result.user.uid, fullname: fullname, email: email, userType: userType)
            let usersRef = Firestore.firestore().collection("users").document(newUser.id)
            try usersRef.setData(from: newUser)
            
            // If userType is member, add to "members" collection with additional attributes
            if userType == .member {
                let membersRef = Firestore.firestore().collection("members").document(newUser.id)
                let memberData: [String: Any] = [
                    "id": newUser.id,
                    "name": newUser.fullname,
                    "no_of_issued_books": 0,
                    "is_premium": false,
                    "subscription_start_date": FieldValue.serverTimestamp(),
                    "lastReadGenre" : "Fiction"
                ]
                try await membersRef.setData(memberData)
                
                /*
                // Create subcollections for the member user
                let issuedBooksRef = membersRef.collection("issued_books")
                try await issuedBooksRef.addDocument(data: [:])
                
                let previouslyIssuedBooksRef = membersRef.collection("previously_issued_books")
                try await previouslyIssuedBooksRef.addDocument(data: [:])
                
                let reservedBooksRef = membersRef.collection("reserved_books")
                try await reservedBooksRef.addDocument(data: [:])*/
                await fetchUser() // Update currentUser after user creation
            }
            
            if userType == .librarian{
                // Add librarian-specific data
                            let librarianRef = Firestore.firestore().collection("librarians").document(newUser.id)
                            let librarianData: [String: Any] = [
                                "uid": newUser.id,
                                "name": newUser.fullname,
                                "gender": gender == .male ? "male" : "female",
                                "email": newUser.email
                            ]
                            try await librarianRef.setData(librarianData)
            }
            
            
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
        if let uid = Auth.auth().currentUser?.uid {
            do {
                let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
                if snapshot.exists {
                    self.currentUser = try snapshot.data(as: User.self)
                } else {
                    print("User document does not exist")
                }
            } catch {
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        } else {
            print("User is not authenticated")
        }
    }
    
    /*
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }*/
}
*/


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

    func signIn(withEmail email: String, password: String) async throws {
        guard userSession == nil else {
            print("Another user is already signed in. Please sign out first.")
            return
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }

    func createUser(withEmail email: String, password: String, fullname: String, userType: UserType, gender: Gender? = nil) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Create user document in Firestore under "users" collection
            let newUser = User(id: result.user.uid, fullname: fullname, email: email, userType: userType)
            let usersRef = Firestore.firestore().collection("users").document(newUser.id)
            try usersRef.setData(from: newUser)
            
            // If userType is member, add to "members" collection with additional attributes
            if userType == .member {
                let membersRef = Firestore.firestore().collection("members").document(newUser.id)
                let memberData: [String: Any] = [
                    "id": newUser.id,
                    "name": newUser.fullname,
                    "no_of_issued_books": 0,
                    "is_premium": false,
                    "subscription_start_date": FieldValue.serverTimestamp(),
                    "lastReadGenre" : "Fiction",
                    "membership_duration" : 0,
                    "books_read" : 0,
                    "due" : 0,
                    "gender" : gender == .male ? "male" : "female",
                    "goal" : 5
                ]
                try await membersRef.setData(memberData)
                
                
                await fetchUser() // Update currentUser after user creation
                
            }
            
            if userType == .librarian{
                // Add librarian-specific data
                let librarianRef = Firestore.firestore().collection("librarians").document(newUser.id)
                let librarianData: [String: Any] = [
                    "uid": newUser.id,
                    "name": newUser.fullname,
                    "gender": gender == .male ? "male" : "female",
                    "email": newUser.email,
                    "isActive": true
                ]
                try await librarianRef.setData(librarianData)
            }
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

    func fetchUser() async {
        if let uid = Auth.auth().currentUser?.uid {
            do {
                let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
                if snapshot.exists {
                    self.currentUser = try snapshot.data(as: User.self)
                } else {
                    print("User document does not exist")
                }
            } catch {
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        } else {
            print("User is not authenticated")
        }
    }
}

