//
//  A_AnalyticsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 09/05/24.
//

import SwiftUI
import Firebase

struct BooksAnalyticsView: View {
    @State private var genreSplit: [String: Int] = [:]
    private let genreColors: [String: Color] = [
        "Classics": .blue,
        "Comics": .green,
        "Drama": .orange,
        "Fantasy": .yellow,
        "Fiction": .red,
        "Horror": .purple,
        "Philiosophy": .pink,
        "Poetry": .gray,
        "Self-Help": .cyan,
        "Suspense": .teal,
        "Thriller": .indigo
    ]
    
    var body: some View {
      
            
            VStack(spacing: 10) {
                PieChart(data: genreSplit, colors: genreColors)
                    .frame(width: 200, height: 150)
                    .padding(.bottom, 100)
                    .padding(.trailing,200)
                
                VStack{
                    ForEach(genreSplit.sorted(by: { $0.key < $1.key }), id: \.key) { genre, count in
                        HStack {
                            Circle()
                                .fill(genreColors[genre] ?? .gray) // Show color code next to genre
                                .frame(width: 10, height: 10)
                            Text(genre)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(count)")
                        }
                        .padding(.horizontal,50)
                    }
                    // .padding(.horizontal)
                }
                .padding(.top,20)
                .padding(.bottom,40)
            }
            .onAppear {
                fetchBooksGenreSplit()
            }
        }
    
    func fetchBooksGenreSplit() {
        let db = Firestore.firestore()
        db.collection("books").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching books: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No books found")
                return
            }
            
            var genreCount: [String: Int] = [:]
            for document in documents {
                if let genre = document["genre"] as? String {
                    genreCount[genre, default: 0] += 1
                }
            }
            self.genreSplit = genreCount
        }
    }
}
