//
//  TestView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 03/05/24.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel = EventViewModel()
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
                List(viewModel.events) { event in
                    VStack(alignment: .leading) {
                        Text("Title: \(event.title)")
                            .font(.headline)
                        Text("Summary: \(event.summary)")
                            .foregroundColor(.gray)
                        Text("Address: \(event.address)")
                        Text("Capacity: \(event.capacity)")
                        Text("Guest: \(event.guest)")
                        Text("Room: \(event.room)")
                        Text("Selected Date: \(event.selectedDate)")
                        Text("Selected Time: \(event.selectedTime)")
                        Text("UID: \(event.uid)")
                    }
                    .padding()
                }
                .navigationTitle("Events")
                .onAppear {
                    viewModel.fetchEvents()
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
