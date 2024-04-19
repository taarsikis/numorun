//
//  RegistrationPassword.swift
//  Numo test1
//
//  Created by Тасік on 29.03.2024.
//

import SwiftUI
import URLImage
import FirebaseAuth

struct RegistrationPassword: View {
    
    @AppStorage("uid") var userID: String = ""
    @Binding var email : String
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var isPasswordVisible: Bool? = false // To control password visibility
    @State private var isRepeatedPasswordVisible: Bool? = false // To control password visibility
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !password.isEmpty && !repeatedPassword.isEmpty && password == repeatedPassword
    }
    
    @State private var navigateToRegistrationName = false
    
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
            
            
            Text("Крок 3")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
            Text("Придумай\nпароль")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,26)
                .padding(.horizontal,16)
            
            
            InputField(text: $password, placeholder: "Придумай пароль", imageName: "lock-closed", isSecure: true, baseString: "******", state: .constant(.passive), isPasswordVisible: $isPasswordVisible)
                .padding(.bottom, 9)
                .padding(.horizontal, 16)
            
            InputField(text: $repeatedPassword, placeholder: "Повтори введений пароль", imageName: "lock-closed", isSecure: true, baseString: "******", state: .constant(.passive), isPasswordVisible: $isRepeatedPasswordVisible)
                .padding(.bottom, 9)
                .padding(.horizontal, 16)
         
                Spacer()
            
            Button(action:{
                if isAllowedContinue{
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                            userData.addUser(email: email, name: authResult.user.uid, dateOfBirth: Date(),sex: "", weight: 0.0, experience: "", registrationStage: "name")
                            
                        }
                    }
                    navigateToRegistrationName = true
                }
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                .padding(.bottom,110)
                .padding(.horizontal,30)
            }.fullScreenCover(isPresented: $navigateToRegistrationName, content: {
                RegistrationName()
            })
                
        }
        .padding(.top, 29)
        
    }
}

#Preview {
    
    RegistrationPassword(email: .constant("Test@gmail.com"))
}
