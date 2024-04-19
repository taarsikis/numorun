//
//  RegistrationExperience.swift
//  Numo test1
//
//  Created by Тасік on 03.04.2024.
//

import SwiftUI

struct RegistrationExperience: View {
    
    @State private var experience: String = ""
    @State private var isBeginer: Bool = false
    @State private var isExperienced: Bool = false
    @State private var isExpert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !experience.isEmpty
    }
    
    @State private var navigateToEndOfRegistration = false
    
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
                
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(height: 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#07B29D"))
                    .cornerRadius(30)
                    .padding(.top,1)
                }
                .padding(.horizontal,1)
                .frame(width : 122, height: 9, alignment: .leading)
                .background(Color(hex: "#B2E7E1"))
                .cornerRadius(30)
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            Text("Крок 8")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
            
            
            
            
            Text("Наскільки ти\nдосвідчений?")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .padding(.bottom,16)
                .padding(.horizontal,16)
            
            Button(action: {
                experience = "beginner"
                isBeginer = true
                isExperienced = false
                isExpert = false
            }){
                VStack(spacing: 0){
                    Text("Я новачок")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 20))
                }
                .padding(.vertical,16)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color(hex: isBeginer ? "#DAF3F0" :"#FFFFFF" ))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: isBeginer ? "#068E7E" : "#07B29D"), lineWidth: 1))
                .padding(.bottom,12)
                .padding(.horizontal,30)
            }
            
            Button(action: {
                experience = "experienced"
                isBeginer = false
                isExperienced = true
                isExpert = false
            }){
                VStack(spacing: 0){
                    Text("Я маю небагато досвіду")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 20))
                }
                .padding(.vertical,16)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color(hex: isExperienced ? "#DAF3F0" :"#FFFFFF" ))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: isExperienced ? "#068E7E" : "#07B29D"), lineWidth: 1))
                .padding(.bottom,12)
                .padding(.horizontal,30)
            }
             
            Button(action: {
                experience = "expert"
                isBeginer = false
                isExperienced = false
                isExpert = true
            }){
                VStack(spacing: 0){
                    Text("Я досвідчений")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 20))
                }
                .padding(.vertical,16)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color(hex: isExpert ? "#DAF3F0" :"#FFFFFF" ))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: isExpert ? "#068E7E" : "#07B29D"), lineWidth: 1))
                .padding(.bottom,12)
                .padding(.horizontal,30)
            }
            
            
            
            Spacer()
            
            Button(action:{
                if isAllowedContinue{
                    navigateToEndOfRegistration = true
                    userData.updateUser(data: ["experience": experience , "registrationStage": "done"])
                }
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.horizontal,30)
            }.fullScreenCover(isPresented: $navigateToEndOfRegistration, content: {
                ProfileView()
            })
            .padding(.bottom,97.5)
        }
        .padding(.top, 29)
    }
}

#Preview {
    RegistrationExperience()
}
