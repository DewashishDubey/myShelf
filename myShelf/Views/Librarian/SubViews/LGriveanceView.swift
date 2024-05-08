//
//  LGriveanceView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 08/05/24.
//

import SwiftUI
import Firebase
struct LGriveanceView: View {
    @StateObject var viewModel = GrievanceViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.grievances) { grievance in
                        if (grievance.category != "Others" && grievance.category != "Membership" && grievance.category != "Library") {
                            AGrievanceItem(grievance: grievance)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchGrievances()
        }
    }
}

#Preview {
    LGriveanceView()
}
