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
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Профіль")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 32))
                .padding(.top, 12)
                .padding(.horizontal,16)
            
            HStack {
                Spacer()
                Image("avatar_full")
                    .resizable()
                    .scaledToFill() // Ensure the image covers the circle's area without distorting aspect ratio
                    .frame(width: 96, height: 96) // Define both width and height to make the view square
                    .clipShape(Circle()) // Clip the image into a circle
                    .padding(.bottom, 20)
                .padding(.horizontal, 146)
                
                Spacer()
            } // You might need to adjust this padding depending on your layout

            
            HStack{
                Spacer()
                Text(userData.user?.name ?? "")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 32))
                    .padding(.bottom,20)
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                        Text("Моя Статистика")
                            .foregroundColor(Color(hex: "#FDFDFD"))
                            .font(.system(size: 18))
                            .padding(.bottom,3)
                        Text("Перевір власний прогрес")
                            .foregroundColor(Color(hex: "#FDFDFD"))
                            .font(.system(size: 16))
                    }
                    .frame(height: 37)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing,4)
                    
                    Button(action:{
                        // TODO
                    }){
                        Image("cheveron-right")
                            .resizable()
                            .scaledToFill()
                            .frame(width : 24, height: 24)
                    }
                }
                .frame(height: 37)
                .frame(maxWidth: .infinity)
                .padding(.bottom,5)
                HStack(alignment: .top, spacing: 0){
                    
                    Button(action:{
                        // TODO
                    }){
                        VStack(spacing: 0){
                            Text("Переглянути")
                                .foregroundColor(Color(hex: "#1B1C1C"))
                                .font(.system(size: 12))
                        }
                        .padding(.vertical,13)
                        .frame(width : 113, height: 38)
                        .background(Color(hex: "#FDFDFD"))
                        .cornerRadius(12)
                        
                    }.padding(.top,35)
                    .padding(.trailing,96)
                    
                    Spacer()
                    
                    Image("Illustration")
                            .resizable()
                            .frame(width : 121, height: 67)
                    
                    Spacer()
                }
                .frame(height: 73)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .padding(.vertical,23)
            .padding(.horizontal,14)
            .frame(height: 161)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#07B29D"))
            .cornerRadius(12)
            .padding(.bottom,30)
            .padding(.horizontal,16)
            Text("Налаштування")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 20))
                .padding(.bottom,6)
                .padding(.horizontal,18)
            
            Button(action:{
                
            }){
                SettingsButton(text:"Редагувати профіль", imageName: "cog")
                    .padding(.bottom,8)
                    .padding(.horizontal,16)
            }
            
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
            
            
            
            NavigationBarView()
            
            
        }.onAppear {
            // Call getUserByID when the view appears to retrieve user data
            userData.fetchUser(userId: self.userID)
        }
        
    }
}

#Preview {
    ProfileView()
}
