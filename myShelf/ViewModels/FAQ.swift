//
//  FAQ.swift
//  myShelf
//
//  Created by Dewashish Dubey on 07/05/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FAQ1: Identifiable, Codable {
    @DocumentID var id: String?
    var question: String
    var solution: String
}

class FAQViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var FAQs: [FAQ1] = []

    init() {
        fetchData()
    }

    func fetchData() {
        db.collection("FAQ").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }

            self.FAQs = documents.compactMap { document in
                do {
                    let faq = try document.data(as: FAQ1.self)
                    return faq
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
        }
    }
}
