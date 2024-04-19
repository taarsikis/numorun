//
//  WelcomeView.swift
//  Numo test1
//
//  Created by Тасік on 29.03.2024.
//

import SwiftUI
import URLImage

struct WelcomeView: View {
    @State private var navigateToLogin = false
    @State private var navigateToRegistration = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Group{
                    
                    Image("NumoLogo")
                        .resizable()
                        .frame(height: 56)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom,33)
                        .padding(.horizontal,161)
                        .padding(.top, 64)
                    
                    Text("Вітаємо в \nNUMO")
                    .font(.system(size: 48))
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom,15)
                    .padding(.horizontal,70)
                    Text("Додаток, що перетворює\nспорт у гру")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom,43)
                    .padding(.horizontal,39)
                    Image("WelcomePageMainImage")
                        .resizable()
                        .frame(height: 241)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom,83)
                        .padding(.horizontal,31)
                }
                Group{
                    Button(action: {
                        // TODO Перехід на екран
                        navigateToRegistration = true
                    }){
                        SuccessButtonView(title: "Зареєструватися", isAllowed: true, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
                        .padding(.bottom,10)
                        .padding(.horizontal,30)
                        
                    }.fullScreenCover(isPresented: $navigateToRegistration, content: {
                        RegistrationEmail()
                    })
                    HStack(spacing: 0){
                        
                        Text("Вже маєш акаунт?")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 16))
                        Spacer()
                        Button(action: {
                            navigateToLogin = true
                            // TODO Перехід на екран
                        }){
                            Text("Вхід")
                            .foregroundColor(Color(hex: "#07B29D"))
                            .font(.system(size: 16))
                        }.fullScreenCover(isPresented: $navigateToLogin, content: {
                            LoginView()
                        })
                        
                    }
                    .frame(height: 16)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,79)
                    .padding(.horizontal,101)
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(height: 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#1B1C1C"))
                    .cornerRadius(100)
                    .padding(.horizontal,128)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(hex: "#FDFDFD"))
            .cornerRadius(26)
            .padding(.top, 15)

    }
}

#Preview {
    WelcomeView()
}
