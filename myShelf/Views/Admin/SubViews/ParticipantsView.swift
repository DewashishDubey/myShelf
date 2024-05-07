//
//  ParticipantsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 07/05/24.
//

import SwiftUI


struct ParticipantsView: View {
    @StateObject private var viewModel = ParticipantsViewModel()
    let eventID: String
    
    var body: some View {
        List {
            ForEach(viewModel.participants) { participant in
                ParticipantRow(participant: participant)
            }
        }
        .onAppear {
            viewModel.fetchParticipants(forEventWithID: eventID)
        }
    }
}

struct ParticipantRow: View {
    let participant: Participant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing:10) {
                Image(participant.user?.gender == "male" ? "male" : "female")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                
                Text(participant.user?.name ?? "")
                    .font(Font.custom("SF Pro", size: 14).weight(.medium))
                    .foregroundColor(.white)
            }
        }
       // .padding(.horizontal)
    }
}
#Preview {
    ParticipantsView(eventID: "")
}
