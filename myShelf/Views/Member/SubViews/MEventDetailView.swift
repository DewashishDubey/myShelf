//
//  MEventDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 04/05/24.
//

import SwiftUI
import Firebase
struct MEventDetailView: View {
    let eventID : String
    let title : String
    @StateObject var viewModel = EventViewModel()
    @EnvironmentObject var auth : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showRegistrationAlert = false
    //@State private var showWithdrawAlert = false
    @State private var isRegistered = false
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

                                VStack(spacing:20){
                                    Button(action: {
                                        if isRegistered {
                                            unregister()
                                        } else {
                                                   // User is not registered, register for the event
                                                   registerForEvent()
                                               }
                                    }) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Text(isRegistered ? "Withdraw Registration" : "Register")
                                                .font(
                                                    Font.custom("SF Pro Text", size: 16)
                                                        .weight(.semibold)
                                                )
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                        .padding(15)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(isRegistered ? Color.green : Color(red: 0.26, green: 0.52, blue: 0.96))
                                        .cornerRadius(6)
                                    }
                                    .alert(isPresented: $showRegistrationAlert) {
                                                   Alert(
                                                       title: Text("Success"),
                                                       message: Text("Registered Successfully"),
                                                       dismissButton: .default(Text("OK"))
                                                   )
                                               }
                                    
                                    
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
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchEvent(forUID: eventID)
                checkRegistration()
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
    
    // Function to register for the event
    private func registerForEvent() {
        guard let currentUserUID =  auth.currentUser?.id else {
            print("Current user UID not available")
            return
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let participantsRef = eventRef.collection("participants")
        
        let participantData: [String: Any] = [
            "memberID": currentUserUID,
            "eventID": eventID
        ]
        
        participantsRef.addDocument(data: participantData) { error in
            if let error = error {
                print("Error adding participant: \(error)")
            } else {
                showRegistrationAlert = true
                print("Successfully registered for the event!")
                // Optionally, you can show an alert or perform any other action upon successful registration
            }
        }
    }
    
    private func checkRegistration() {
           guard let currentUserUID = auth.currentUser?.id else {
               print("Current user UID not available")
               return
           }
           
           let db = Firestore.firestore()
           let eventRef = db.collection("events").document(eventID)
           let participantsRef = eventRef.collection("participants")
           
           participantsRef.whereField("memberID", isEqualTo: currentUserUID).addSnapshotListener { querySnapshot, error in
               if let error = error {
                   print("Error fetching participant documents: \(error)")
               } else {
                   // Check if the current user is already registered
                   if let documents = querySnapshot?.documents, !documents.isEmpty {
                       // User is already registered
                       isRegistered = true
                   } else {
                       // User is not registered
                       isRegistered = false
                   }
               }
           }
       }
    
    private func unregister() {
        guard let currentUserUID = auth.currentUser?.id else {
            print("Current user UID not available")
            return
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let participantsRef = eventRef.collection("participants")
        
        participantsRef.whereField("memberID", isEqualTo: currentUserUID).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching participant documents: \(error)")
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error removing participant document: \(error)")
                        } else {
                            print("Successfully unregistered for the event.")
                            isRegistered = false
                            //showWithdrawAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MEventDetailView(eventID: "", title: "")
}
