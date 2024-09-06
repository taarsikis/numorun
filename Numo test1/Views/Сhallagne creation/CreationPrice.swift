//
//  CreationPrice.swift
//  Numo test1
//
//  Created by Тасік on 13.05.2024.
//

import SwiftUI
import URLImage

struct CreationPrice: View {
    @State private var amount: String = "100"
    @State private var state: FieldStateNum = .active
    @Binding var challengeDetails : Challenge
    
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        !amount.isEmpty && hint == ""
    }
    
    private var hint:  String{
        
        let amount = Int(self.amount) ?? -1
        
        if amount == -1{
            return "Ви ввели невірне значення"
        }
        
        if amount < 100{
            return "Мінімальна ціна челенджу - 100 грн."
        }
        
        if amount >= 100000{
            return "Максимальна ціна челенджу - 100 000 грн."
        }
        return ""
        
    }
    
    @State private var navigateToCreationCapacity = false
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
                
                Text("Скільки коштуватиме?")
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
//                    .padding(.bottom,ss(w: 39))
                Spacer()

            }
            
            Spacer()
                
            NumericInput(amount: $amount, placeholder: "Сума", currencySymbol: "₴", state: .constant(.error))
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
                    navigateToCreationCapacity = true
                    self.challengeDetails.price = Int(self.amount) ?? 0
                }
            }){
                SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                    .padding(.bottom,ss(w:40))
                    .padding(.horizontal, ss(w:30))
            }.fullScreenCover(isPresented: $navigateToCreationCapacity, content: {
                CreationCapacity(challengeDetails: self.$challengeDetails)
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
//    CreationPrice( challengeDetails : Challenge(name: "", description: "", price: 0, capacity: 0, slowestPace: 0, creator: "", status: 0))
//}
