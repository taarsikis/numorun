//
//  RegistrationDate.swift
//  Numo test1
//
//  Created by Тасік on 03.04.2024.
//

import SwiftUI

struct RegistrationDate: View {

    
    @State private var selectedDate: Date = Date()
    
    var fromSettings : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    @StateObject private var userViewModel = UsersViewModel()
    @AppStorage("uid") var userID: String = ""
    
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        true
    }
    
    @State private var navigateToRegistrationWeight = false
    
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
                    .frame(width : 95, height: 8, alignment: .leading)
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
            
            Text("Крок 6")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
            
            Text("Твоя дата народження?")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .padding(.bottom,56)
                .padding(.horizontal,16)
            
            
            HStack {
                Spacer()
                DatePicker("Select a date", selection: $selectedDate,in: ...Date(),             displayedComponents: [.date])
                            
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 297 ,height: 215)
                Spacer()
            }.padding(.horizontal, 46)
            
            Spacer()
            
            Button(action:{
                if isAllowedContinue{
                    navigateToRegistrationWeight = true
                    if fromSettings{
                        userData.updateUser(data: ["dateOfBirth": selectedDate , "registrationStage": "done"])
                    }else{
                        userData.updateUser(data: ["dateOfBirth": selectedDate , "registrationStage": "weight"])
                    }
                    userViewModel.partialUpdateUser(userId: self.userID, data: ["date_of_birth": selectedDate.toString(withFormat: "yyyy-MM-dd")])
                }
                
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.horizontal, 30)
            }.fullScreenCover(isPresented: $navigateToRegistrationWeight, content: {
                
                if fromSettings{
                    ProfileSettings()
                }else{
                    
                    RegistrationWeight()
                }
                
            })
            .padding(.bottom,97.5)
        }
        .padding(.top, 29)
    }
}

#Preview {
    RegistrationDate()
}
