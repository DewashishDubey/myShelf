//
//  AFAQView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 07/05/24.
//


import SwiftUI
import FirebaseFirestoreSwift
import Firebase
struct AFAQView: View {
    @State private var showingSheet = false
    @ObservedObject var viewModel = FAQViewModel()
    var body: some View {
        ZStack
        {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                      VStack(spacing: 20) {
                          ForEach(viewModel.FAQs) { faq in
                              Questions(questions: faq.question, answers: faq.solution,id : faq.id ?? "")
                          }
                      }
                      .padding()
                  }
                  .onAppear {
                      viewModel.fetchData()
                  }
                  .padding()
        }
        .toolbar{
            Button("Add"){showingSheet.toggle()}
        }
        .sheet(isPresented: $showingSheet) {
            AddFAQView()
        }
    }
}

struct Questions: View{
    let questions: String
    let answers: String
    let id : String
    @State private var offsets = [CGSize](repeating: CGSize.zero, count: 6)
    var body: some View{
        HStack{
            
            DisclosureGroup
            {
                
                Text(answers)
                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                    .font(.custom("SF Pro Text", size: 14))
                    .padding(.bottom,10)
                Button("Delete FAQ"){deleteFAQ(id: id)}
                    .font(.custom("SF Pro Text", size: 14))
                    .padding(.bottom,10)
                    .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
               // Text(id)
            }
        label: {
            
            Text(questions)
                .foregroundColor(.white)
                .font(.custom("SF Pro Text", size: 16))
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(.white)
            
            
        }
        .padding(12)
        .frame(width: 353)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(8)
    }
    
    func deleteFAQ(id: String) {
        let db = Firestore.firestore()
        db.collection("FAQ").document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                // Optionally, you can also update your UI or perform any other actions after deletion
            }
        }
    }
    
}

struct AddFAQView: View {
    @Environment(\.dismiss) var dismiss
    @State private var questionText = ""
    @State private var solutionText = ""
    @State private var showAlert = false
       @State private var alertMessage = ""
    let db = Firestore.firestore()
    var body: some View {
        VStack(spacing: 40){
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 36, height: 5)
              .background(Color(red: 0.76, green: 0.76, blue: 0.76).opacity(0.5))
              .background(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.4))
              .cornerRadius(2.5)
              .padding(.top,15)
            
            HStack{
                Button("Cancel") {
                    dismiss()
                }
                    .font(Font.custom("SF Pro Text", size: 16))
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                Spacer()
                
                Text("Add FAQ")
                  .font(.custom("SF Pro Text", size: 16))
                  .padding(.trailing,15)
                Spacer()
                
                Button("Save") {
                    if !questionText.isEmpty && !solutionText.isEmpty {
                                           // Add the FAQ to Firestore
                                           addFAQToFirestore()
                                           // Dismiss the sheet
                        alertMessage = "FAQ Added Successfully"
                        showAlert = true
                                           
                    } else {
                        // Show alert for empty fields
                        alertMessage = "Both fields are required."
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")){dismiss()})
                       }
                .font(Font.custom("SF Pro Text", size: 16))
                .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
            }.padding(.horizontal)
            
            VStack(alignment: .center, spacing: 15) {
                TextField("Question", text: $questionText)
                    .font(.custom("SF Pro Text", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 329, height: 1)
                  .background(Color(red: 0.25, green: 0.25, blue: 0.25))

                TextField("Solution", text: $solutionText)
                    .font(Font.custom("SF Pro Text", size: 14))
                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            .padding(12)
            .frame(width: 353, alignment: .center)
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(8)
        }
        Spacer()
    }
    
    // Function to add FAQ to Firestore
    func addFAQToFirestore() {
        let newFAQ = FAQ(question: questionText, solution: solutionText)
        do {
            // Declare docRef outside of the closure
            var docRef: DocumentReference?
            
            // Add a new document with a generated ID
            docRef = try db.collection("FAQ").addDocument(from: newFAQ) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    showAlert = true
                    alertMessage = "FAQ Added Successfully"
                    // Get the ID of the newly created document
                    if let documentId = docRef?.documentID {
                        // Update the document with the ID
                        db.collection("FAQ").document(documentId).updateData(["id": documentId])
                    }
                }
            }
        } catch {
            print("Error adding document: \(error)")
        }
    }
}

struct FAQ: Codable {
    var question: String
    var solution: String
}

#Preview {
    AFAQView()
}
