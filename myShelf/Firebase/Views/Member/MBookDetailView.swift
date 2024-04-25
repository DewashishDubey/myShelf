import SwiftUI

struct MBookDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                CurrentlyReadingView1()
                    
            }
               
                
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


struct CurrentlyReadingView1: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 360, height: 900, alignment: .topLeading)
                    .cornerRadius(10)
                
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 5)
                        .background(Color(red: 0.76, green: 0.76, blue: 0.76).opacity(0.5))
                        .cornerRadius(2.5)
                    
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.7))
                        .frame(width: 20, height: 20)
                        .padding(.leading, 320)
                       // .position(x: 340 , y: 20)
                    
                    Image("CrazyAsian")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 230, height: 355)
                        .clipped()
                        .cornerRadius(10)

//                        .position(x: 190, y: 35)
//
                    Text("Crazy Rich Asians")
                        .font(Font.custom("SF Pro", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 313)
                        .padding(.top,30)
//                        .position(x: 190, y: -150) // Adjust position to make the text visible
                    
                    Text("Kevin Kwan")
                      .font(
                        Font.custom("SF Pro Text", size: 14)
                          .weight(.semibold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                      .frame(maxWidth: .infinity, alignment: .top)
                      .padding(.top,15)
                    
//                      .position(x: 190, y: -100)
                    
                    Text("2013 • Romantic Comedy")
                      .font(Font.custom("SF Pro Text", size: 14))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                      .frame(maxWidth: .infinity, alignment: .top)
//                      .position(x: 190, y: -100)
                      .padding(.top,15)
                    
                    HStack{
                        
                        StarsView(rating: 4, maxRating: 5)
                            .padding(.top,30)
                        
                        
                        Image(systemName: "bookmark")
                            .font(
                            Font.custom("SF Pro Text", size: 14)
                            .weight(.semibold)
                            )
                            .foregroundColor(.white)
                            .padding(.top,30)
                            .padding(.leading,240)
                        
                        
                    }
                    VStack{
                        HStack{
                            Text("1,232 Ratings")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.leading,10)
                              .padding(.trailing,227)
                            
                            Text("Wishlist")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.trailing,5)
                        }.padding(.top,10)

                    }
                    
                    Button(action: {
                                            // Action for Reserve button
                                        }) {
                                            Text("Reserve Book")
                                              .font(
                                                Font.custom("SF Pro Text", size: 14)
                                                  .weight(.semibold)
                                              )
                                              .multilineTextAlignment(.center)
                                              .frame(width: 340, height: 50)
                                              .foregroundColor(.white)
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }
                                        .padding(.top, 30)
                    
                    
                    
                    
                     
                    VStack{
                        HStack{
                            Text("GENRE")
                                .font(Font.custom("SF Pro Text", size: 10))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.leading,3)
                            
                            
                            
                            
                            Text("RELEASED")
                                .font(Font.custom("SF Pro Text", size: 10))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.leading,38)
                            
                            Text("LANGUAGE")
                                .font(Font.custom("SF Pro Text", size: 10))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.leading,38)
                            
                            
                            Text("LENGTH")
                                .font(Font.custom("SF Pro Text", size: 10))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.leading,38)
                                .padding(.trailing,22)
                            
                            
                        }
                        .padding(.top,30)
                        
                        HStack{
                            Image(systemName: "theatermasks")
                                .font(
                                    Font.custom("SF Pro Text", size: 12)
                                        .weight(.semibold)
                                )
                                .foregroundColor(.white)
                                .padding(.leading,3)
                            
                            Text("2013")
                              .font(
                                Font.custom("SF Pro Text", size: 12)
                                  .weight(.bold)
                              )
                              .foregroundColor(.white)
                              .padding(.leading,68)
                            
                            
                            Text("EN")
                              .font(
                                Font.custom("SF Pro Text", size: 12)
                                  .weight(.semibold)
                              )
                              .foregroundColor(.white)
                              .padding(.leading,68)
                              
                            
                            
                            Text("544")
                              .font(
                                Font.custom("SF Pro Text", size: 12)
                                  .weight(.semibold)
                              )
                              .foregroundColor(.white)
                              .padding(.leading,68)
                              .padding(.trailing,22)
                        }.padding(.top,10)
                        
                        HStack{
                            Text("Comedy")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.leading,3)
                            
                            Text("11 June")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.leading,55)
                            
                            Text("English")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.leading,55)
                              
                            
                            Text("Pages")
                              .font(Font.custom("SF Pro Text", size: 10))
                              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                              .padding(.leading,55)
                        }
                        .padding(.top,10)
                        
                        
                        Text("Summary")
                          .font(
                            Font.custom("SF Pro Text", size: 14)
                              .weight(.semibold)
                          )
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity, alignment: .topLeading)
                          .padding(.leading,25)
                          .padding(.top,30)
                        
                        
                    }
                    .padding(.bottom,30)
                    
                    
                }.padding(.bottom,180)
            }
        }
    }
}
struct MBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MBookDetailView()
    }
}


