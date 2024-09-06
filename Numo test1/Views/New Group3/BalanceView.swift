//
//  BalanceView.swift
//  Numo test1
//
//  Created by Тасік on 14.08.2024.
//

import SwiftUI
import URLImage

struct BalanceView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject private var userViewModel = UsersViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
          ScrollView(){
            VStack(alignment: .leading, spacing: 0) {
              Text("Баланс")
                .foregroundColor(Color(hex: "#000000"))
                .font(.system(size: 32))
                .padding(.bottom,25)
                .padding(.leading,20)
                HStack {
                    Spacer()
                    Text("Твій баланс")
                    .foregroundColor(Color(hex: "#5D5E5E"))
                    .font(.system(size: 18))
                    .padding(.bottom,23)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("₴\(userViewModel.user?.balance ?? 0)")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 40))
                    .padding(.bottom,45)
                    Spacer()
                }
              HStack(spacing: 0){
                  Button(action:{
                      // TODO
                  }) {
                      VStack(spacing: 0){
                      Text("Поповнити")
                        .foregroundColor(Color(hex: "#FDFDFD"))
                        .font(.system(size: 16))
                    }
                    .padding(.vertical,15)
                    .frame(width : 167)
                    .background(Color(hex: "#07B29D"))
                .cornerRadius(12)
                  }
                Spacer()
                  Button(action:{
                      // TODO
                  }) {
                      VStack(spacing: 0){
                      Text("Вивести")
                        .foregroundColor(Color(hex: "#07B29D"))
                        .font(.system(size: 16))
                    }
                    .padding(.vertical,15)
                    .frame(width : 167)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#07B29D"), lineWidth: 1))
                  }
              }
              .frame(maxWidth: .infinity)
              .padding(.bottom,48)
              .padding(.horizontal,15)
                
                Text("Історія транзакцій")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 25))
                    .padding(.bottom,ss(w: 12))
                    .padding(.leading,ss(w: 12))
                
                VStack(alignment: .leading, spacing: 0){
                Text("Субота, 27 травня, 2023")
                  .foregroundColor(Color(hex: "#5D5E5E"))
                  .font(.system(size: 12))
                  .padding(.bottom,7)
                  .padding(.leading,17)
                HStack(spacing: 0){
                  VStack(alignment: .leading, spacing: 0){
                      Image("arrow-narrow-right-up")
                        .frame(width: 20, height: 20)
                        .padding(.top,5)
                      .padding(.bottom,5)
                    
                  }
                  .padding(.horizontal,15)
                  .frame(width : 44, alignment: .leading)
                  .background(Color(hex: "#EDEDED"))
                  .cornerRadius(12)
                  .padding(.trailing,13)
                    
                  VStack(alignment: .leading, spacing: 0){
                    Text("Поповнення балансу")
                      .foregroundColor(Color(hex: "#1B1C1C"))
                      .font(.system(size: 18))
                      .padding(.bottom,5)
                    Text("З карти")
                      .foregroundColor(Color(hex: "#5D5E5E"))
                      .font(.system(size: 16))
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.trailing,4)
                  Text("₴ 1000.00")
                    .foregroundColor(Color(hex: "#09D059"))
                    .font(.system(size: 16))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom,8)
                .padding(.horizontal,16)
                VStack(alignment: .leading, spacing: 0){
                }
                .frame(height: 1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#C6C6C6"))
                .padding(.bottom,7)
                .padding(.horizontal,30)
                HStack(spacing: 0){
                  VStack(alignment: .leading, spacing: 0){
                      Image("arrow-narrow-right-down")
                        .frame(width: 20, height: 20)
                        .padding(.top,5)
                      .padding(.bottom,5)
                  }
                  .padding(.horizontal,15)
                  .frame(width : 44, alignment: .leading)
                  .background(Color(hex: "#EDEDED"))
                  .cornerRadius(12)
                  .padding(.trailing,13)
                  VStack(alignment: .leading, spacing: 0){
                    Text("Виведення балансу")
                      .foregroundColor(Color(hex: "#1B1C1C"))
                      .font(.system(size: 18))
                      .padding(.bottom,5)
                    Text("З карти")
                      .foregroundColor(Color(hex: "#5D5E5E"))
                      .font(.system(size: 16))
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.trailing,4)
                  Text("-₴ 800.00")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,27)
                    .padding(.horizontal,16)
                    VStack(alignment: .leading, spacing: 0){
                        
                    }
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#C6C6C6"))
                    .padding(.bottom,7)
                    .padding(.horizontal,30)
                  
                  }
                  .padding(.top,27)
                  .padding(.bottom,8)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(hex: "#FDFDFD"))
                  .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                }
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
              .background(Color(hex: "#FDFDFD"))
              .cornerRadius(20)
            }
            .padding(.top,0.1)
            .padding(.bottom,0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(hex: "#FFFFFF"))
        
            .onAppear {
                userViewModel.getUser(userId: self.userID)
            }
    }
}

#Preview {
    BalanceView()
}
