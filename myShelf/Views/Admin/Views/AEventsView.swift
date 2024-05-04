//
//  AEventsView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import SwiftUI
import Firebase
struct AEventsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var selectedTag: String?
    @StateObject private var eventsViewModel = EventViewModel()
    var body: some View {
        ZStack
        {
            ScrollView{
                Color.black.ignoresSafeArea(.all)
                VStack(spacing:10)
                {
                    /*
                    ScrollView(.horizontal, showsIndicators: false)
                    {
                        HStack(alignment: .top){
                            TagView(text: "Ongoing", selectedTag: $selectedTag)
                            TagView(text: "Previous", selectedTag: $selectedTag)
                        }
                    }
                    .padding(.bottom,10)
                    .padding(.leading,10)*/
                    //.padding(.top,30)
                    
                    
                    HStack(alignment: .center)
                    {
                        Text("Events")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.semibold)
                            )
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,10)
                    .padding(.leading,10)
                    
                    NavigationLink{
                        ACreateEventView()
                    }label: {
                        HStack{
                            Text("Create New Event")
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 20,height: 20)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                    }
                    .padding(.bottom,10)
                    
                    ForEach(eventsViewModel.events) { event in
                        NavigationLink{
                            AEventDetailView(eventID : event.uid, title: event.title)
                        }label: {
                            HStack(alignment: .center, spacing: 10) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 80, height: 80)
                                    .background(
                                        Image("library")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                    )
                                    .cornerRadius(4)
                                VStack(spacing:5){
                                    Text(event.title)
                                        .font(
                                        Font.custom("SF Pro Text", size: 14)
                                        .weight(.medium)
                                        )
                                        .foregroundColor(.white)

                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    if let extractedDate = extractDate(from: event.selectedDate) {
                                        let formattedDate = DateFormatter.localizedString(from: extractedDate, dateStyle: .medium, timeStyle: .none)
                                        Text("\(formattedDate)")
                                            .font(
                                            Font.custom("SF Pro Text", size: 12)
                                            .weight(.medium)
                                            )
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                    }
                                    
                                    if let extractedTime = extractTime(from: event.selectedTime) {
                                        Text("\(extractedTime)")
                                            .font(
                                            Font.custom("SF Pro Text", size: 12)
                                            .weight(.medium)
                                            )
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                    }
                                }
                                
                            }
                            .padding([.top,.bottom],12)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.horizontal)
                            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .cornerRadius(8)
                        }
                        
                        
                        
                        
                    }
                    
                }
                .onAppear {
                    eventsViewModel.fetchEvents()
                }
                .padding(.horizontal)
                
            }
            
        }
       
}
    func extractDate(from timestampString: String) -> Date? {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a" // Adjust format based on your timestamp string
        
        // Attempt to parse the string into a Date object
        if let date = dateFormatter.date(from: timestampString) {
            return date
        } else {
            print("Unable to parse timestamp string: \(timestampString)")
            return nil
        }
    }
    
    func extractTime(from timestampString: String) -> String? {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a" // Adjust format based on your timestamp string
        
        // Attempt to parse the string into a Date object
        if let date = dateFormatter.date(from: timestampString) {
            // Create a time formatter to extract hours, minutes, and AM/PM
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            // Format the extracted date to include hours, minutes, and AM/PM
            return timeFormatter.string(from: date)
        } else {
            print("Unable to parse timestamp string: \(timestampString)")
            return nil
        }
    }

}

#Preview {
    AEventsView()
}


/*var body: some View {
    if let user = viewModel.currentUser{
        ScrollView{
            VStack{
                VStack{
                     Text("This is the Adnin Page")
                     Text(user.fullname)
                     Text(user.userType.rawValue)
                     Section("Account")
                     {
                         Button{
                             viewModel.signOut()
                         } label: {
                             SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                         }
                     }
                     Spacer()
                 }
            }
        }
        .frame(maxWidth : .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}*/
