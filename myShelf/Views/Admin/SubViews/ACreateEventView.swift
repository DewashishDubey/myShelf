//
//  ACreateEventView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 04/05/24.
//

import SwiftUI
import Firebase
struct ACreateEventView: View {
    @FocusState private var isFocused: Bool
    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var address = ""
    @State private var room = ""
    @State private var guest = ""
    @State private var capacity = ""
    @State private var summary = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView(showsIndicators:false){
                VStack{
                    CustomInputField(imageName: "textformat.alt", title: "Title", text: $title)
                               .preferredColorScheme(.dark)
                               .previewLayout(.sizeThatFits)
                               .padding(.top,20)
                    
                    HStack {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Date")
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 3, height: 20)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                .padding(.leading, 10)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(DefaultDatePickerStyle())
                                .padding(.leading)
                            

                        }
                        .padding([.top, .bottom])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                    
                    HStack {
                        HStack {
                            Image(systemName: "clock")
                            Text("Time")
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 3, height: 20)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                .padding(.leading, 10)
                            
                            DatePicker("Select a Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(.leading)
                            

                        }
                        .padding([.top, .bottom])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                    
                    CustomInputField(imageName: "location", title: "Address", text: $address)
                               .preferredColorScheme(.dark)
                               .padding(5)
                               .previewLayout(.sizeThatFits)
                    
                    CustomInputField(imageName: "mappin", title: "Room", text: $room)
                               .preferredColorScheme(.dark)
                               .padding(5)
                               .previewLayout(.sizeThatFits)
                    
                    CustomInputField(imageName: "person", title: "Guest", text: $guest)
                               .preferredColorScheme(.dark)
                               .padding(5)
                               .previewLayout(.sizeThatFits)
                    
                    HStack {
                        HStack {
                            Image(systemName: "person.fill.questionmark")
                            Text("Capacity")
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 3, height: 20)
                                .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                                .padding(.leading, 10)
                            TextField("", text: $capacity)
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                                .focused($isFocused)
                        }
                        .padding([.top, .bottom])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                    
                    VStack {
                        HStack {
                            Image(systemName: "text.book.closed")
                            Text("Summary")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        
                        
                        TextField("", text: $summary)
                            .foregroundColor(.white)
                            .lineLimit(7) // Allow multiple lines
                            .frame(maxWidth: .infinity) // Expand horizontally
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    
                    Button{
                        addEventToFirebase()
                    }label: {
                        Text("Submit")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal,20)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom,20)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Event added"), dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                    Spacer()
                }
            }
        }
        .onTapGesture {
            isFocused = false
        }
    }
    func addEventToFirebase() {
        let db = Firestore.firestore()
        var eventData: [String: Any] = [
            "title": title,
            "selectedDate": selectedDate,
            "selectedTime": selectedTime,
            "address": address,
            "room": room,
            "guest": guest,
            "capacity": Int(capacity) ?? 0,
            "summary": summary
            // Add other fields as needed
        ]
        
        // Add the event to Firebase
        /*let docRef = db.collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Error adding event: \(error.localizedDescription)")
            } else {
                print("Event added successfully!")
                // Show alert
                showAlert = true
            }
        }*/
        
        let documentRef =  db.collection("events").addDocument(data: eventData)
        eventData["uid"] = documentRef.documentID
        // Update the document in Firestore with the UID included
        documentRef.setData(eventData)
        showAlert = true
    }

}

struct CustomInputField: View {
    var imageName: String
    var title: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: imageName)
                Text(title)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 3, height: 20)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .padding(.leading, 10)
                TextField("", text: $text)
                    .foregroundColor(.white)
            }
            .padding([.top, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .foregroundColor(Color.white)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(8)
        .padding(.bottom, 10)
    }
}

#Preview {
    ACreateEventView()
}
