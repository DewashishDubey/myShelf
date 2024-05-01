//
//  ExtensionRequests.swift
//  myShelf
//
//  Created by Dewashish Dubey on 01/05/24.
//



import SwiftUI
import FirebaseFirestore
import Combine

struct ExtensionRequestData {
    var documentID: String
    var reservedBookID: String
    var uid: String
    var userID: String
}

class ExtensionRequestViewModel: ObservableObject {
    @Published var extensionRequests: [ExtensionRequestData] = []
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchData() {
        listenerRegistration = db.collection("extension_requests").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.extensionRequests = documents.compactMap { document in
                let data = document.data()
                guard let documentID = data["documentID"] as? String,
                      let reservedBookID = data["reservedBookID"] as? String,
                      let uid = data["uid"] as? String,
                      let userID = data["userID"] as? String else {
                    return nil
                }
                return ExtensionRequestData(documentID: documentID,
                                            reservedBookID: reservedBookID,
                                            uid: uid,
                                            userID: userID)
            }
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

