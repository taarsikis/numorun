//
//  CreationCapacity.swift
//  Numo test1
//
//  Created by Тасік on 14.05.2024.
//

import SwiftUI

struct CreationCapacity: View {
    @State private var capacity: String = "10"
    @State var state: FieldStateNum = .active
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @Binding var challengeDetails : Challenge
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !capacity.isEmpty && hint == ""
    }
    
    
    private var hint:  String{
        
        let amount = Int(self.capacity) ?? -1
        
        if amount == -1{
            return "Ви ввели невірне значення"
        }
        
        if amount < 2{
            return "Мінімальна к-сть учасників - 2"
        }
        
        if amount >= 200{
            return "Максимальна к-сть учасників - 200"
        }
        return ""
        
    }
    
    
    @State private var navigateToCreationPace = false
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
                
                Text("Скільки учасників?")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                
                
                Spacer()
            }
            .frame(height: ss(w: 24))
            .frame(maxWidth: .infinity)
            .padding(.bottom,ss(w: 36))
            .padding(.top, ss(w: 35))
            
            
            HStack {
                Spacer()
                Text(String(self.challengeDetails.name.prefix(1))) // Get the first letter of the challenge name
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .frame(width: ss(w: 80), height: ss(w: 80)) // Circle dimensions
                            .background(backgroundColors[( 4) % backgroundColors.count]) // Choose the background color you like
                            .clipShape(Circle()) // Make it circular
                            .padding(.bottom,ss(w:20))
                
                Spacer()
            }
            HStack {
                Spacer()

                Text(self.challengeDetails.name)
                    .foregroundColor(Color(hex: "#5D5E5E"))
                    .font(.system(size: 16))
                    .padding(.bottom,ss(w: 39))
                Spacer()

            }
            
            
            Spacer()
                
            NumericInput(amount: $capacity, placeholder: "К-сть учасників", state: self.$state)
//                .padding(.bottom,ss(w: 100))
                .padding(.horizontal,ss(w: 75))
            
            HStack{
                Spacer()
                Text(hint)
                    .font(.caption)
                    .foregroundColor(Color(hex: "EB6048"))
                    .padding(.top, 4)
                Spacer()
            }
                
                
            Spacer()
                
                
            Button(action: {
                if isAllowedContinue{
                    navigateToCreationPace = true
                    self.challengeDetails.capacity = Int(self.capacity) ?? 10
                    print(self.challengeDetails)
                }
            }){
                SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.bottom,ss(w:40))
                    .padding(.horizontal, ss(w:30))
            }.fullScreenCover(isPresented: $navigateToCreationPace, content: {
                CreationPace(challengeDetails: self.$challengeDetails)
            })
//            }
//            .padding(.top,ss(w: 84))
//            .padding(.bottom,ss(w: 8))
//            .frame(height: ss(w: 396))
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color(hex: "#FDFDFD"))
            //                .cornerRadius(20)
            
        }
//        .background(Color(hex: "#F6F6F6"))
        .cornerRadius(20)
        
    }
}

//#Preview {
//    CreationCapacity()
//}
