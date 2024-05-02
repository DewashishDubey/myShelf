//
//  MEventsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//

import SwiftUI
import Firebase

struct MEventsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var lastReadGenre: String = "Loading..." // Default value until data is fetched
    
    var body: some View {
        VStack{
            
        }
        //ReservationDetailView()
        /*VStack {
            if let user = viewModel.currentUser {
                Text("User ID: \(user.id)")
                Text("Last Read Genre: \(lastReadGenre)")
            } else {
                Text("User not found")
            }
        }
        .onAppear {
            fetchLastReadGenre()
        }*/
    }
    
    func fetchLastReadGenre() {
        guard let userID = viewModel.currentUser?.id else {
            print("User ID not available")
            return
        }
        
        let db = Firestore.firestore()
        let memberRef = db.collection("members").document(userID)
        
        memberRef.addSnapshotListener { document, error in
            if let document = document, document.exists {
                if let lastReadGenre = document.data()?["lastReadGenre"] as? String {
                    self.lastReadGenre = lastReadGenre
                } else {
                    self.lastReadGenre = "Not available"
                }
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                self.lastReadGenre = "Error fetching data"
            }
        }
    }
}

struct MEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MEventsView().environmentObject(AuthViewModel())
    }
}
