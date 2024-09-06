//
//  ProfileSettings.swift
//  Numo test1
//
//  Created by Тасік on 02.05.2024.
//

import SwiftUI
import URLImage

func ss(w: CGFloat) -> CGFloat{
    let width = UIScreen.main.bounds.size.width;
    return (w * width) / 391
}

func calculateAge(from dateOfBirth: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
    return ageComponents.year ?? 0
}

struct ProfileSettings: View {
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var navigateToRegistrationName = false
    @State private var navigateToRegistrationWeight = false
    @State private var navigateToRegistrationDate = false
    @State private var navigateToRegistrationExperience = false
    @State private var navigateToRestorePassword = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    
    
    @State private var navigateToProfileView = false
    
    @StateObject var userData = UserData()
    
    @StateObject private var userViewModel = UsersViewModel()
    
    private var experience : String{
        if userViewModel.user?.experience == 1{
            return "Початківець"
        }else if userViewModel.user?.experience == 2{
            return "Досвідчений"
        }else if userViewModel.user?.experience == 3{
            return "Експерт"
        }else{
            return ""
        }
    }
    
    var body: some View {
//        ScrollView {
                VStack(alignment: .leading, spacing: 0){
                    ZStack {
                        HStack {
                            Button(action: {
                                self.navigateToProfileView = true
                            }){
                                Image("arrow-sm-left") // Your arrow image
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 16) // Apply leading padding here
                            }.fullScreenCover(isPresented: $navigateToProfileView, content: {
                                ContentView()
                            })
                            
                            
                            Spacer() // Ensures the arrow stays at the leading edge
                        }
                        
                        Text("Редагування")
                            .foregroundColor(Color(hex: "#000000"))
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 18)
                    
                    ScrollView{
                        VStack(alignment: .leading, spacing: 0){
                            Group {
                                Text("Мої дані")
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 20))
                                    .padding(.bottom,ss(w: 10))
                                    .padding(.horizontal,ss(w: 18))
                                
                                
                                Button(action:{
                                    self.navigateToRegistrationName = true
                                }){
                                    SettingsButton(text:"Ім’я", imageName: "cheveron-right-b", previewText:  userViewModel.user?.name)
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToRegistrationName, content: {
                                    RegistrationName(fromSettings: true)
                                })
                                
                                Button(action:{
                                    self.navigateToRegistrationWeight = true
                                }){
                                    SettingsButton(text:"Вага", imageName: "cheveron-right-b", previewText: "\(Int(userViewModel.user?.weight ?? 0))" )
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToRegistrationWeight, content: {
                                    RegistrationWeight(fromSettings: true)
                                })
                                    
                                    
                                Button(action:{
                                    self.navigateToRegistrationDate = true
                                }){
                                    SettingsButton(text:"Вік", imageName: "cheveron-right-b", previewText: "\(calculateAge(from: userViewModel.user?.date_of_birth.toDate(withFormat: "yyyy-MM-dd") ?? Date()))")
                                    
                                
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToRegistrationDate, content: {
                                    RegistrationDate(fromSettings: true)
                                })
                                
                                Button(action:{
                                    self.navigateToRegistrationExperience = true
                                }){
                                    SettingsButton(text:"Досвід", imageName: "cheveron-right-b", previewText: experience)
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToRegistrationExperience, content: {
                                    RegistrationExperience(fromSettings: true)
                                })
                            }
                            
                            
                            
                            Group {
                                Text("Налаштування")
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 20))
                                    .padding(.bottom,ss(w: 10))
                                    .padding(.horizontal,ss(w: 18))
                                    .padding(.top, ss(w:36))
                                
                                
                                Button(action:{
                                    // TODO
                                    navigateToRestorePassword = true
                                }){
                                    SettingsButton(text:"Змінити пароль", imageName: "lock-closed")
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToRestorePassword, content: {
                                    RestorePasswordEmailView()
                                })
                                
                                Button(action:{
                                    // TODO
                                }){
                                    SettingsButton(text:"Мова", imageName: "flag", disabled : true)
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }
                                
                                Button(action:{
                                    // TODO
                                }){
                                    SettingsButton(text:"Сповіщення", imageName: "bell", disabled : true)
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }
                            }
                            
                            
                            Group {
                                Text("Конфіденційність")
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 20))
                                    .padding(.bottom,ss(w: 10))
                                    .padding(.horizontal,ss(w: 18))
                                    .padding(.top, ss(w:36))
                                
                                Button(action:{
                                    showTermsOfUse.toggle()
                                }){
                                    SettingsButton(text:"Умови використання", imageName: "document-text")
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.sheet(isPresented: $showTermsOfUse) {
                                    WebView(htmlFileName: "terms-of-use")
                                        .navigationBarTitle("Terms of Use", displayMode: .inline)
                                }
                                
                                Button(action:{
                                    showPrivacyPolicy.toggle()
                                }){
                                    SettingsButton(text:"Політика конфіденційності", imageName: "document-text")
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }.sheet(isPresented: $showPrivacyPolicy) {
                                    WebView(htmlFileName: "privacy_policy")
                                        .navigationBarTitle("Privacy Policy", displayMode: .inline)
                                }
                            }
                            
                            
                            
                            Group {
                                Text("Акаунт")
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 20))
                                    .padding(.bottom,ss(w: 10))
                                    .padding(.horizontal,ss(w: 16))
                                    .padding(.top, ss(w:36))
                                
                                Button(action:{
                                    // TODO
                                }){
                                    SettingsButton(text:"Видалити акаунт", imageName: "trash", disabled : true)
                                        .padding(.bottom,ss(w: 8))
                                        .padding(.horizontal,ss(w: 16))
                                }
                            }
                            
                            
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onAppear {
                    // Call getUserByID when the view appears to retrieve user data
                    userData.fetchUser(userId: self.userID)
                    userViewModel.getUser(userId: self.userID)
                }
                .onChange(of: navigateToRegistrationName) { _ in
                    userData.fetchUser(userId: self.userID)
                    userViewModel.getUser(userId: self.userID)
                }
                .onChange(of: navigateToRegistrationWeight) { _ in
                    userData.fetchUser(userId: self.userID)
                    userViewModel.getUser(userId: self.userID)
                }
                .onChange(of: navigateToRegistrationDate) { _ in
                    userData.fetchUser(userId: self.userID)
                    userViewModel.getUser(userId: self.userID)
                }
                .onChange(of: navigateToRegistrationExperience) { _ in
                    userData.fetchUser(userId: self.userID)
                    userViewModel.getUser(userId: self.userID)
                }

            }
            
//    }
}


#Preview {
    ProfileSettings()
}
