//
//  CreationPace.swift
//  Numo test1
//
//  Created by Тасік on 14.05.2024.
//

import SwiftUI

struct CreationPace: View {
    @State private var minutes: String = "5"
    @State private var seconds: String = "00"
    @State var state: FieldStateNum = .active
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    
    @Binding var challengeDetails : Challenge
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !minutes.isEmpty && !seconds.isEmpty && hint == ""
    }
    
    private var hint:  String{
        
        let seconds = Int(self.seconds) ?? -1
        let minutes = Int(self.minutes) ?? -1
        
        if seconds > 59 {
            return "У хвилині всього 60 секунд"
        }
        
        if seconds == -1 || minutes == -1 {
            return "Ви ввели невірне значення"
        }
        
        if seconds + minutes*60 < 130{
            return "Ви ввели надто велику швидкість."
        }
        
        if seconds + minutes*60 >= 840{
            return "Це надто повільно. Мінімальна швидкість - 14хв/км"
        }
        
        return ""
        
    }
    
    @State private var navigateToCreationCalendar = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image("arrow-sm-left") // Your arrow image
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16) // Apply leading padding here
                    }
                    
                    Spacer() // Ensures the arrow stays at the leading edge
                }
                
                Text("Який найповільніший темп?")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                
                
                Spacer()
            }
            .frame(height: ss(w: 24))
            .frame(maxWidth: .infinity)
            .padding(.bottom,ss(w: 36))
            .padding(.top, ss(w: 35))
            
            
            HStack {
                Spacer()
                Text(String(self.challengeDetails.name.prefix(1))) // Get the first letter of the challenge name
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .frame(width: ss(w: 80), height: ss(w: 80)) // Circle dimensions
                            .background(backgroundColors[( 4) % backgroundColors.count]) // Choose the background color you like
                            .clipShape(Circle()) // Make it circular
                            .padding(.bottom,ss(w:20))
                
                Spacer()
            }
            HStack {
                Spacer()

                Text(self.challengeDetails.name)
                    .foregroundColor(Color(hex: "#5D5E5E"))
                    .font(.system(size: 16))
                    .padding(.bottom,ss(w: 39))
                Spacer()

            }
            
            
            Spacer()
                
            
            PaceInput(minutes: $minutes, seconds: $seconds, state: .constant(.active))
            .padding(.horizontal,ss(w: 20))
            
            HStack{
                Spacer()
                Text(hint)
                    .font(.caption)
                    .foregroundColor(Color(hex: "EB6048"))
                    .padding(.top, 4)
                Spacer()
            }
                
            Spacer()
                
                
            Button(action: {
                if isAllowedContinue{
                    navigateToCreationCalendar = true
                    self.challengeDetails.slowest_pace = (Int(self.minutes) ?? 0) * 60 + (Int(self.seconds) ?? 0)
            
                }
            }){
                SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.bottom,ss(w:40))
                    .padding(.horizontal, ss(w:30))
            }.fullScreenCover(isPresented: $navigateToCreationCalendar, content: {
                CreationCalendar(challengeDetails: self.$challengeDetails)
            })
//            }
//            .padding(.top,ss(w: 84))
//            .padding(.bottom,ss(w: 8))
//            .frame(height: ss(w: 396))
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color(hex: "#FDFDFD"))
            //                .cornerRadius(20)
            
        }
//        .background(Color(hex: "#F6F6F6"))
        .cornerRadius(20)
        
    }
}


//#Preview {
//    CreationPace()
//}
