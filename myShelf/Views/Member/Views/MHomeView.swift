//
//  MHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookUID: Identifiable {
    let id: String
}

struct MHomeView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderView()
                
                CurrentlyReadingView()
                    .padding(.vertical)
                
                PopularBooksView()
                    .padding(.vertical)
                
               // AuthorSectionView()
                
                NewReleasesView()
                    .padding(.vertical)
                    
            }
            .onAppear{
                if let currentUserUID = Auth.auth().currentUser?.uid {
                                        checkAndUpdateFines(for: currentUserUID)
                                    }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    func checkAndUpdateFines(for userID: String) {
        let db = Firestore.firestore()
        let issuedBooksRef = db.collection("members").document(userID).collection("issued_books")
        
        issuedBooksRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            let currentDate = Date()
            
            for document in documents {
                let data = document.data()
                guard let timestamp = data["end_date"] as? Timestamp else {
                    continue
                }
                
                let endDate = timestamp.dateValue() // Convert Timestamp to Date
                
                if currentDate > endDate {
                    // Calculate the difference in days
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.day], from: endDate, to: currentDate)
                    guard let daysOverdue = components.day else {
                        continue
                    }
                    
                    // Calculate fine
                    let fine = daysOverdue * 5
                    
                    // Update the document with the updated fine
                    issuedBooksRef.document(document.documentID).updateData(["fine": fine]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Fine updated successfully")
                        }
                    }
                }
            }
        }
    }

}

struct HeaderView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var isPremiumMember: Bool = false
    var body: some View {
        if let user = viewModel.currentUser{
            HStack {
                VStack(alignment: .leading) {
                    let name = Name(fullName: user.fullname)
                    Text("Welcome, \(name.first)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(isPremiumMember ? "Premium Member" : "Basic Member")")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
                Spacer()
                Image(systemName: "bell")
                    .foregroundColor(.white)
                NavigationLink(destination: MProfileView().navigationBarBackButtonHidden(false)) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 36,height: 36)
                        .foregroundColor(.white)
                }
                
            }
            .onAppear {
                fetchMemberData()
            }
            .padding()
        }
        
        
    }
    
    func fetchMemberData() {
        if let userId = viewModel.currentUser?.id {
            let membersRef = Firestore.firestore().collection("members").document(userId)
            membersRef.getDocument { document, error in
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
    
}

struct CurrentlyReadingView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var issuedBooks: [(String, Int, Int)] = []
    var body: some View {
            Text("Currently Reading")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
        ScrollView(.horizontal,showsIndicators: false)
        {
                    HStack {
                        ForEach(issuedBooks, id: \.0) { (bookID, remainingDays, fine) in
                            if let book = firebaseManager.books.first(where: { $0.uid == bookID }) {
                                
                                HStack{
                                    VStack{
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Due in \(remainingDays) days")
                                                .font(
                                                Font.custom("SF Pro Text", size: 10)
                                                .weight(.semibold)
                                                )
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 10)
                                                .padding(.top, 4)
                                                .padding(.bottom, 5)
                                                .background(Color(red: 1, green: 0.79, blue: 0.16))
                                                .cornerRadius(200)
                                            
                                            Text(book.title)
                                            .font(
                                            Font.custom("SF Pro Text", size: 16)
                                            .weight(.bold)
                                            )
                                            .foregroundColor(.white)
                                        }
                                        .padding(0)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(book.authors[0])
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            
                                            Text(book.genre)
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            
                                            Text("Overdue Fine: $\(fine)")
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .foregroundColor(Color(red: 0.2, green: 0.66, blue: 0.33))


                                        }
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .padding(0)
                                        .padding(.bottom,10)
                                    }
                                    .padding(.top,18)
                                    Spacer()
                                    AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 180)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 180)
                                                .clipped()
                                        @unknown default:
                                            Text("Unknown")
                                        }
                                    }
                                    .frame(width: 100, height: 180)
                                    
                                }
                                .frame(width: 300,alignment: .topLeading)
                                .padding(15)
                                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                                .cornerRadius(10)
                                .padding(.trailing,10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
               .onAppear {
                   fetchIssuedBookDetails()
                   firebaseManager.fetchBooks()
               }
        /*
        VStack(alignment: .leading) {
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Due in 10 days")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Harry Potter and the Order of the phoenix")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Stephen King")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("2016 • Mystery")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Overdue Fine: $0")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.leading)
                
                Spacer()
                
                Image("harrypotter")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 180)
                    .clipped()
            }
            .padding(.horizontal)
        }*/
    }
    func fetchIssuedBookDetails() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("Current user UID not found")
            return
        }
        
        let db = Firestore.firestore()
        let issuedBooksRef = db.collection("members").document(currentUserUID).collection("issued_books")
        
        issuedBooksRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            var booksData: [(String, Int, Int)] = []
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a Z"
            
            for document in documents {
                let data = document.data()
                if let bookID = data["bookID"] as? String,
                   let endDateTimestamp = data["end_date"] as? Timestamp,
                   let fine = data["fine"] as? Int {
                    let endDate = endDateTimestamp.dateValue()
                    let remainingDays = Calendar.current.dateComponents([.day], from: currentDate, to: endDate).day ?? 0
                    booksData.append((bookID, remainingDays, fine))
                }
            }
            issuedBooks = booksData
        }
    }
}

