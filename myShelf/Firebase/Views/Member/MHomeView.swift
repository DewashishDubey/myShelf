import SwiftUI

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
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome, Vansh")
                    .font(
                        Font.custom("SF Pro", size: 30)
                          .weight(.bold)
                      )
                      .foregroundColor(.white)
                    .foregroundColor(.white)
                Text("Premium User")
                    .font(
                        Font.custom("SF Pro", size: 14)
                          .weight(.bold)
                      )
                    .foregroundColor(.yellow)
            }
            Spacer()
            Image(systemName: "bell")
                .foregroundColor(.white)
            Image("Account")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipped()
                .clipShape(Circle())
        }
        .padding()
    }
}

struct CurrentlyReadingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Currently Reading")
                .font(
                    Font.custom("SF Pro", size: 20)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
                  .padding(.horizontal)
                  .padding(.bottom,10)
            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 360, height: 200, alignment: .topLeading)
                    .cornerRadius(10)
                
                
                HStack {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow)
                            .frame(width : 100, height : 30)
                            .overlay(
                                Text("Due in 10 days")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    
                            )
                            .padding(.top,10)
                        Text("Harry Potter and the Order of the phoenix")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                        Text("Stephen King")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("2016 • Mystery")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Overdue Fine: $0")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.bottom,10)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Image("HarryPotter")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .clipped()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct PopularBooksView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Books")
                .font(
                    Font.custom("SF Pro", size: 20)
                      .weight(.bold)
                  )
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom,10)
            
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
            Image("Book")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
            Text("Book Title")
                .font(
                    Font.custom("SF Pro", size: 12)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
                .foregroundColor(.white)
                .lineLimit(1)
            Text("Author Name")
                .font(
                    Font.custom("SF Pro", size: 12)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
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
                .font(
                    Font.custom("SF Pro", size: 20)
                      .weight(.bold)
                  )
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
            Image("Author")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
                .clipShape(Circle())
            Text("Author Name")
                .font(
                    Font.custom("SF Pro", size: 12)
                      .weight(.bold)
                  )
                .foregroundColor(.gray)
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
                .font(
                    Font.custom("SF Pro", size: 20)
                      .weight(.bold)
                  )
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom,10)
            
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
            Image("Book")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .clipped()
            Text("Book Title")
                .font(
                    Font.custom("SF Pro", size: 12)
                      .weight(.bold)
                  )
                .foregroundColor(.white)
                .lineLimit(1)
            Text("Author Name")
                .font(
                    Font.custom("SF Pro", size: 12)
                      .weight(.bold)
                  )
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


// Preview
struct HomePageUser_Previews: PreviewProvider {
    static var previews: some View {
        MHomeView()
            .preferredColorScheme(.dark)
    }
}

