//
//  MEventPage.swift
//  myShelf
//
//  Created by user3 on 30/04/24.
//

import SwiftUI

struct MEventPage: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            //VStack {
                //ImagePlaceholder()
                   // .frame(height: 300)
                ScrollView {
                    ImagePlaceholder()
                        .frame(height: 300)
                        //.ignoresSafeArea(.all)
                    EventDetails()
                }.ignoresSafeArea()
           // }
        }
    }
}

struct ImagePlaceholder: View {
    var body: some View {
        ZStack {
            Image("library")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.9)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                )
        }
        }
}



struct EventDetails: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Book Reading & Signing Event")
              .font(
                Font.custom("SF Pro", size: 22)
                  .weight(.semibold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .padding(.leading,64)
           
            HStack {
                
                Image(systemName: "calendar")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                    .padding(.leading,25)
                    .padding(.top,40)
                VStack{
                    Text("19 January 2024")
                    .font(
                    Font.custom("SF Pro Text", size: 15)
                    .weight(.medium)
                    )
                    .foregroundColor(.white)
                        .padding(.top,40)
                    
                    Text("Tuesday, 04:00 PM")
                      .font(
                        Font.custom("SF Pro Text", size: 15)
                          .weight(.medium)
                      )
                      .foregroundColor(.white.opacity(0.6))
                            .padding(.leading,20)
                    
                    
                }
            }
                
            
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
                    .padding(.top,40)
                    .padding(.leading,25)
                
                VStack{
                    Text("The National Library of India")
                      .font(
                        Font.custom("SF Pro Text", size: 15)
                          .weight(.medium)
                      )
                      .foregroundColor(.white)
                        .padding(.top,40)
                        .padding(.leading,20)
                    
                    
                    Text("Kolkata, West Bengal")
                      .font(
                        Font.custom("SF Pro Text", size: 15)
                          .weight(.medium)
                      )
                      .foregroundColor(.white.opacity(0.6))
                        .padding(.trailing,25)
                }
            }
            
            
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
                    .padding(.top,40)
                    .padding(.leading,25)
                VStack{
                    
                    Text("J. K. Rowling")
                      .font(
                        Font.custom("SF Pro Text", size: 15)
                          .weight(.medium)
                      )
                      .foregroundColor(.white)
                        .padding(.top,40)
                        .padding(.leading,25)
                    Text("Author")
                      .font(
                        Font.custom("SF Pro Text", size: 15)
                          .weight(.medium)
                      )
                      .foregroundColor(.white.opacity(0.6))
                      .padding(.trailing,20)
                        
                }
            }
            
            
            Button(action: {}) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.26, green: 0.52, blue: 0.96))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.top,40)
            }
            
            Text("Event Overview")
              .font(
                Font.custom("SF Pro Text", size: 15)
                  .weight(.semibold)
              )
              .foregroundColor(.white)
              .padding(.leading,30)
            
            Text("Prepare to be transported into the enchanting world of literature as the National Library of India proudly presents \"Magical Literary Evening: A Conversation with J.K. Rowling.\" Renowned author J.K. Rowling, celebrated for her iconic Harry Potter series, will grace the stage for an unforgettable evening of inspiration and imagination.\n\nThe event will feature Rowling herself, offering insights into her creative process, the magical universe of Harry Potter, and her latest literary endeavors. Attendees will have the opportunity to delve into the depths of Rowling's literary genius, exploring the themes, characters, and inspirations that have captured the hearts of millions worldwide.\n\nThe evening will include a captivating discussion moderated by esteemed literary scholars, providing a deeper understanding of Rowling's literary contributions and the enduring impact of her work on readers of all ages. Following the conversation, Rowling will engage with the audience in a special Q&A session, offering fans the chance to interact directly with the beloved author.\n\nAdditionally, attendees will have the exclusive opportunity to purchase signed copies of Rowling's books and merchandise, ensuring a cherished memento of this magical literary experience. Don't miss this rare chance to embark on a journey through the realms of fantasy and imagination with one of the world's most beloved authors at the National Library of India's \"Magical Literary Evening: A Conversation with J.K. Rowling.\"")
              .font(Font.custom("SF Pro Text", size: 15))
              .foregroundColor(.white.opacity(0.6))
              .padding(.leading,30)
        }
        .padding()
    }
}
struct MemberEventPage_Previews: PreviewProvider {
    static var previews: some View {
        MEventPage()
    }
}

