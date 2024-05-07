//
//  LBookDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI
import Firebase
import AVFoundation
struct LBookDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    let bookUID: String
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var isBookmarked = false
    @State private var isSpeaking = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    var body: some View {
        NavigationStack{
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
                                        NavigationLink{
                                            EditBookView(bookUID: bookUID)
                                        }label: {
                                            Text("Edit")
                                                .font(Font.custom("SF Pro Text", size: 16))
                                                .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                                                .padding(.leading,5)
                                        }
                                        
                                        Spacer()
                                        Button(action: {
                                            dismiss()
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .frame(width: 20, height: 20)
                                            //.padding(.leading, 320)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .padding(.bottom,10)
                                    
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
                                        
                                        HStack{
                                            Text("Summary")
                                                .font(
                                                    Font.custom("SF Pro Text", size: 14)
                                                        .weight(.semibold)
                                                )
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                //.padding(.leading,25)
                                               
                                            
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
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top,30)
                                        .padding(.horizontal,25)
                                        
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
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        
    }
    
    func speakBookDetails(book: Book) {
            let utterance = AVSpeechUtterance(string: "\(book.title), by \(book.authors.joined(separator: ", ")). \(book.description)") // Customize the book details as needed
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Specify the language
            speechSynthesizer.speak(utterance)
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
}



struct LBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LBookDetailView(bookUID: "")
            .preferredColorScheme(.dark)
    }
}
