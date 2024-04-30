//
//  MSubscriptionView.swift
//  myShelf
//
//  Created by Dewashish Dubey on 30/04/24.
//

import SwiftUI

struct MSubscriptionView: View {
    @State private var isMonthlySelected = false
        @State private var isYearlySelected = false
        @State private var amt = 0
    var body: some View {
        
        NavigationView{
            ScrollView(showsIndicators: false){
                ZStack {
                    Color.black.ignoresSafeArea(.all)
                    VStack(alignment: .center, spacing:20){
                        HStack{
                            
                            Text("Myshelf")
                                .font(
                                    Font.custom("SF Pro", size: 24)
                                        .weight(.bold)
                                )
                                .foregroundColor(.white)
                            Text("Premium")
                                .font(
                                    Font.custom("SF Pro", size: 24)
                                        .weight(.bold)
                                )
                                .foregroundColor(.yellow)
                            
                        }
                        .padding(.top,10)
                        .padding(.bottom,20)
                        
                        Text("Choose your Plan")
                            .font(
                                Font.custom("SF Pro", size: 15)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .padding(.bottom,20)
                        
                        
                        
                        Button(action: {
                                                
                                                isMonthlySelected.toggle()
                                                isYearlySelected = false
                                                self.amt = 99
                                                print(amt)
                                            }) {
                                                HStack(alignment: .center, spacing: 5) {

                                                    
                                                    Text("Monthly")
                                                        .font(Font.custom("SF Pro", size: 19))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                   Text("₹")
                                                        .foregroundColor(.white)
                                                    
                                                    Text("99")
                                                        .font(Font.custom("SF Pro", size: 19))
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 15)
                                                .padding(.vertical, 12)
                                                .frame(width: 353, alignment: .leading)
                                                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                                                .cornerRadius(8)
                                                //.padding(.bottom,20)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(isMonthlySelected ? Color.blue : Color.clear, lineWidth: 1)
                                                        )
                                                .padding(.bottom,20)
                                                        
                                                        
                                                        }
                                            
                                            
                                            Button(action: {
                                                isYearlySelected.toggle()
                                                isMonthlySelected = false
                                                self.amt = 999
                                                print(amt)
                                            }) {
                                                HStack(alignment: .center, spacing: 5) {

                                                    
                                                    Text("Yearly")
                                                        .font(Font.custom("SF Pro", size: 19))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                   Text("₹")
                                                        .foregroundColor(.white)
                                                    
                                                    Text("999")
                                                        .font(Font.custom("SF Pro", size: 19))
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 15)
                                                .padding(.vertical, 12)
                                                .frame(width: 353, alignment: .leading)
                                                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                                                .cornerRadius(8)
                                                //.padding(.bottom,20)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(isYearlySelected ? Color.blue : Color.clear, lineWidth: 1)
                                                        )
                                                .padding(.bottom,20)
                                                        
                                                        }
                        
                        
                        
                        NavigationLink(destination: MProfileView()) {
                            
                            HStack{
                                Text("Proceed")
                                
                                Image(systemName:"arrow.right")
                                    .foregroundColor(.white)
                            }
                            .foregroundStyle(Color(uiColor: .white))
                            .padding(10)
                            .frame(width: 350,height: 50)
                            .background(Color(red: 0.26, green: 0.52, blue: 0.96)).cornerRadius(8)
                            .padding(.bottom,20)
                        }
                        
                        
                        
                        
                        
                        
                        VStack(alignment: .leading, spacing:20){
                            HStack{
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(Font.custom("SF Pro Text", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                
                                    .frame(width: 20, alignment: .top)
                                
                                Text("Reserve books in advance")
                                    .font(
                                        Font.custom("SF Pro Text", size: 15)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                                
                            }
                            
                            HStack{
                                Image(systemName: "square.stack.3d.up.fill")
                                    .font(Font.custom("SF Pro Text", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                
                                    .frame(width: 20, alignment: .top)
                                
                                Text("Borrow up to 5 books simultaneously")
                                    .font(
                                        Font.custom("SF Pro Text", size: 15)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                            }
                            HStack{
                                Image(systemName: "person.fill.badge.plus")
                                    .font(Font.custom("SF Pro Text", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                
                                    .frame(width: 20, alignment: .top)
                                
                                Text("Priority access to high-profile events")
                                    .font(
                                        Font.custom("SF Pro Text", size: 15)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                            }
                            HStack{
                                Image(systemName: "calendar")
                                    .font(Font.custom("SF Pro Text", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                
                                    .frame(width: 20, alignment: .top)
                                
                                Text("Extended Borrowing Period")
                                    .font(
                                        Font.custom("SF Pro Text", size: 15)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                            }
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
}

struct RadioButtonView: View {
    @Binding var selected: Bool
    
    var body: some View {
        Button(action: {
            selected.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(selected ? Color.blue : Color.white)
                    .frame(width: 20, height: 20)
                
                if selected {
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct ButtonStyle2: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .frame(width: 353, height: 50, alignment: .leading)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .cornerRadius(8)
    }
}

#Preview {
    MSubscriptionView()
        .preferredColorScheme(.dark)
}
