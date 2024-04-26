//
//  LibrarianDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI
import Firebase

struct LibrarianDetailView: View {
    let libID: String
    @State private var librarian: Librarian?
    @State private var libName = ""
    @State private var showAlert = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                //Text(librarian?.uid)
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.bottom,20)
                    VStack(alignment: .leading) {
                        HStack{
                            Image(systemName: "person")
                            Text("Name")
                                .font(Font.custom("SF Pro", size: 14))
                                .foregroundColor(.white)
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 1, height: 20)
                            .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                            
                            TextField("", text: $libName)
                                .placeholder1(when: libName.isEmpty) {
                                    Text(librarianName).foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(width: 353, height: 50, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    
                    
                    Button(action: {
                        updateName()
                    }) {
                        Text("Save Account Changes")
                            .font(Font.custom("SF Pro Text", size: 14))
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                            .padding(.top, 20)
                    }
                    .alert(isPresented: $showAlert) {
                                           Alert(title: Text("Success"), message: Text("Data updated successfully"), dismissButton: .default(Text("OK")))
                                       }
                    
                    Button(action: {
                        
                    }) {
                        Text("Delete Account")
                            .padding(.top,20)
                        .font(Font.custom("SF Pro Text", size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                    }
                    .alert(isPresented: $showAlert) {
                                           Alert(title: Text("Success"), message: Text("Librarian removed successfully"), dismissButton: .default(Text("OK")))
                                       }
                    
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            fetchLibrarian()
        }
    }
    
    private var librarianName: String {
        librarian?.name ?? "Loading..."
    }

    private func fetchLibrarian() {
        let db = Firestore.firestore()
        db.collection("librarians").document(libID).getDocument { document, error in
            if let error = error {
                print("Error getting librarian document: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Librarian document not found")
                return
            }
            
            let data = document.data()
            guard let name = data?["name"] as? String,
                  let gender = data?["gender"] as? String,
                  let email = data?["email"] as? String
            else {
                print("Failed to extract librarian data from document")
                return
            }
            
            self.librarian = Librarian(name: name, gender: gender, email: email,uid: document.documentID)
        }
    }
    
    private func updateName() {
        guard let librarian = librarian else {
            print("Librarian data not available")
            return
        }
        
        let db = Firestore.firestore()
        
        // Update name in librarian collection
        db.collection("librarians").document(librarian.uid).updateData(["name": libName]) { error in
            if let error = error {
                print("Error updating name in librarian collection: \(error)")
                return
            } else {
                print("Name updated successfully in librarian collection")
            }
        }
        
        // Update name in users collection
        db.collection("users").document(librarian.uid).updateData(["name": libName]) { error in
            if let error = error {
                print("Error updating name in users collection: \(error)")
                return
            } else {
                print("Name updated successfully in users collection")
                showAlert = true
            }
        }
    }
    

}

struct LibrarianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianDetailView(libID: "your_libID_here")
    }
}


#Preview {
    LibrarianDetailView(libID: "")
}

extension View {
    func placeholder1<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
