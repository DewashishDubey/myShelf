//
//  MHomeView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 23/04/24.
//

import SwiftUI
import Firebase
struct MHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderView()
                
                CurrentlyReadingView()
                    .padding(.vertical)
                
                PopularBooksView()
                    .padding(.vertical)
                
                AuthorSectionView()
                
                NewReleasesView()
                    .padding(.vertical)
                    
            }
               
                
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
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
    var body: some View {
        VStack(alignment: .leading) {
            Text("Currently Reading")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
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
        }
    }
}

struct PopularBooksView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Books")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { _ in
                        BookThumbnailView()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct BookThumbnailView: View {
    var body: some View {
        VStack {
            Image("book")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
            Text("Book Title")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
            Text("Author Name")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
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
                    ForEach(0..<5) { _ in
                        NewThumbnailView()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NewThumbnailView: View {
    var body: some View {
        VStack {
            Image("book")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
            Text("Book Title")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
            Text("Author Name")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
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
