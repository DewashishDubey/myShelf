//
//  MPreviouslyIssuedBooksView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//


import SwiftUI
import Firebase
struct MPreviouslyIssuedBooksView: View {
    var docID : String
    @ObservedObject var bookViewModel = PreviouslyReservedBooksViewModel()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var existingRequest = false
    @State private var alreadyRequested = false
    @State private var isPremium: Bool = false
    @State private var rating: Int = 0
    @State private var showAlert = false
    @State private var AlertMsg = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView{
               // Text(viewModel.currentUser?.id ?? "")
                VStack(spacing:20){
                    ForEach(bookViewModel.reservedBooks) { reservedBook in
                       // Text(reservedBook.documentID)
                        Text(reservedBook.book.title)
                            .font(
                            Font.custom("SF Pro Text", size: 20)
                            .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        AsyncImage(url: URL(string: reservedBook.book.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 210)
                                    .padding(5)
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                        .frame(width: 240, height: 210)
                        .padding(5)
                        .padding(.bottom,20)
                        HStack{
                            Text("Borrowed On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.startDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Return due On")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(trimTime(from: reservedBook.endDateString))")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        HStack{
                            Text("Fine Amount")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(reservedBook.fine)")
                                .font(
                                Font.custom("SF Pro", size: 14)
                                .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.horizontal)
                        
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 353, height: 1)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        
                        
                        //Text(reservedBook.hasRated ? "yes"  :"no" )
                        
                        if(reservedBook.hasRated == false)
                        {
                            Text("Tell Us What You Think")
                                .font(
                                Font.custom("SF Pro", size: 18)
                                .weight(.medium)
                                )
                                .foregroundColor(.white)
                            HStack {
                                ForEach(1..<6) { index in
                                    Image(systemName: index <= rating ? "star.fill" : "star")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            rating = index
                                            print(rating)
                                            // Here you can store the rating in a variable or perform any other action
                                        }
                                }
                            }
                            
                            Button{
                                updateHasRated(for: reservedBook.book.uid)
                            }label: {
                                Text("Submit")
                                    .font(
                                    Font.custom("SF Pro", size: 16)
                                    .weight(.medium)
                                    )
                                    .foregroundColor(Color.green)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Alert"), message: Text("\(AlertMsg)"), dismissButton: .default(Text("OK")){presentationMode.wrappedValue.dismiss()})
                            }
                        }
                        
                        //.padding()
                        
                    }
                }
            }
        }
        .onAppear{
            bookViewModel.fetchPreviouslyReservedBook(for: viewModel.currentUser?.id ?? "ILZTUpzz84e5F5b7Xoof3pUX8Hf1", documentID: docID)
        }
        
        
    }
    private func trimTime(from dateString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
           
           if let date = dateFormatter.date(from: dateString) {
               dateFormatter.dateFormat = "MMM d, yyyy"
               return dateFormatter.string(from: date)
           } else {
               return dateString // Return original string if unable to parse
           }
       }
    
    private func updateHasRated(for bookID: String) {
          let db = Firestore.firestore()
          let userID = viewModel.currentUser?.id ?? "" // Get the current user's ID

          // Query to find the document where bookID matches in previously_issued_books subcollection
          let query = db.collection("members").document(userID)
              .collection("previously_issued_books").whereField("bookID", isEqualTo: bookID)

          // Execute the query
          query.getDocuments { snapshot, error in
              if let error = error {
                  print("Error getting documents: \(error.localizedDescription)")
                  return
              }

              guard let documents = snapshot?.documents else {
                  print("No documents found")
                  return
              }

              // Assuming there's only one document with matching bookID
              if let document = documents.first {
                  // Update the hasRated attribute in the document
                  document.reference.updateData(["hasRated": true]) { error in
                      if let error = error {
                          print("Error updating hasRated attribute: \(error.localizedDescription)")
                      } else {
                          print("hasRated attribute updated successfully")
                          // Optionally, you can perform any additional actions here after successful update
                      }
                  }

                  // Get the rating from the state
                  let ratingValue = Double(rating)

                  // Retrieve the corresponding document from the "books" collection
                  let bookRef = db.collection("books").document(bookID)

                  // Update the rating attribute and increment the noOfRatings attribute
                  db.runTransaction({ (transaction, errorPointer) -> Any? in
                      do {
                          let bookDocument = try transaction.getDocument(bookRef)

                          // Extract the current rating and noOfRatings values
                          guard var currentRatingString = bookDocument.data()?["rating"] as? String,
                                var currentNoOfRatingsString = bookDocument.data()?["noOfRatings"] as? String,
                                let currentRating = Double(currentRatingString),
                                let currentNoOfRatings = Int(currentNoOfRatingsString) else {
                              return nil
                          }

                          // Increment the rating and noOfRatings values
                          let newRating = currentRating + ratingValue
                          let newNoOfRatings = currentNoOfRatings + 1

                          // Update the document with the new values
                          transaction.updateData(["rating": String(newRating), "noOfRatings": String(newNoOfRatings)], forDocument: bookRef)

                          return nil
                      } catch let fetchError as NSError {
                          errorPointer?.pointee = fetchError
                          return nil
                      }
                  }) { (object, error) in
                      if let error = error {
                          print("Transaction failed: \(error.localizedDescription)")
                      } else {
                          AlertMsg = "Rating updated,Thank you!"
                          showAlert = true
                          print("Transaction successfully committed!")
                      }
                  }
              } else {
                  print("No document found with matching bookID")
              }
          }
      }
    
}

#Preview {
    MPreviouslyIssuedBooksView(docID: "")
}

