//
//  MembersAnalyticsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 09/05/24.
//


import SwiftUI
import FirebaseFirestore

struct MembersAnalyticsView: View {
    @State private var memberSplit: [String: Int] = [:]
    private let memberColors: [String: Color] = ["Regular": .blue, "Premium": .green]
    
    var body: some View {

            VStack(spacing: 16) {
                PieChart(data: memberSplit, colors: memberColors)
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 100)
                    .padding(.trailing,200)
                
                ForEach(memberSplit.sorted(by: { $0.key < $1.key }), id: \.key) { type, count in
                    HStack {
                        Circle()
                            .fill(memberColors[type] ?? .gray)
                            .frame(width: 10, height: 10)
                        Text(type)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(count)")
                            .foregroundColor(.white)
                    }.padding(.horizontal)
                }
                .padding(.horizontal)

            }
            .padding()
            .onAppear {
                fetchMembersSplit()
            }
        .frame(maxWidth: .infinity)
    }
    
    func fetchMembersSplit() {
        let db = Firestore.firestore()
        db.collection("members").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching members: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No members found")
                return
            }
            
            var memberTypeCount: [String: Int] = [:]
            for document in documents {
                if let isPremium = document["is_premium"] as? Bool {
                    let memberType = isPremium ? "Premium" : "Regular"
                    memberTypeCount[memberType, default: 0] += 1
                }
            }
            self.memberSplit = memberTypeCount
        }
    }
}

struct PieChart: View {
    let data: [String: Int]
    let colors: [String: Color]? // Optional colors for pie chart
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(data.sorted(by: { $0.value > $1.value }), id: \.key) { (key, value) in
                    PieSlice(startAngle: .degrees(startAngle(value: value)), endAngle: .degrees(endAngle(value: value)))
                        .fill(colors?[key] ?? Color.random) // Use custom colors if provided, else random color
                        .rotationEffect(.degrees(-90))
                        .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
    }
    
    private func startAngle(value: Int) -> Double {
        guard !data.isEmpty else { return 0 }
        let total = data.reduce(0) { $0 + $1.value }
        return (value > 0) ? Double(data.filter { $0.value > value }.reduce(0) { $0 + $1.value }) / Double(total) * 360 : 0
    }
    
    private func endAngle(value: Int) -> Double {
        guard !data.isEmpty else { return 0 }
        let total = data.reduce(0) { $0 + $1.value }
        return Double(data.reduce(0) { $0 + $1.value }) / Double(total) * 360
    }
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1),
                     green: Double.random(in: 0...1),
                     blue: Double.random(in: 0...1))
    }
}

#Preview {
    MembersAnalyticsView()
}
