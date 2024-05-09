//
//  StarsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 25/04/24.
//

import SwiftUI


struct StarsView: View {
    let rating: Float
    let maxRating: Float
    
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
                        let width1 = self.valueForWidth(geometry.size.width, value: CGFloat(rating))
                        let width2 = self.valueForWidth(geometry.size.width, value: CGFloat(maxRating - rating))
                        Rectangle()
                            .frame(width: width1, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.yellow)
                        
                        Rectangle()
                            .frame(width: width2, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.gray)
                    })
                })
                .frame(width: size * CGFloat(maxRating), height: size, alignment: .trailing)
            })
            .mask(text)
        }
        .frame(width: size * CGFloat(maxRating), height: size, alignment: .leading)
    }
    
    func valueForWidth(_ width: CGFloat, value: CGFloat) -> CGFloat {
        guard width > 0 && value >= 0 else {
            return 0 // Return a default value if width is non-positive or value is negative
        }
        return (value * width) / CGFloat(maxRating)
    }
}


