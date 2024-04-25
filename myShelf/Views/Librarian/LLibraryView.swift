//
//  LLibraryView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//


import SwiftUI
import Firebase

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

struct LLibraryView: View {
    @State private var isbnInput: String = ""
    @State private var book: BookDetails?
    @State private var imageData: Data? // New state variable to store image data
    @State private var shelfLocation = ""
    @State private var noOfPages = ""
    @State private var noOfCopies = ""
    @State private var rating = ""
    private let db = Firestore.firestore()
    
    var body: some View {
        ScrollView{
            VStack {
                TextField("Enter ISBN", text: $isbnInput, onCommit: fetchBookDetails)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let book = book {
                    TextField("Title", text: .constant(book.title))
                        .padding()
                    TextField("Authors", text: .constant(book.authors.joined(separator: ", ")))
                        .padding()
                    TextField("Edition", text: .constant(book.edition))
                        .padding()
                    TextField("Publication Date", text: .constant(book.publicationDate))
                        .padding()
                    TextField("Genre", text: .constant(book.genre))
                        .padding()
                    TextField("Publisher", text: .constant(book.publisher))
                        .padding()
                    TextField("Description", text: .constant(book.description))
                        .padding()
                    TextField("Rating", text:$rating)
                        .padding()
                    TextField("Number of Copies", text: $noOfCopies)
                        .padding()
                    TextField("Number of Pages", text: $noOfPages)
                        .padding()
                    TextField("Language", text: .constant(book.language ?? "Unknown"))
                        .padding()
                    TextField("Shelf Location", text: $shelfLocation)
                        .padding()
                    
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 150)
                    } else {
                        ProgressView() // Show a loading indicator while image is being fetched
                    }
                    
                    Button("Submit", action: {saveBookDetails()})
                                        .padding()
                }
                
                Spacer()
            }
        }
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
                "shelfLocation": shelfLocation
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
                    let title = volumeInfo["title"] as? String ?? "Unknown Title"
                    let authors = volumeInfo["authors"] as? [String] ?? []
                    let edition = volumeInfo["edition"] as? String ?? "Unknown Edition"
                    let publicationDate = volumeInfo["publishedDate"] as? String ?? "Unknown"
                    let genres = volumeInfo["categories"] as? [String] ?? []
                    let genre = genres.joined(separator: ", ")
                    let publisher = volumeInfo["publisher"] as? String ?? "Unknown Publisher"
                    let description = volumeInfo["description"] as? String ?? "No description available"
                    let rating = volumeInfo["averageRating"] as? String
                    let noOfCopies = volumeInfo["copiesInLibrary"] as? String
                    let noOfPages = volumeInfo["pageCount"] as? String
                    let language = volumeInfo["language"] as? String
                    let shelfLocation = volumeInfo["shelfLocation"] as? String
                    
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

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        LLibraryView()
    }
}

