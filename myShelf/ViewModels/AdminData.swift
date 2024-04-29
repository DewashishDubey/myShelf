//
//  AdminData.swift
//  myShelf
//
//  Created by Dewashish Dubey on 29/04/24.
//

import SwiftUI
import Firebase
import Combine

struct AdminData1 {
    var books: Int
    var librarians: Int
    var members: Int
    var revenue: Int
}

class AdminViewModel: ObservableObject {
    @Published var adminData: AdminData1?
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchData() {
        let adminDocRef = db.collection("admin").document("adminDocument")
        
        adminDocRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let books = data?["books"] as? Int ?? 0
                let librarians = data?["librarians"] as? Int ?? 0
                let members = data?["members"] as? Int ?? 0
                let revenue = data?["revenue"] as? Int ?? 0
                
                self.adminData = AdminData1(books: books, librarians: librarians, members: members, revenue: revenue)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
