//
//  RestorePasswordEmailView.swift
//  Numo test1
//
//  Created by Тасік on 03.04.2024.
//

import SwiftUI

struct RestorePasswordEmailView: View {
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToRegistrationPassword = false
    
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

                            
                                        Spacer()
                        }
                        .frame(maxWidth: .infinity)
                
                
                
                Text("Відновлення\nпаролю")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 117)
                .padding(.bottom,26)
                .padding(.horizontal, 16)
                
                InputField(text: $email, placeholder: "Електронна адреса", imageName: "mail", isSecure: false, baseString: "numo@gmail", state: .constant(.passive), isPasswordVisible: .constant(false))
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                Spacer()
                
                Button(action: {
                    if isAllowedContinue{
                        navigateToRegistrationPassword = true
                    }
                }){
                    SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 89)
                }.fullScreenCover(isPresented: $navigateToRegistrationPassword, content: {
                    RegistrationEmail()
                })
            }
            .padding(.top, 29)

    }
}

#Preview {
    RestorePasswordEmailView()
}
