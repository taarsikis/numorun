//
//  LoginView.swift
//  Numo test1
//
//  Created by Тасік on 29.03.2024.
//

import SwiftUI
import URLImage
import FirebaseAuth

struct LoginView: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool? = false // To control password visibility
    
    @State private var navigateToRegistration = false
    
    @State private var navigateToRestorePassword = false
    private var isAllowedLogin: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !email.isEmpty && !password.isEmpty
    }
    
    @StateObject var userData = UserData()
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Вхід")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .padding([.bottom, .horizontal], 35)
                .padding(.top, 179)
            
            InputField(text: $email, placeholder: "Електронна адреса", imageName: "mail", isSecure: false, baseString: "numo@gmail", state: .constant(.passive), isPasswordVisible: .constant(false))
                .padding(.bottom, 16)
                .padding(.horizontal, 35)
            
            InputField(text: $password, placeholder: "Пароль", imageName: "lock-closed", isSecure: true, baseString: "NuMo345$s_df", state: .constant(.passive), isPasswordVisible: $isPasswordVisible)
                .padding(.bottom, 9)
                .padding(.horizontal, 35)
            
            HStack {
                Spacer()
                Button(action:{
                    navigateToRestorePassword = true
                }) {
                    Text("Забув пароль")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 12))
                        .padding(.bottom, 212)
                    .padding(.horizontal, 56)
                }.fullScreenCover(isPresented: $navigateToRestorePassword, content: {
                    RestorePasswordEmailView()
                })
            }
            
            Spacer()
            
            Button(action: {
                if isAllowedLogin {
                    print("Attempt to log in with email: \(email) and password: \(password)")
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                            if let error = error {
                                                print(error)
                                                return
                                            }
                                            
                                            if let authResult = authResult {
                                                print("sda" + authResult.user.uid)
                                                
                                                withAnimation {
                                                userID = authResult.user.uid
                                                
                                                }
                                            }
                                            
                                            
                                        }
                } else {
                    print("ВВедіть пароль чи пошту")
                }
            }) {
                SuccessButtonView(title: "Увійти", isAllowed: isAllowedLogin, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
            }
            .padding([.horizontal], 30)
            .padding(.bottom, 10)
            
            HStack {
                Text("Не зареєстрований?")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 16))
                
                Spacer()
                
                Button(action: {
                    // TODO
                    navigateToRegistration = true
                    
                }) {
                    Text("Реєстрація")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 16))
                }.fullScreenCover(isPresented: $navigateToRegistration, content: {
                    RegistrationEmail()
                })
            }
            .frame(maxWidth: .infinity, maxHeight: 16)
            .padding([.bottom, .horizontal], 62)
            
        }
    }
}




#Preview {
    LoginView()
}
