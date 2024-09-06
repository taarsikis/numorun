//
//  ProfileView.swift
//  Numo test1
//
//  Created by Тасік on 05.04.2024.
//

import SwiftUI
import URLImage
import FirebaseAuth



struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    
    
    @StateObject var userData = UserData()
    @StateObject private var userViewModel = UsersViewModel()

    @State private var navigateToSettings = false
    @State private var navigateToRuns = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Профіль")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 32))
                .padding(.top, 12)
                .padding(.horizontal,16)
            
            HStack {
                Spacer()
                Text(String(userData.user?.name.prefix(1) ?? "N")) // Get the first letter of the challenge name
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .frame(width: ss(w: 96), height: ss(w: 96)) // Circle dimensions
                            .background(backgroundColors[( 4) % backgroundColors.count]) // Choose the background color you like
                            .clipShape(Circle()) // Make it circular
                            .padding(.bottom,ss(w:10))
                

                
                Spacer()
            } // You might need to adjust this padding depending on your layout

            
            HStack{
                Spacer()
                Text(userViewModel.user?.name ?? "")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 32))
                    .padding(.bottom,20)
                Spacer()
                
            }
            
//              Добавиться коли буде добавлена статистика для користувачів
            
//            VStack(alignment: .leading, spacing: 0){
//                HStack(spacing: 0){
//                    VStack(alignment: .leading, spacing: 0){
//                        Text("Моя Статистика")
//                            .foregroundColor(Color(hex: "#FDFDFD"))
//                            .font(.system(size: 18))
//                            .padding(.bottom,3)
//                        Text("Перевір власний прогрес")
//                            .foregroundColor(Color(hex: "#FDFDFD"))
//                            .font(.system(size: 16))
//                    }
//                    .frame(height: 37)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.trailing,4)
//                    
//                    Button(action:{
//                        // TODO
//                    }){
//                        Image("cheveron-right")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width : 24, height: 24)
//                    }
//                }
//                .frame(height: 37)
//                .frame(maxWidth: .infinity)
//                .padding(.bottom,5)
//                HStack(alignment: .top, spacing: 0){
//                    
//                    Button(action:{
//                        // TODO
//                    }){
//                        VStack(spacing: 0){
//                            Text("Переглянути")
//                                .foregroundColor(Color(hex: "#1B1C1C"))
//                                .font(.system(size: 12))
//                        }
//                        .padding(.vertical,13)
//                        .frame(width : 113, height: 38)
//                        .background(Color(hex: "#FDFDFD"))
//                        .cornerRadius(12)
//                        
//                    }.padding(.top,35)
//                    .padding(.trailing,96)
//                    
//                    Spacer()
//                    
//                    Image("Illustration")
//                            .resizable()
//                            .frame(width : 121, height: 67)
//                    
//                    Spacer()
//                }
//                .frame(height: 73)
//                .frame(maxWidth: .infinity, alignment: .top)
//            }
//            .padding(.vertical,23)
//            .padding(.horizontal,14)
//            .frame(height: 161)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color(hex: "#07B29D"))
//            .cornerRadius(12)
//            .padding(.bottom,30)
//            .padding(.horizontal,16)
            
            Text("Налаштування")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 20))
                .padding(.bottom,6)
                .padding(.horizontal,18)
            
            Button(action:{
                navigateToSettings = true
            }){
                SettingsButton(text:"Редагувати профіль", imageName: "cog")
                    .padding(.bottom,8)
                    .padding(.horizontal,16)
            }.fullScreenCover(isPresented: $navigateToSettings, content: {
                ProfileSettings()
            })
            
            Button(action:{
                navigateToRuns = true
            }){
                SettingsButton(text:"Переглянути пробіжки", imageName: "Fire Icon")
                    .padding(.bottom,8)
                    .padding(.horizontal,16)
            }.fullScreenCover(isPresented: $navigateToRuns, content: {
                ProfileUserRuns()
            })
            
            Button(action:{
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation {
                        userID = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                SettingsButton(text:"Вийти", imageName: "logout")
                .padding(.bottom,8)
            .padding(.horizontal,16)
            }
            
            Spacer()
            
            
            
//            NavigationBarView(selectedTabIndex: .constant(1))
            
            
        }.onAppear {
            // Call getUserByID when the view appears to retrieve user data
            userData.fetchUser(userId: self.userID)
            userViewModel.getUser(userId: self.userID)
        }
        
    }
}

#Preview {
    ProfileView()
}
