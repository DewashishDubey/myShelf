//
//  LEventDetailView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 04/05/24.
//


import SwiftUI
import Firebase
struct LEventDetailView: View {
    let eventID : String
    let title : String
    @StateObject var viewModel = EventViewModel()
    @EnvironmentObject var auth : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showRegistrationAlert = false
    //@State private var showWithdrawAlert = false
    @State private var isRegistered = false
    @State private var AlertMsg = ""
    @State private var showingSheet = false
    @State private var isPremiumMember: Bool = false
    var body: some View {
        VStack(){
            ScrollView(showsIndicators: false){
                ImagePlaceholder()
                EventDetails1(eventID: eventID, title: title)
            }

        }.ignoresSafeArea()
            .preferredColorScheme(.dark)
    }
}

struct EventDetails1: View {
    let eventID : String
    let title : String
    @StateObject var viewModel = EventViewModel()
    @EnvironmentObject var auth : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showRegistrationAlert = false
    //@State private var showWithdrawAlert = false
    @State private var isRegistered = false
    @State private var AlertMsg = ""
    @State private var showingSheet = false
    @State private var isPremiumMember: Bool = false
    @State private var participantsCount: Int = 0
    var body: some View {
        
        /*Text("Book Reading & Signing Event")
         .font(.custom("SF Pro", size: 22))
         .fontWeight(.bold)
         .padding(.bottom,30)*/
        ZStack
        {
            if !viewModel.events.isEmpty {
                ForEach(viewModel.events) { event in
                    VStack(alignment: .leading, spacing: 30)
                    {
                        HStack{
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: "calendar")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.26, green: 0.52, blue: 0.96))
                            .cornerRadius(6)
                            
                            VStack(alignment: .leading, spacing: 10){
                                if let extractedDate = extractDate(from: event.selectedDate) {
                                    let formattedDate = DateFormatter.localizedString(from: extractedDate, dateStyle: .medium, timeStyle: .none)
                                    Text("\(formattedDate)")
                                        .font(.custom("SF Pro Text", size: 14)
                                            .weight(.medium)
                                        )
                                }
                                
                                if let extractedTime = extractTime(from: event.selectedTime) {
                                    Text("\(extractedTime)")
                                        .font(.custom("SF Pro Text", size: 12)
                                            .weight(.medium)
                                        )
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }.padding(.horizontal)
                        
                        
                        
                        
                        HStack{
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: "person")
                            }
                            .padding(.horizontal, 11)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.26, green: 0.52, blue: 0.96))
                            .cornerRadius(6)
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text(event.guest)
                                    .font(.custom("SF Pro Text", size: 14)
                                        .weight(.medium)
                                    )
                                Text("Author")
                                    .font(.custom("SF Pro Text", size: 12)
                                          
                                    )
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }.padding(.horizontal)
                        
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
                            else if(participantsCount != 0)
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
                        
                        Text("Event Overview")
                            .font(.custom("SF Pro Text", size: 16)
                                .weight(.semibold)
                            )
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.horizontal)
                        
                        Text(event.summary)
                            .font(Font.custom("SF Pro Text", size: 14))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.horizontal)
                        
                    }
                    /*.onAppear {
                        viewModel.fetchEvent(forUID: eventID)
                        checkRegistration()
                        fetchMemberData()
                    }
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(.inline)*/
                }
            }
        }
        .onAppear {
            viewModel.fetchEvent(forUID: eventID)
            checkRegistration()
            fetchMemberData()
            countParticipants()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
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
    
    func fetchMemberData() {
        if let userId = auth.currentUser?.id {
            let membersRef = Firestore.firestore().collection("members").document(userId)
            membersRef.addSnapshotListener { document, error in
                if let document = document, document.exists {
                    if let isPremium = document.data()?["is_premium"] as? Bool {
                        self.isPremiumMember = isPremium
                    }
                } else {
                    print("Member document does not exist or could not be retrieved: \(error?.localizedDescription ?? "Unknown error")")
                }
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
        guard let currentUserUID = auth.currentUser?.id else {
            print("Current user UID not available")
            return
        }
        
        if isPremiumMember {
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
                    AlertMsg = "Successfully registered for the event!"
                    print("Successfully registered for the event!")
                    // Optionally, you can show an alert or perform any other action upon successful registration
                }
            }
        } else {
            showingSheet = true
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
    LEventDetailView(eventID: "", title: "")
}
