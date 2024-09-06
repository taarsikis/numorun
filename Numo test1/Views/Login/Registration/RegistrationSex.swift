//
//  RegistrationSex.swift
//  Numo test1
//
//  Created by Тасік on 03.04.2024.
//

import SwiftUI
import URLImage

struct RegistrationSex: View {
    @State private var sex : String = ""
    @State private var isMale: Bool = false
    @State private var isFemale: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var userData = UserData()
    @StateObject private var userViewModel = UsersViewModel()
    @AppStorage("uid") var userID: String = ""
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !sex.isEmpty
    }
    
    @State private var navigateToRegistrationDate = false
    
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
                    .frame(width : 79, height: 8, alignment: .leading)
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
            
            Text("Крок 5")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
            
            Text("Якої ти статі?")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .padding(.bottom,16)
                .padding(.horizontal,16)
            
            HStack(spacing: 0){
                Button(action:{
                    sex = "male"
                    isMale = true
                    isFemale = false
                }){
                    Image(isMale ? "Male_chosen" : "Male" )
                        .resizable()
                        .frame(width:142, height: 196)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Button(action:{
                    sex = "female"
                    isMale = false
                    isFemale = true
                }){
                    Image(isFemale ? "Female_chosen" : "Female")
                        .resizable()
                        .frame(width: 142,height: 196)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(height: 196)
            .frame(maxWidth: .infinity)
            .padding(.bottom,10)
            .padding(.horizontal,39)
            
            
            HStack {
                Spacer()
                Text("Щоб надати тобі гнучкішу систему тренувань\nнам потрібно знати твою стать ")
                    .foregroundColor(Color(hex: "#4F5050"))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal,53)
                Spacer()
            }
            
            Spacer()
            
            Button(action:{
                if isAllowedContinue{
                    navigateToRegistrationDate = true
                    
                    userData.updateUser(data: ["sex": sex , "registrationStage": "date"])
                    userViewModel.partialUpdateUser(userId: self.userID, data: ["sex": sex])
                }
                
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 6.5)
            }.fullScreenCover(isPresented: $navigateToRegistrationDate, content: {
                RegistrationDate()
            })
            
            Button(action:{
                navigateToRegistrationDate = true
                
                userData.updateUser(data: [ "registrationStage": "date"])
            }){
                Spacer()
                Text("Бажаю не вказувати")
                    .foregroundColor(Color(hex: "#07B29D"))
                    .font(.system(size: 16))
                Spacer()
                
            }.fullScreenCover(isPresented: $navigateToRegistrationDate, content: {
                RegistrationDate()
            })
            .padding(.bottom,97.5)
                .padding(.horizontal,86)
        }
        .padding(.top, 29)
        
    }
}

#Preview {
    RegistrationSex()
}
