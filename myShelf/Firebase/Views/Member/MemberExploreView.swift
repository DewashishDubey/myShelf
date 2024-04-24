import SwiftUI

struct MemberExploreView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var showScroll: Bool = false
    
    var body: some View {
        
        NavigationStack
        {
            ScrollView{
                
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
                    Spacer()
                }
                BookView()
                BookView()
                BookView()
                BookView()
                BookView()
                BookView()
                
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea(.all))
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


struct StarsView: View {
    let rating: CGFloat
    let maxRating: CGFloat
    
    private let size: CGFloat = 12
    var body: some View {
        let text = HStack(spacing: 0) {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
        }

        ZStack {
            text
            HStack(content: {
                GeometryReader(content: { geometry in
                    HStack(spacing: 0, content: {
                        let width1 = self.valueForWidth(geometry.size.width, value: rating)
                        let width2 = self.valueForWidth(geometry.size.width, value: (maxRating - rating))
                        Rectangle()
                            .frame(width: width1, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.yellow)
                        
                        Rectangle()
                            .frame(width: width2, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.gray)
                    })
                })
                .frame(width: size * maxRating, height: size, alignment: .trailing)
            })
            .mask(
                text
            )
        }
        .frame(width: size * maxRating, height: size, alignment: .leading)
    }
    
    func valueForWidth(_ width: CGFloat, value: CGFloat) -> CGFloat {
        value * width / maxRating
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemberExploreView()
            .preferredColorScheme(.dark)
    }
}


