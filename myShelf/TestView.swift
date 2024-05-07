//
//  TestView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//


import SwiftUI

struct booksmatrix: View {
    @State private var count: Int = 500
    private let maxCount: Int = 3546
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                if count > maxCount {
                    SemicircleProgressView3(progress: CGFloat(count)/CGFloat(maxCount))
                        .frame(width: 300, height: 150)
                    
                }
                else{
                    SemicircleProgressView(progress: CGFloat(count) / CGFloat(maxCount))
                        .frame(width: 300, height: 150)
                }
                Text("Complete your Collection")
                .font(
                Font.custom("SF Pro Text", size: 14)
                .weight(.medium)
                )
                .foregroundColor(.white)
                Text("\(count)/\(maxCount)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    // Action to complete the collection
                }) {
                    Text("Complete your Collection")
                    .font(
                    Font.custom("SF Pro Text", size: 10)
                    .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)

                    
                }
                
                Spacer()
            }
        }
    }
}

struct SemicircleProgressView: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.addArc(center: CGPoint(x: width / 2, y: height),
                            radius: width / 2,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 360),
                            clockwise: false)
            }
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(Color.gray.opacity(0.2))
            
        
            
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.addArc(center: CGPoint(x: width / 2, y: height),
                            radius: width / 2,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 360 - (Double(progress) * 180.0)),
                            clockwise: true)
            }
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(Color.blue)
        }
    }
}

struct SemicircleProgressView3: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader
        { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.addArc(center: CGPoint(x: width / 2, y: height),
                            radius: width / 2,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 360),
                            clockwise: false)
            }
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(Color.gray.opacity(0.2))
            
        
            
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.addArc(center: CGPoint(x: width / 2, y: height),
                            radius: width / 2,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 180),
                            clockwise: true)
            }
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(Color.blue)
        }
    }
}


#Preview {
    booksmatrix()
        .preferredColorScheme(.dark)
}


