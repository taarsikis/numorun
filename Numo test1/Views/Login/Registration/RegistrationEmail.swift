//
//  RegistrationEmail.swift
//  Numo test1
//
//  Created by Тасік on 29.03.2024.
//

import SwiftUI
import URLImage

struct RegistrationEmail: View {
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToRegistrationPassword = false
    @State private var isValidEmail : Bool = true
    @State private var forceRefresh: Bool = false
    @State private var inputState: FieldState = .passive
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !email.isEmpty
    }
    

    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                            HStack {
                                Button(action:{
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
                                            .frame(width : 15, height: 8, alignment: .leading)
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
                
                
                Text("Крок 1")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
                
                Text("Введи свою\nпошту")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,26)
                .padding(.horizontal, 16)
                
                InputField(text: $email, placeholder: "Електронна адреса", imageName: "mail", isSecure: false, baseString: "numo@gmail", state: $inputState, hint: isValidEmail ? "": "Ця електронна адреса введена неправильно, або ж вона вже використовується",  isPasswordVisible: .constant(false))
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action: {
                    if !email.isValidEmail(){
                        inputState = .error
                        isValidEmail = false
                    }else{
                        inputState = .success
                        isValidEmail = true
                    }
                    
                    
                    if isAllowedContinue && email.isValidEmail(){
                        navigateToRegistrationPassword = true
                    }
                }){
                    SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 89)
                }.fullScreenCover(isPresented: $navigateToRegistrationPassword, content: {
                    RegistrationPassword(email: $email)
                })
            }
            .padding(.top, 29)

    }
}

#Preview {
    RegistrationEmail()
}
