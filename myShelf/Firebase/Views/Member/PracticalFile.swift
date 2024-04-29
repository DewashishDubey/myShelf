//HStack(alignment: .center)
//{
//    Text("Library")
//    .font(
//    Font.custom("SF Pro", size: 20)
//    .weight(.semibold)
//    )
//    .foregroundColor(.white)
//Spacer()
//}
//.padding(0)
//.frame(maxWidth: .infinity, alignment: .center)
//.padding(.bottom,10)
//
//
//ForEach(firebaseManager.books.filter {
//    (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText.lowercased()))
//}, id: \.uid) { book in
//    HStack(alignment: .top, spacing: 15)
//    {
//        
//            AsyncImage(url: URL(string: book.imageUrl)) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 60, height: 90)
//                        .clipped()
//                case .failure:
//                    Image(systemName: "photo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 60, height: 90)
//                        .clipped()
//                @unknown default:
//                    Text("Unknown")
//                }
//            }
//                .frame(width: 60, height: 90)
//                .clipped()
//        
//        
//        VStack(alignment: .leading,spacing: 5) {
//            HStack{
//                Text(book.title)
//                    .font(
//                        Font.custom("SF Pro Text", size: 18)
//                            .weight(.bold)
//                    )
//                    .foregroundColor(.white)
//                    .frame(alignment: .topLeading)
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.white.opacity(0.6))
//            }
//            
//            Text(book.authors[0])
//            .font(Font.custom("SF Pro Text", size: 14))
//            .foregroundColor(.white.opacity(0.6))
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//                                                
//            Text(book.genre)
//            .font(Font.custom("SF Pro Text", size: 14))
//            .foregroundColor(.white.opacity(0.6))
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            Text("Copies: \(book.noOfCopies)")
//                .font(Font.custom("SF Pro Text", size: 14))
//                .foregroundColor(.white.opacity(0.6))
//                .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//        }
//        .padding(0)
//        .frame(alignment: .leading)
//    }
//    .padding(.top,10)
//    .padding(.bottom,20)
//    .padding(0)
