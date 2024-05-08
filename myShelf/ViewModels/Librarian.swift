//
//  Librarian.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//



import Foundation
import Firebase

struct Librarian {
    var name: String
    var gender: String
    var email: String
    var uid: String
    var isActive: Bool
    // Add uid property
}


class LibrarianManager: ObservableObject {
    @Published var librarians: [Librarian] = []
    
    private var db = Firestore.firestore()
    
    func fetchLibrarians() {
        db.collection("librarians").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = snapshot?.documents {
                    self.librarians = documents.compactMap { document in
                        let data = document.data()
                        guard let name = data["name"] as? String,
                              let gender = data["gender"] as? String,
                              let email = data["email"] as? String,
                              let uid = data["uid"] as? String,
                              let isActive = data["isActive"] as? Bool
                        else {
                            return nil
                        }
                        
                        return Librarian(name: name,
                                         gender: gender,
                                         email: email,
                                         uid: uid,
                                         isActive: isActive 
                        )
                    }
                }
            }
        }
    }
}

