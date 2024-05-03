//
//  LReservationsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 02/05/24.
//

import SwiftUI
import Firebase
struct LReservationsView: View {
    @ObservedObject var viewModel = ReservationRequestViewModel()
    var body: some View {
        VStack {
            ForEach(viewModel.extensionRequests, id: \.documentID) { request in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 10)
                        
                        VStack(alignment: .leading) {
                            Text(request.user?.name ?? "")
                                .font(Font.custom("SF Pro", size: 14).weight(.medium))
                                .foregroundColor(.white)
                            Text(request.book?.title ?? "")
                                .font(Font.custom("SF Pro", size: 12).weight(.medium))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            // Format the UID (timestamp) using a formatter
                            Text(formatTimestamp(request.uid))
                                .font(Font.custom("SF Pro", size: 12).weight(.medium))
                                .foregroundColor(.white) // Customize color if needed
                        }
                        
                        Spacer()
                    }
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .padding(.top, 10)
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            viewModel.fetchData()
        }
        .padding(.top)
    }
    
    // Function to format timestamp
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        // Convert the Timestamp to a Date
        let date = timestamp.dateValue()
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a" // Customize date format as needed
        
        // Format the Date
        return dateFormatter.string(from: date)
    }
}

#Preview {
    LReservationsView()
}

