//
//  MBookDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI
import Firebase
import AVFoundation
struct MBookDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    let bookUID: String
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var isBookmarked = false
    @State private var showAlert = false
    @State private var AlertMsg = ""
    @State private var isPremiumMember: Bool = false
    @State private var showingSheet = false
    @State private var isSpeaking = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    var body: some View {
            //Text(user.id)
            ScrollView(showsIndicators: false)
            {
                VStack(alignment: .leading)
                {
                    
                    //Text("Book UID: \(bookUID)")
                    //CurrentlyReadingView1()
                    if let book = firebaseManager.books.first(where: { $0.uid == bookUID })
                    {
                        VStack(alignment: .leading) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                //.frame(width: 360, height: 1500, alignment: //.topLeading)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                                    .cornerRadius(10)
                                    .padding(.bottom,10)
                                
                                VStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 36, height: 5)
                                        .background(Color(red: 0.76, green: 0.76, blue: 0.76).opacity(0.5))
                                        .cornerRadius(2.5)
                                        .padding(.top,10)
                                    
                                    HStack{
                                        Button(action: {
                                            if isSpeaking {
                                                speechSynthesizer.stopSpeaking(at: .immediate) // Stop speaking if already speaking
                                            } else {
                                                speakBookDetails(book: book)
                                            }
                                            isSpeaking.toggle() // Toggle isSpeaking state
                                        }) {
                                            Image(systemName: isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .frame(width: 20, height: 20)
                                        }
                                        Spacer()
                                        Button(action: {
                                            dismiss()
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .frame(width: 20, height: 20)
                                               // .padding(.leading, 320)
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 230, height: 355)
                                                .clipped()
                                                .cornerRadius(10)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 230, height: 355)
                                                .clipped()
                                                .cornerRadius(10)
                                        @unknown default:
                                            Text("Unknown")
                                        }
                                    }
                                    .frame(width: 230, height: 355)
                                    .clipped()
                                    .cornerRadius(10)
                                    
                                    /*Image("CrazyAsian")
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 230, height: 355)
                                     .clipped()
                                     .cornerRadius(10)*/
                                    
                                    //                        .position(x: 190, y: 35)
                                    //
                                    Text(book.title)
                                        .font(Font.custom("SF Pro", size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .frame(width: 313)
                                        .padding(.top,30)
                                    //                        .position(x: 190, y: -150) // Adjust position to make the text visible
                                    
                                    
                                    
                                    
                                    Text(book.authors.joined(separator: ", "))
                                        .font(
                                            Font.custom("SF Pro Text", size: 14)
                                                .weight(.semibold)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                        .padding(.top,15)
                                    
                                    //                      .position(x: 190, y: -100)
                                    
                                    Text(book.publicationDate)
                                        .font(Font.custom("SF Pro Text", size: 14))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    //                      .position(x: 190, y: -100)
                                        .padding(.top,15)
                                    
                                    HStack{
                                        
                                        StarsView(rating: ((Float(book.rating) ?? 1)/(Float(book.noOfRatings) ?? 1)), maxRating: 5)
                                            .padding(.top, 30)
                                        
                                        
                                        
                                        Button(action: {
                                                    toggleBookmark() // Toggle bookmark status
                                                }) {
                                                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                                        .foregroundColor(isBookmarked ? .blue : .gray)
                                                        .font(
                                                            Font.custom("SF Pro Text", size: 14)
                                                                .weight(.semibold)
                                                        )
                                                        .foregroundColor(.white)
                                                        .padding(.top,30)
                                                        .padding(.leading,240)
                                                }
                                                .padding(.top, 30)
                                        
                                        /*Image(systemName: "bookmark")
                                            .font(
                                                Font.custom("SF Pro Text", size: 14)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.white)
                                            .padding(.top,30)
                                            .padding(.leading,240)*/
                                        
                                        
                                    }
                                    VStack{
                                        HStack{
                                            Text("\(book.noOfRatings) Ratings")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .padding(.leading,10)
                                                .padding(.trailing,227)
                                            
                                            /*Text("Wishlist")
                                             .font(Font.custom("SF Pro Text", size: 10))
                                             .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                             .padding(.trailing,5)*/
                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.leading,25)
                                        .padding(.top,10)
                                        
                                    }
                                    
                                    Button(action: {
                                        if isPremiumMember {
                                               reserveBook()
                                            } else {
                                                showingSheet = true // Show premium membership sheet
                                            }
                                    }) {
                                        Text("Reserve Book")
                                            .font(
                                                Font.custom("SF Pro Text", size: 14)
                                                    .weight(.semibold)
                                            )
                                            .multilineTextAlignment(.center)
                                            .frame(width: 340, height: 50)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 30)
                                    .alert(isPresented: $showAlert) {
                                                Alert(title: Text("Alert"), message: Text("\(AlertMsg)"), dismissButton: .default(Text("OK")))
                                            }
                                    .sheet(isPresented: $showingSheet) {
                                                MSubscriptionView()
                                            .presentationBackground(.black)
                                            }
                                    
                                    
                                    
                                    
                                    VStack{
                                        HStack {
                                            Spacer()
                                            Text("GENRE")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            Spacer()
                                            Text("LANGUAGE")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .padding(.horizontal, 50)
                                            Spacer()
                                            Text("LENGTH")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 30)
                                        
                                        HStack {
                                            Spacer()
                                            Image(systemName: "theatermasks")
                                                .font(
                                                    Font.custom("SF Pro Text", size: 12)
                                                        .weight(.semibold)
                                                )
                                                .foregroundColor(.white)
                                                .offset(x: -7, y: 0)
                                            Spacer()
                                            Text("EN")
                                                .font(
                                                    Font.custom("SF Pro Text", size: 12)
                                                        .weight(.semibold)
                                                )
                                                .foregroundColor(.white)
                                                .padding(.horizontal,60)
                                                .offset(x: -7, y: 0)
                                            Spacer()
                                            Text(book.noOfPages)
                                                .font(
                                                    Font.custom("SF Pro Text", size: 12)
                                                        .weight(.semibold)
                                                )
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 10)
                                        
                                        HStack {
                                            Spacer()
                                            Text(book.genre)
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            Spacer()
                                            Text("English")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .padding(.horizontal,60)
                                            Spacer()
                                            Text("Pages")
                                                .font(Font.custom("SF Pro Text", size: 10))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 10)
                                        
                                        
                                        Text("Summary")
                                            .font(
                                                Font.custom("SF Pro Text", size: 14)
                                                    .weight(.semibold)
                                            )
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .padding(.leading,25)
                                            .padding(.top,30)
                                        
                                        Text(book.description)
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .padding(.top,20)
                                            .padding(.leading,25)
                                            .padding(.trailing,28)
                                        
                                        HStack{
                                            Image(systemName: "person.fill")
                                                .font(Font.custom("SF Pro Text", size: 18))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            
                                                .frame(width: 15, alignment: .top)
                                                .padding(.leading,25)
                                            
                                            
                                            Text("Published by: \(book.publisher)")
                                                .font(Font.custom("SF Pro Text", size: 12))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                            
                                            
                                        }
                                        .padding(.top,60)
                                        
                                        HStack{
                                            
                                            Image(systemName: "info.circle")
                                                .font(Font.custom("SF Pro Text", size: 18))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            
                                                .frame(width: 15, alignment: .top)
                                                .padding(.leading,25)
                                            
                                            HStack {
                                                Text("Status :")
                                                    .font(Font.custom("SF Pro Text", size: 12))
                                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                
                                                if(Int(book.noOfCopies) ?? 0 > 0){
                                                    Text("Available")
                                                        .font(Font.custom("SF Pro Text", size: 12))
                                                        .foregroundColor(Color.green)
                                                }
                                                else{
                                                    Text("Not Available")
                                                        .font(Font.custom("SF Pro Text", size: 12))
                                                        .foregroundColor(Color.red)
                                                }
                                                
                                            }//.padding(.trailing,245)
                                            
                                            
                                            
                                            
                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.top,20)
                                        
                                        HStack{
                                            Image(systemName: "location")
                                                .font(Font.custom("SF Pro Text", size: 18))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            
                                                .frame(width: 15, alignment: .top)
                                                .padding(.leading,25)
                                            
                                            
                                            Text("Book Location: \(book.shelfLocation)")
                                                .font(Font.custom("SF Pro Text", size: 12))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                            
                                            
                                        }.padding(.top,20)
                                        
                                    }
                                    .padding(.bottom,30)
                                    
                                    
                                }.padding(.bottom,5)
                            }
                        }
                    }
                }
                .onAppear {
                    firebaseManager.fetchBooks()
                    checkBookmarkStatus()
                    fetchMemberData()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
    }
    
    func speakBookDetails(book: Book) {
            let utterance = AVSpeechUtterance(string: "\(book.title), by \(book.authors.joined(separator: ", ")). \(book.description)") // Customize the book details as needed
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Specify the language
            speechSynthesizer.speak(utterance)
        }
    
    func fetchMemberData() {
        if let userId = viewModel.currentUser?.id {
            let membersRef = Firestore.firestore().collection("members").document(userId)
            membersRef.addSnapshotListener { document, error in
                if let document = document, document.exists {
                    if let isPremium = document.data()?["is_premium"] as? Bool {
                        self.isPremiumMember = isPremium
                    }
                } else {
                    print("Member document does not exist or could not be retrieved: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func toggleBookmark() {
            if isBookmarked {
                removeFromWishlist()
            } else {
                addToWishlist()
            }
            // Toggle the bookmark status
            isBookmarked.toggle()
        }
        
        func addToWishlist() {
            guard let userUID = viewModel.currentUser?.id else {
                return
            }
            myShelf.addToWishlist(bookUID: bookUID, forUserUID: userUID)
        }
        
        func removeFromWishlist() {
            guard let userUID = viewModel.currentUser?.id else {
                return
            }
            myShelf.removeFromWishlist(bookUID: bookUID, forUserUID: userUID)
        }
    func checkBookmarkStatus() {
            guard let userUID = viewModel.currentUser?.id else {
                return
            }
            
            isBookInWishlist(bookUID: bookUID, forUserUID: userUID) { isInWishlist in
                // Update the bookmark status based on whether the book is in the wishlist
                self.isBookmarked = isInWishlist
            }
        }
    
    func reserveBook() {
            guard let userUID = viewModel.currentUser?.id else {
                return
            }
            
            let db = Firestore.firestore()
            let userRef = db.collection("members").document(userUID)
            let reservationsRef = userRef.collection("reservations")
            let globalReservationsRef = db.collection("reservations")
        
            reservationsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking reservations: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Show alert if reservations exist
                    showAlert = true
                    AlertMsg = "You cannot issue more than one book."
                } else {
                    // Proceed with reservation
                    let currentTime = Date()
                    let twoHoursLater = Calendar.current.date(byAdding: .hour, value: 2, to: currentTime)!
                    
                    var reservationData: [String: Any] = [
                        "bookUID": bookUID,
                        "userID": userUID,
                        "timestamp": Timestamp(date: twoHoursLater)
                    ]
                    
                    let reservationDocRef = reservationsRef.document()
                    reservationData["reservationID"] = reservationDocRef.documentID
                    
                    reservationDocRef.setData(reservationData) { error in
                        if let error = error {
                            print("Error reserving book: \(error.localizedDescription)")
                        } else {
                            showAlert = true
                            AlertMsg = "Book reserved successfully!"
                            print("Book reserved successfully!")
                        }
                    }
                    
                    // Add reservation data to the global reservations collection
                                globalReservationsRef.addDocument(data: reservationData) { error in
                                    if let error = error {
                                        print("Error adding reservation to global collection: \(error.localizedDescription)")
                                    } else {
                                        print("Reservation added to global collection successfully!")
                                    }
                                }
                }
            }
        }

}



struct MBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MBookDetailView(bookUID: "")
            .preferredColorScheme(.dark)
    }
}


