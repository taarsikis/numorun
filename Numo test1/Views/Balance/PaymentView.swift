//
//  CreationPrice.swift
//  Numo test1
//
//  Created by Тасік on 13.05.2024.
//

import SwiftUI
import URLImage

struct PaymentView: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var amount: String = "300"
    @State private var state: FieldStateNum = .active
    
    @State private var loading = false
    @State private var navigateToBalance = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @StateObject private var userViewModel = UsersViewModel()
    @StateObject private var paycheckViewModel = PaychecksViewModel()
    
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        
        if !amount.isEmpty && hint == "" {
            return true
        }
        return false
    }
    
    private var hint:  String{
        
        let amount = Int(self.amount) ?? -1
        
        if amount == -1{
            return "Ви ввели невірне значення"
        }
        
        if amount < 100{
            return "Мінімальна сума поповнення - 100 грн."
        }
        
        if amount >= 10000{
            return "Максимальна сума поповнення - 10 000 грн."
        }
        return ""
        
    }
    
    private func handleDeepLink(url: URL) {
        
        print("Received deeplink")
            if url.scheme == "numorun", url.host == "payment" {
                // Redirect to the PaymentView
                print("Received deeplink with payment")
                navigateToBalance = true
            }
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
                
                Text("Вкажи суму поповнення")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                
                
                Spacer()
            }
            .frame(height: ss(w: 24))
            .frame(maxWidth: .infinity)
            .padding(.bottom,ss(w: 36))
            .padding(.top, ss(w: 35))
            
            
            
            
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
            
            VStack(alignment: .leading, spacing: 0) {}
                .frame(height: ss(w: 1))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#C6C6C6"))
                .padding(.horizontal, ss(w: 30))
                .padding(.top, ss(w:80))
            
            HStack(alignment: .center, spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    Image("Ellipse 3")
                      .frame(width: 10, height: 10)
                }
                .padding(5)
                .frame(width: 20, height: 20, alignment: .center)
                .background(Color(red: 0.03, green: 0.7, blue: 0.62))
                .cornerRadius(5555)
                
                // Medium
                Text("Онлайн-оплата карткою")
                  .font(Font.custom("Kyiv*Type Sans", size: 15))
                  .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                
                Spacer()
                Text("Комісія 6%")
                  .font(Font.custom("Kyiv*Type Sans", size: 12))
                  .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                
                Image("plata_light_bg")
                    .resizable()
                    .frame(width:100, height: 30)
                    
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 0) {}
                .frame(height: ss(w: 1))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#C6C6C6"))
                .padding(.horizontal, ss(w: 30))
                
                
            Spacer()
                
                
            Button(action: {
                if isAllowedContinue{
                    loading = true
                    paycheckViewModel.createPaycheck(paycheck: PaycheckCreate(userID: self.userID, amount: (Double(self.amount) ?? 100000)*1.06, message: "", invoiceId: "", paymentUrl: "")){_ in
                        loading = false
                        if let url = URL(string: paycheckViewModel.paycheck.paymentUrl ?? "https://google.com") {
                                                        UIApplication.shared.open(url)
                                                    }
                        navigateToCreationCapacity = true
                    }
                    
                    
                    
                    
                }
            }){
                if (loading){
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }else{
                    SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                        .padding(.horizontal, ss(w:30))
                }
            }.fullScreenCover(isPresented: $navigateToCreationCapacity, content: {
                ContentView()
            })
            if (hint.isEmpty){
                HStack {
                    Spacer()
                    Text("До сплати включно з комісією - \(String(format: "%.2f", (Float(self.amount) ?? 0) * 1.06)) грн")
                        .font(Font.custom("Kyiv*Type Sans", size: 15))
                        .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                    .padding(.bottom,ss(w:20))
                    Spacer()
                }
            }
            
            
            
            
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenDeepLink"))) { notification in
            if let url = notification.object as? URL {
                handleDeepLink(url: url)
            }
        }
        .fullScreenCover(isPresented: $navigateToBalance, content: {
                    ContentView()
                })
                .onAppear {
            userViewModel.getUser(userId: userID)
        }
//        .background(Color(hex: "#F6F6F6"))
        .cornerRadius(20)
        
            
    }
        
}

#Preview {
    PaymentView()
}
