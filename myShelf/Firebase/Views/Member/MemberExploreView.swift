import SwiftUI

struct MemberExploreView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var showScroll: Bool = false
    
    var body: some View {
        
        NavigationStack
        {
            ScrollView(showsIndicators: false){
                
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack(alignment: .top){
                    TagView(text: "Thriller")
                    TagView(text: "Fiction")
                    TagView(text: "Fantansy")
                    TagView(text: "Classic")
                    TagView(text: "Suspense")
                    TagView(text: "Drama")
                    TagView(text: "Horror")
                    }
                }
                BookView()
                BookView()
                BookView()
                BookView()
                BookView()
                BookView()
                
            }
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
    }
}



struct TagView: View {
    let text: String
    
    var body: some View {
        Button(action: {
            
        }) {
            Text(text)
                .font(Font.custom("SF Pro Text", size: 12))
                .foregroundColor(.white.opacity(0.6))
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
        }
    }
}


struct BookView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 120, height: 186)
                    .background(
                        Image("CrazyAsian")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 186)
                            .clipped()
                    )
                    .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Crazy Rich Asians")
                        .font(
                            Font.custom("SF Pro Text", size: 14)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                    
                    Text("Kevin Kwan")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Text("2013 • Romantic Comedy")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Text("Follows the romantic escapades of Rachel Chu, an American-born Chinese woman, and her boyfriend, Nick Young, who hails from an ultra-wealthy Singaporean family. When Nick invites Rachel to meet his family in Singapore for a wedding, she discovers...")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                    StarsView(rating: 4, maxRating: 5)
                }
            }
            
            Spacer()
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 353, height: 1)
                .background(Color.gray.opacity(0.4))
                .padding(.leading, 5)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemberExploreView()
            .preferredColorScheme(.dark)
    }
}


