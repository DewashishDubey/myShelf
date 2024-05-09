//
//  AddBookView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//


import SwiftUI
import Firebase

extension Color {
    static let customBackground = Color(red: 28/255, green: 28/255, blue: 30/255)
    }
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
            .background(Color.customBackground)
            .cornerRadius(10)
            .foregroundColor(.white)
        
        
    }
}

struct BookDetails: Codable {
    let title: String
    let authors: [String]
    let edition: String
    let publicationDate: String
    let genre: String
    let publisher: String
    let description: String
    let imageUrl: String?
    let language: String?
}

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isbnInput: String = ""
    @State private var book: BookDetails?
    @State private var imageData: Data? // New state variable to store image data
    @State private var shelfLocation = ""
    @State private var noOfPages = ""
    @State private var noOfCopies = ""
    @State private var rating = ""
    private let db = Firestore.firestore()
    
    var body: some View {
        ScrollView
        {
            
            VStack
            {
                HStack{
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                            .frame(width: 20, height: 20)
                            .padding(.leading, 320)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.bottom,15)
                
                TextField("Enter ISBN", text: $isbnInput, onCommit: fetchBookDetails)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                    //.padding(.leading,10)
                    .foregroundColor(Color.white)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom,10)
                    .accentColor(.white)
                    .textFieldStyle(CustomTextFieldStyle())
                    .foregroundColor(.white) // Set text color to white
                
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 210)
                            .padding(.bottom,10)
                    }
                
                CustomTextFieldRow(imageName: "book", title: "Title", textFieldData: book?.title)
                CustomTextFieldRow(imageName: "person", title: "Author", textFieldData: book?.authors[0])
                CustomTextFieldRow(imageName: "book.and.wrench", title: "Edition", textFieldData: book?.edition)
                CustomTextFieldRow(imageName: "calendar", title: "Release Date", textFieldData: book?.publicationDate)
                CustomTextFieldRow(imageName: "theatermasks", title: "Genre", textFieldData: book?.genre)
                CustomTextFieldRow(imageName: "person", title: "Publisher", textFieldData: book?.publisher)
                CustomTextFieldRow(imageName: "globe", title: "Language", textFieldData: book?.language)
                
                
                HStack{
                    HStack{
                        Image(systemName: "info.circle")
                        Text("Availability")
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 3, height: 20)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        .padding(.leading,10)
                       
                            TextField("", text: $noOfCopies)
                                .foregroundColor(.white)
                        
                    }
                    .padding([.top,.bottom])
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                //.padding(.leading,10)
                .foregroundColor(Color.white)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
                .padding(.bottom,10)
                
                HStack{
                    HStack{
                        Image(systemName: "book.pages")
                        Text("Length")
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 3, height: 20)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        .padding(.leading,10)
                        
                            TextField("", text: $noOfPages)
                                .foregroundColor(.white)
                        
                    }
                    .padding([.top,.bottom])
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                //.padding(.leading,10)
                .foregroundColor(Color.white)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
                .padding(.bottom,10)
                
                HStack{
                    HStack{
                        Image(systemName: "star")
                        Text("Rating")
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 3, height: 20)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        .padding(.leading,10)
                            TextField("", text: $rating)
                                .foregroundColor(.white)
                    }
                    .padding([.top,.bottom])
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                //.padding(.leading,10)
                .foregroundColor(Color.white)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
                .padding(.bottom,10)
                
                HStack{
                    HStack{
                        Image(systemName: "location")
                        Text("Shelf Location")
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 3, height: 20)
                        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                        .padding(.leading,10)
                            TextField("", text: $shelfLocation)
                                .foregroundColor(.white)
                    }
                    .padding([.top,.bottom])
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                //.padding(.leading,10)
                .foregroundColor(Color.white)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
                .padding(.bottom,10)
                
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "text.book.closed")
                            Text("Book Summary")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        
                        if let book = book {
                            let minHeight: CGFloat = 100 // Set a minimum height for the TextField
                            
                            Text(book.description)
                                .foregroundColor(.white)
                                .lineLimit(7) // Allow multiple lines
                                .frame(maxWidth: .infinity) // Expand horizontally
                                .frame(minHeight: minHeight) // Set minimum height
                                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
                        }
                    }
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(8)
                .padding(.bottom, 20)
                
                    Button(action: {
                        saveBookDetails()
                        let db = Firestore.firestore()
                        let adminRef = db.collection("admin").document("adminDocument")
                        // Pass the UserType enum to createUser function
                        adminRef.getDocument { document, error in
                               if let document = document, document.exists {
                                   var books = document.data()?["books"] as? Int ?? 0
                                   books += Int(noOfCopies) ?? 0
                                   
                                   // Update document with new value of "librarians" attribute
                                   adminRef.setData([
                                                     "books": books], merge: true) { error in
                                       if let error = error {
                                           print("Error updating document: \(error.localizedDescription)")
                                       }
                                   }
                               } else if let error = error {
                                   print("Error fetching document: \(error.localizedDescription)")
                               } else {
                                   // Document doesn't exist, create it with librarians count 1
                                   adminRef.setData([
                                    "books": Int(noOfCopies) ?? 0]) { error in
                                       if let error = error {
                                           print("Error creating document: \(error.localizedDescription)")
                                       }
                                   }
                               }
                           }
                        dismiss()
                    }) {
                        HStack {
                            Text("Submit")
                                .padding(.horizontal, 25)
                                .padding(.vertical, 18)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color.indigo)

                                .cornerRadius(8)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                
               
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,5)
        }
        .background(Color.black.ignoresSafeArea(.all))
    }
    
    func saveBookDetails() {
        guard let book = book else {
            return
        }

        do {
            // Convert book details to dictionary
            var bookData: [String: Any] = [
                "title": book.title,
                "authors": book.authors,
                "edition": book.edition,
                "publicationDate": book.publicationDate,
                "genre": book.genre,
                "publisher": book.publisher,
                "description": book.description,
                "imageUrl": book.imageUrl ?? "", // Use imageUrl if available
                "rating": rating,
                "noOfCopies": noOfCopies,
                "noOfPages": noOfPages,
                "language": book.language ?? "",
                "shelfLocation": shelfLocation,
                "noOfRatings" : "1",
                "issued" : 0,
                "isActive" : true
            ]

            // Add book data to Firestore collection "books"
            let documentRef =  db.collection("books").addDocument(data: bookData)
            
            // Update the book data with the document ID
            bookData["uid"] = documentRef.documentID
            
            // Update the document in Firestore with the UID included
            documentRef.setData(bookData)

            // Optionally, you can reset the form after saving
            isbnInput = ""
            self.book = nil
            self.imageData = nil

        }
    }

    
    func fetchBookDetails() {
        let apiUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbnInput)&key=AIzaSyAkvAlA2jFYGNvyoC_JlErQhpy4L6PVmXY"
        
        guard let url = URL(string: apiUrl) else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error fetching book details: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let items = json?["items"] as? [[String: Any]], let volumeInfo = items.first?["volumeInfo"] as? [String: Any] {
                    let title = volumeInfo["title"] as? String ?? "NA"
                    let authors = volumeInfo["authors"] as? [String] ?? []
                    let edition = volumeInfo["edition"] as? String ?? "NA"
                    let publicationDate = volumeInfo["publishedDate"] as? String ?? "NA"
                    let genres = volumeInfo["categories"] as? [String] ?? []
                    let genre = genres.joined(separator: ", ")
                    let publisher = volumeInfo["publisher"] as? String ?? "NA"
                    let description = volumeInfo["description"] as? String ?? "NA"
                    _ = volumeInfo["averageRating"] as? String
                    _ = volumeInfo["copiesInLibrary"] as? String
                    _ = volumeInfo["pageCount"] as? String
                    let language = volumeInfo["language"] as? String
                    _ = volumeInfo["shelfLocation"] as? String
                    
                    var imageUrl: String?
                    if let imageLinks = volumeInfo["imageLinks"] as? [String: Any], let thumbnail = imageLinks["thumbnail"] as? String {
                        imageUrl = thumbnail
                    }
                    
                    let book = BookDetails(title: title, authors: authors, edition: edition, publicationDate: publicationDate, genre: genre, publisher: publisher, description: description, imageUrl: imageUrl,language: language)
                    
                    DispatchQueue.main.async {
                        self.book = book
                    }
                    
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        fetchImage(from: url)
                    }
                } else {
                    print("Book details not found for ISBN: \(isbnInput)")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data else {
                print("No image data received")
                return
            }
            
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
}

struct CustomTextFieldRow: View {
    let imageName: String
    let title: String
    let textFieldData: String?

    var body: some View {
        HStack {
            HStack {
                Image(systemName: imageName)
                Text(title)
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 3, height: 20)
                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                .padding(.leading,10)
                if let textFieldData = textFieldData {
                    TextField("", text: .constant(textFieldData))
                        .foregroundColor(.white)
                }
            }
            .padding([.top,.bottom])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .foregroundColor(Color.white)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(8)
        .padding(.bottom,10)
    }
}

#Preview {
    AddBookView()
}
