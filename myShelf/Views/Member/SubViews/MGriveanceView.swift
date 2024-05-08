//
//  FAQ.swift
//  roughcopy
//
//  Created by sristi on 07/05/24.
//

import SwiftUI
import Firebase

struct MGriveanceView: View {
    @State private var selectedcategory: String = "Membership"
    @State private var subject = ""
    @State private var description = ""
    @State private var isSubjectTooLong = false
    @State private var isGrievanceTooLong = false
    let userViewModel = UserViewModel()
    let memberID: String // Member ID for which to fetch user details
    @State private var memberData: MemberData?
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    let GrievanceMaxcount = 300
    let SubjectMaxcount = 30
    @FocusState private var isFocused: Bool
    let categoryOptions = ["Others","Library", "Reservation", "Membership","Fines","Check-in","Check-out"]
    var body: some View {
        
        NavigationView{
            ScrollView
            {
                if let memberData = memberData {
                    VStack
                    {
                        VStack(alignment: .center, spacing: 15) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 100, height: 100)
                                .background(
                                    
                                    Image(memberData.gender == "male" ? "male" : "female").resizable()
                                    
                                        .aspectRatio(contentMode: .fill)
                                    
                                )
                                .cornerRadius(100)
                                .padding(.leading,0)
                                .padding(.bottom,20)
                            
                            Text("\(memberData.name),\nFeel free to reach out to us.")
                                .font(
                                    Font.custom("SF Pro", size: 20)
                                        .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom,40)
                        
                        DropdownView(selectedOption: $selectedcategory, options: categoryOptions, label: "Category")
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Subject")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                            
                            
                            TextField("Give short description",text: $subject,axis:.vertical)
                                .focused($isFocused)
                                .font(Font.custom("SF Pro", size: 15))
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.7)
                                .onChange(of: subject) { newValue in
                                    
                                    if newValue.count > 30 {
                                        let truncatedText = String(newValue.prefix(30))
                                        subject = truncatedText
                                    }
                                }
                            
                            
                            
                            Spacer()
                            HStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("\(subject.count)/30")
                                        .padding(.top, 5)
                                        .font(Font.custom("SF Pro", size: 12))
                                    
                                }
                            }
                            
                            
                            
                            
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(maxWidth: 353,alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,15)
                        
                        
                        
                        
                        
                        
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Grievance")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                            
                            
                            TextField("Explain your grievance",text: $description,axis:.vertical)
                                .focused($isFocused)
                                .font(Font.custom("SF Pro", size: 15))
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.7)
                                .onChange(of: description) { newValue in
                                    
                                    if newValue.count > 300 {
                                        let truncatedText = String(newValue.prefix(300))
                                        description = truncatedText
                                    }
                                }
                            
                            
                            
                            Spacer()
                            HStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("\(description.count)/300")
                                        .padding(.top, 5)
                                        .font(Font.custom("SF Pro", size: 12))
                                    
                                }
                            }
                            
                            
                            
                            
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(maxWidth: 353, alignment: .leading)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(8)
                        .padding(.bottom,15)
                        
                        
                        
                        Button{
                            submitGrievance()
                        }label: {
                            Text("Submit")
                                .foregroundStyle(Color(uiColor: .white))
                                .padding(10)
                                .frame(width: 350,height: 50)
                                .background(Color(red: 0.26, green: 0.52, blue: 0.96)).cornerRadius(8)
                                .padding(.bottom,20)
                                .disabled(isSubjectTooLong || isGrievanceTooLong)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Success"), message: Text("Grievance submitted successfully"), dismissButton: .default(Text("OK")){presentationMode.wrappedValue.dismiss()})
                                    }
                    }
                    
                    
                }
                Spacer()
            }
            .onAppear {
                // Fetch user details when the view appears
                userViewModel.fetchUserDetails(for: memberID) { fetchedMemberData in
                    // Update memberData state variable with fetched user details
                    memberData = fetchedMemberData
                }
            }
            .onTapGesture {
                // To Dismiss keyboard
                isFocused = false
            }
            
        }
    }
    
    func wordCount(_ text: String) -> Int {
        let words = text.split { $0 == " " || $0.isNewline }
        return words.count
    }
    
    func truncateText(_ text: String, to count: Int) -> String {
        let words = text.split { $0 == " " || $0.isNewline }
        let truncatedWords = words.prefix(count)
        return truncatedWords.joined(separator: " ")
    }
    
    func submitGrievance() {
        guard let memberData = memberData else {
            print("Member data not available")
            return
        }
        
        // Create a grievance entry with member ID
        let grievanceEntry = GrievanceEntry(memberID: memberData.id, category: selectedcategory, subject: subject, description: description)
        
        // Add the grievance entry to Firestore
        let db = Firestore.firestore()
        do {
            let docRef = try db.collection("grievance").addDocument(from: grievanceEntry) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    showAlert = true
                    print("Document added successfully!")
                }
            }
            // Assign the document ID (UID) to the grievance entry
            let generatedID = docRef.documentID
            var updatedGrievanceEntry = grievanceEntry
            updatedGrievanceEntry.id = generatedID
            
            // Update the document in Firestore with the document ID
            try db.collection("grievance").document(generatedID).setData(from: updatedGrievanceEntry)
        } catch {
            print("Error encoding grievance entry: \(error)")
        }
    }
    
}




struct DropdownView: View {
    @Binding var selectedOption: String
    let options: [String]
    let label: String
    

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selectedOption = option
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 15){
                
                
                Text(label)
                    .font(Font.custom("SF Pro", size:19))
                    .foregroundColor(.white)
                    .padding(.trailing,25)
                    .padding(.leading,10)
                
                HStack(alignment: .center, spacing: 10) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 1, height: 20)
                        .background(.gray)
                        .padding(.trailing,25)
                }
                
                Text(selectedOption)
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .frame(width: 353, height: 50, alignment: .leading)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .cornerRadius(8)
            .padding(.bottom,15)
        }
        
        
    
        
    }
}

struct GrievanceEntry: Codable,Identifiable { // Make it Codable for Firestore
    var id: String? // Document ID (UID)
    let memberID: String
    let category: String
    let subject: String
    let description: String
}


#Preview {
    MGriveanceView(memberID: "")
}