struct PopularBooksView: View {
    @State private var lastReadGenre: String = "Loading..."
    @ObservedObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var viewModel: AuthViewModel // Injecting AuthViewModel
    @State private var showingSheet = false
    @State private var selectedBookUID: BookUID?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Books")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            /*Text("Last Read Genre: \(lastReadGenre)") // Display last read genre
                .foregroundStyle(Color.white)*/
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(firebaseManager.books, id: \.uid) { book in
                        if book.genre == lastReadGenre{
                            VStack {
                                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .clipped()
                                    @unknown default:
                                        Text("Unknown")
                                    }
                                }
                                .frame(width: 100, height: 150)
                                
                                Text(book.title)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Text("\(book.authors.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                showingSheet.toggle()
                                selectedBookUID = BookUID(id: book.uid)
                            }
                                    
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                fetchLastReadGenre() // Fetch last read genre on view appear
                firebaseManager.fetchBooks()
            }
            .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                            MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                        }
        }
    }
    
    func fetchLastReadGenre() {
        if let userId = viewModel.currentUser?.id {
            let membersRef = Firestore.firestore().collection("members").document(userId)
            membersRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let lastReadGenre = document.data()?["lastReadGenre"] as? String {
                        self.lastReadGenre = lastReadGenre // Update lastReadGenre
                    }
                } else {
                    print("Member document does not exist or could not be retrieved: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}


// Placeholder image loader
struct ImageLoader {
    static func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "book") ?? UIImage()
        }
        return image
    }
}

struct AuthorSectionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Authors")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { _ in
                        AuthorThumbnailView()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AuthorThumbnailView: View {
    var body: some View {
        VStack {
            Image("author")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
                .clipShape(Circle())
            Text("Author Name")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

// Placeholder image loader
struct AuthorLoader {
    static func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "author") ?? UIImage()
        }
        return image
    }
}



struct NewReleasesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("New Relases")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                        NewThumbnailView()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NewThumbnailView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var showingSheet = false
    @State private var selectedBookUID: BookUID?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(firebaseManager.books, id: \.uid) { book in
                        VStack 
                    {
                            AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                @unknown default:
                                    Text("Unknown")
                                }
                            }
                            .frame(width: 100, height: 150)
                            
                            Text(book.title)
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Text(book.authors[0])
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    .onTapGesture {
                        showingSheet.toggle()
                        selectedBookUID = BookUID(id: book.uid)
                    }
                    .sheet(item: $selectedBookUID) { selectedUID in // Use item form of sheet
                                    MBookDetailView(bookUID: selectedUID.id) // Pass selected book UID
                                }
                    
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            firebaseManager.fetchBooks()
        }
    }
}

// Placeholder image loader
struct NewImageLoader {
    static func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "book") ?? UIImage()
        }
        return image
    }
}


struct Name {
    let first: String
    let last: String

    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}

extension Name {
    init(fullName: String) {
        var names = fullName.components(separatedBy: " ")
        let first = names.removeFirst()
        let last = names.joined(separator: " ")
        self.init(first: first, last: last)
    }
}

extension Name: CustomStringConvertible {
    var description: String { return "\(first) \(last)" }
}

// Preview
struct MHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MHomeView()
    }
}

/*
 Image(systemName: "person.crop.circle")
     .resizable()
     .frame(width: 48,height: 48)
     .foregroundColor(.white)
 */
