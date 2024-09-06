//
//  RegistrationName.swift
//  Numo test1
//
//  Created by Тасік on 02.04.2024.
//

import SwiftUI
import URLImage

struct RegistrationName: View {
    @AppStorage("uid") var userID: String = ""
    @State private var name: String = ""
    
    var fromSettings : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var userData = UserData()
    @StateObject private var userViewModel = UsersViewModel()
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !name.isEmpty
    }
    
    @State private var navigateToRegistrationSex = false
    
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
                        .frame(width : 47, height: 8, alignment: .leading)
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
               
                Text("Крок 4")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
                
                
                
                
                Text("Як тебе звати?")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .padding(.bottom,65)
                .padding(.horizontal,16)
                
                InputField(text: $name, placeholder: "Введи своє імʼя", isSecure: false, baseString: "Тарас", state: .constant(.passive), isPasswordVisible: .constant(true))
                    .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action:{
                    if isAllowedContinue{
                        navigateToRegistrationSex = true
                        if fromSettings{
                            userData.updateUser(data: ["name": name , "registrationStage": "done"])
                        }else{
                            userData.updateUser(data: ["name": name , "registrationStage": "sex"])
                        }
                        
                        userViewModel.partialUpdateUser(userId: userID, data: ["name": name] )
                        
                    }
                }){
                    SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.bottom,110)
                    .padding(.horizontal,30)
                }.fullScreenCover(isPresented: $navigateToRegistrationSex, content: {
                    if fromSettings {
                        ProfileSettings()
                    }else{
                        RegistrationSex()
                    }
                    
                })
            }
            .padding(.top, 29)
    }
}

#Preview {
    RegistrationName()
}
