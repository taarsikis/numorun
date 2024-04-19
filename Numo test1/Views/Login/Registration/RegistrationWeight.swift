//
//  RegistrationWeight.swift
//  Numo test1
//
//  Created by Тасік on 03.04.2024.
//

import SwiftUI

struct RegistrationWeight: View {
    
    @State private var weight: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !weight.isEmpty
    }
    
    @State private var navigateToRegistrationExperience = false
    
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
                    .frame(width : 105, height: 8, alignment: .leading)
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
           
            Text("Крок 7")
            .foregroundColor(Color(hex: "#07B29D"))
            .font(.system(size: 20))
            .padding(.bottom,56)
            .padding(.horizontal,160)
            
            
            
            
            Text("Яка у тебе\nвага?")
            .foregroundColor(Color(hex: "#1B1C1C"))
            .font(.system(size: 40))
            .padding(.bottom,16)
            .padding(.horizontal,16)
            
            InputField(text: $weight, placeholder: "Введи свою вагу", isSecure: false, baseString: "88", state: .constant(.passive), isPasswordVisible: .constant(true))
                .padding(.horizontal, 16)
            
            Spacer()
            
            Button(action:{
                if isAllowedContinue{
                    
                    navigateToRegistrationExperience = true
                    let res_weight : Double
                    if let doubleValue = Double(weight) {
                                        res_weight = doubleValue
                                    } else {
                                        // Handle invalid input
                                        res_weight = 0
                                        navigateToRegistrationExperience = false
                                    }
                    userData.updateUser(data: ["weight": weight , "registrationStage": "experience"])
                }
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                .padding(.horizontal,30)
            }.fullScreenCover(isPresented: $navigateToRegistrationExperience, content: {
                RegistrationExperience()
            })
            .padding(.bottom, 10.5)
            
            Button(action:{
                navigateToRegistrationExperience = true
                userData.updateUser(data: [ "registrationStage": "experience"])
            }){
                Spacer()
                Text("Бажаю не вказувати")
                    .foregroundColor(Color(hex: "#07B29D"))
                    .font(.system(size: 16))
                Spacer()
                
            }.fullScreenCover(isPresented: $navigateToRegistrationExperience, content: {
                RegistrationExperience()
            })
            .padding(.bottom,97.5)
            .padding(.horizontal,86)
        }
        .padding(.top, 29)
    }
}

#Preview {
    RegistrationWeight()
}
