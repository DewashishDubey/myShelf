//
//  filespolicy.swift
//  myShelf
//
//  Created by useerr2 on 25/04/24.
//

import SwiftUI
import Firebase
struct FinePolicyView: View {
    @State private var selectedIssueRange: String = "15 Days"
        @State private var selectedReservation: String = "02 Hours"
        let issueRangeOptions = ["10 Days", "15 Days", "20 Days"]
        let reservationOptions = ["01 Hour", "02 Hours", "03 Hours"]
    @State private var showAlert = false
    @State private var value = ""
    var body: some View {
      
        NavigationView{
            ScrollView{
                VStack(alignment: .leading,spacing: 20){
                    
                    HStack{
                        Text("Fines & Dues Policies")
                            .font(
                                Font.custom("SF Pro Text", size: 18)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.trailing,38)
                        
                    }.padding(.leading,10)
                        .padding(.bottom,15)
                    //                Spacer()
                    
                    
                    HStack(alignment: .center, spacing: 15) {Image(systemName: "indianrupeesign")
                            .foregroundColor(.indigo)
                        Text("Due Amount")
                            .font(Font.custom("SF Pro", size: 19))
                            .foregroundColor(.white)
                            .padding(.trailing,35)
                        HStack(alignment: .center, spacing: 10) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 1, height: 20)
                                .background(.gray)
                                .padding(.trailing,15)
                            TextField("Value per day", text: $value)
                                .foregroundColor(.white)
                                .padding(0)
                                .frame(width: 110)
                                .accentColor(.white)
                            
                        }
                        .padding(0)
                        .frame(width: 110, alignment: .leading)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(width: 353, height: 50, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom,15)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 15) {
                        DropdownView1(selectedOption: $selectedIssueRange, options: issueRangeOptions, label: "Issue Range", icon: "calendar")
                        
                    }
                    VStack(alignment: .leading, spacing: 15) {
                        DropdownView2(selectedOption: $selectedReservation, options: reservationOptions, label: "Reservation", icon: "calendar")
                        
                    }
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(Font.custom("SF Pro", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.indigo)
                                .padding(.trailing,10)
                            
                                .frame(width: 20, alignment: .top)
                            Text("General Rules")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom,10)
                        Text("1. No disruptive behavior allowed.\n2. Maintain silence, switch off devices.\n3. Dress appropriately, no loitering.\n4. Respect library materials and rules.\n5. Library membership cards are non-transferable.\n6. Report lost cards immediately, pay dues promptly.\n7. Library not responsible for personal belongings.\n8. Keep library informed of contact details.\n9. Return books to designated areas for re-shelving.\n10. Staff can ask disruptive users to leave.\n11. Non-members may be asked to leave.")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.white)
                        
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .opacity(0.7)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(width: 353, height: 350, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom,15)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(Font.custom("SF Pro", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.indigo)
                                .padding(.trailing,10)
                            
                                .frame(width: 20, alignment: .top)
                            Text("Membership of the Library")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom,10)
                        Text("Normal Members:\nCentral government employees in Delhi NCR can join for five years with office endorsement. They can borrow four books and must return them on time. Retired central government employees can join with their PPO number, pay a refundable security, and borrow three books.\n\nPremium Members:\nEminent scholars and residents of Delhi can join with proof of address and pay a refundable deposit and an annual fee to borrow three books. Additionally, organizations in Delhi can join by paying an annual fee. Employees can borrow books with the organization's responsibility for returns.")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.white)
                        
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .opacity(0.7)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(width: 353, height: 350, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom,15)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(Font.custom("SF Pro", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.indigo)
                                .padding(.trailing,10)
                            
                                .frame(width: 20, alignment: .top)
                            Text("Library Timings")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom,10)
                        Text("Opening Hours:\n9.00 A.M. to 6.30 P.M. Monday to Friday Lending service is available till 6.00 P.M.\n\nThe library will remain closed on all public holidays notified by Government of India. \n\nAll users must prepare to leave the Library ten minutes before closing time and to be out of the building by closing time. \n\nItems available for loan may be borrowed until ten minutes before closing time.")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.white)
                        
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .opacity(0.7)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(width: 353, height: 350, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(8)
                    .padding(.bottom,15)
                    

                }
                
                Button(action: {
                    let issueRangeValue = Int(selectedIssueRange.replacingOccurrences(of: " Days", with: "")) ?? 0
                    let reservationValue = Int(selectedReservation.replacingOccurrences(of: " Hours", with: "")) ?? 1
                    let intValue = Int(value) ?? 0
                    
                    let adminData = AdminData(fine: intValue, selectedIssueRange: issueRangeValue, selectedReservation: reservationValue)
                    
                    let db = Firestore.firestore()
                    let adminRef = db.collection("admin").document("VtD7uAEOUTXDKKNFfqR7") // Assuming "adminDocument" is the document ID
                    
                    adminRef.getDocument { document, error in
                        if let document = document, document.exists {
                            // Document exists, update it
                            adminRef.setData(["fine": adminData.fine,
                                              "selectedIssueRange": adminData.selectedIssueRange,
                                              "selectedReservation": adminData.selectedReservation], merge: true) { error in
                                if let error = error {
                                    print("Error updating document: \(error.localizedDescription)")
                                } else {
                                    showAlert = true // Show alert after updating
                                }
                            }
                        } else if let error = error {
                            print("Error fetching document: \(error.localizedDescription)")
                        }
                    }
                }) {
                               Text("Save Changes")
                                .padding(10)
                                   .font(Font.custom("SF Pro", size: 18))
                                   .foregroundColor(.white)
                                   .frame(maxWidth: .infinity)
                                   .background(Color.indigo)
                                   .cornerRadius(8)
                        }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Fine Policies Updated"), message: Text("Changes have been saved."), dismissButton: .default(Text("OK")))
                }
                
            }
        }
            
            
        
    }
}

struct DropdownView1: View {
    @Binding var selectedOption: String
    let options: [String]
    let label: String
    let icon: String

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selectedOption = option
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 15){
                Image(systemName: "book.fill")
                    .foregroundColor(.indigo)
                
                Text(label)
                    .font(Font.custom("SF Pro", size: 19))
                    .foregroundColor(.white)
                    .padding(.trailing,25)
                
                HStack(alignment: .center, spacing: 10) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 1, height: 20)
                        .background(.gray)
                        .padding(.trailing,15)
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
struct DropdownView2: View {
    @Binding var selectedOption: String
    let options: [String]
    let label: String
    let icon: String

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selectedOption = option
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 15){
                Image(systemName: "calendar")
                    .foregroundColor(.indigo)
                
                Text(label)
                    .font(Font.custom("SF Pro", size: 18))
                    .foregroundColor(.white)
                    .padding(.trailing,35)
                
                HStack(alignment: .center, spacing: 10) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 1, height: 20)
                        .background(.gray)
                        .padding(.trailing,15)
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


#Preview {
    FinePolicyView()
}

struct AdminData: Codable {
    let fine: Int
    let selectedIssueRange: Int
    let selectedReservation: Int
}
