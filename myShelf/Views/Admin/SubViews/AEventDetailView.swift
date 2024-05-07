//
//  AEventDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 04/05/24.
//

import SwiftUI
import Firebase
struct AEventDetailView: View {
    let eventID : String
    let title : String
    @StateObject var viewModel = EventViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var participantsCount: Int = 0
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView(showsIndicators: false)
            {
                VStack
                {
                    if !viewModel.events.isEmpty {
                        ForEach(viewModel.events) { event in
                            VStack(spacing:20){
                                Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 353, height: 190)
                                .background(
                                Image("event")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 353, height: 190)
                                .clipped()
                                )
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(8)
                                .padding(.top,20)
                                
                                
                                HStack(alignment: .center) {
                                // Space Between
                                    HStack(alignment: .center, spacing: 10) {  Image(systemName: "calendar")}
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 14)
                                    .background(Color(red: 0.26, green: 0.52, blue: 0.96))
                                    .cornerRadius(6)
                                   
                                    
                                    VStack{
                                        if let extractedDate = extractDate(from: event.selectedDate) {
                                            let formattedDate = DateFormatter.localizedString(from: extractedDate, dateStyle: .medium, timeStyle: .none)
                                            Text("\(formattedDate)")
                                                .font(
                                                Font.custom("SF Pro Text", size: 16)
                                                .weight(.medium)
                                                )
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity,alignment: .leading)
                                                .padding(.bottom,3)
                                        }
                                        
                                        if let extractedTime = extractTime(from: event.selectedTime) {
                                            Text("\(extractedTime)")
                                                .font(
                                                Font.custom("SF Pro Text", size: 12)
                                                .weight(.medium)
                                                )
                                                .foregroundColor(.white.opacity(0.6))
                                                .frame(maxWidth: .infinity,alignment: .leading)
                                        }
                                    }
                               
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.horizontal)
                                
                                HStack(alignment: .center) {
                                // Space Between
                                    
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(maxWidth: 42,maxHeight: 42)
                                   
                                    
                                    VStack{
                                        Text(event.guest)
                                            .font(
                                            Font.custom("SF Pro Text", size: 16)
                                            .weight(.medium)
                                            )
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                            .padding(.bottom,3)
                                        Text("Guest")
                                            .font(
                                            Font.custom("SF Pro Text", size: 16)
                                            .weight(.medium)
                                            )
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                    }
                                    
                                   
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.horizontal)
                                

                                NavigationLink{
                                    ParticipantsView(eventID: event.id)
                                } label: {
                                    if(participantsCount==1)
                                    {
                                        HStack{
                                           Image("male")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                            Text("1 Going")
                                                .font(
                                                Font.custom("SF Pro", size: 12)
                                                .weight(.medium)
                                                )
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))


                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.horizontal)
                                    }
                                    else if(participantsCount == 2){
                                        HStack{
                                           Image("male")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                            Text("+1 Going")
                                                .font(
                                                Font.custom("SF Pro", size: 12)
                                                .weight(.medium)
                                                )
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                            

                                            
                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.horizontal)
                                    }
                                    else
                                    {
                                        HStack{
                                           Image("male")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                            Image("female")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .offset(x:-20)
                                            Text("+\(participantsCount-2) Going")
                                                .font(
                                                Font.custom("SF Pro", size: 12)
                                                .weight(.medium)
                                                )
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                .offset(x:-20)


                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.horizontal)
                                    }
                                    
                                }
                                
                                VStack(spacing:20){
                                    Text("Event Overview")
                                        .font(
                                            Font.custom("SF Pro Text", size: 18)
                                                .weight(.semibold)
                                        )
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                    Text(event.summary)
                                        .font(Font.custom("SF Pro Text", size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                
                                Button{
                                    deleteEvent()
                                } label: {
                                    Text("Delete Event")
                                        .font(Font.custom("SF Pro Text", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.92, green: 0.26, blue: 0.21))
                                }
                                .alert(isPresented: $showAlert) {
                                            Alert(title: Text("Event removed"))
                                        }
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button("Edit") {}
            }
            .onAppear {
                viewModel.fetchEvent(forUID: eventID)
                countParticipants()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
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
    
    func deleteEvent() {
           let db = Firestore.firestore()
           let eventRef = db.collection("events").document(eventID)
           
           eventRef.delete { error in
               if let error = error {
                   print("Error deleting document: \(error)")
               } else {
                   print("Document successfully deleted!")
                   showAlert = true
                   presentationMode.wrappedValue.dismiss()
               }
           }
       }
    
    func countParticipants() {
            let db = Firestore.firestore()
            let participantsRef = db.collection("events").document(eventID).collection("participants")
            
            participantsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting participants: \(error)")
                    return
                }
                
                if let snapshot = snapshot {
                    participantsCount = snapshot.documents.count
                }
            }
        }
    
}

#Preview {
    AEventDetailView(eventID: "", title: "")
}
