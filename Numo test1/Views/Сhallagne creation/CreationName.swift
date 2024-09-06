import SwiftUI



struct CreationName: View {
    @State private var challangeName: String = ""
    @State private var challangeDescription: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @State private var challengeDetails = Challenge(name: "", description: "", price: 0, capacity: 0, slowest_pace: 0, creator: "", status: 0)
    
    private var isAllowedContinue: Bool {
        !challangeName.isEmpty && isAllowedName && isAllowedDescription
    }
    
    private var isAllowedName: Bool {
        challangeName.count <= 30
    }
    
    private var isAllowedDescription: Bool {
        challangeDescription.count < 130
    }
    
    @State private var navigateToCreationPrice = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("arrow-sm-left")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16)
                    }
                    Spacer()
                }
                Text("Як назвемо?")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 36)
            .padding(.top, 35)
            
            Group {
                HStack {
                    Spacer()
                    Text(String(challangeName.prefix(1))) // Get the first letter of the challenge name
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                                .frame(width: ss(w: 80), height: ss(w: 80)) // Circle dimensions
                                .background(backgroundColors[( 4) % backgroundColors.count]) // Choose the background color you like
                                .clipShape(Circle()) // Make it circular
                                .padding(.bottom,ss(w:20))
                    Spacer()
                }
                
//                HStack {
//                    Spacer()
//                    Text("Вибрати зображення")
//                        .foregroundColor(Color(hex: "#5D5E5E"))
//                        .font(.system(size: 16))
//                        .padding(.bottom, 39)
//                    Spacer()
//                }
                
                // Assuming InputField is a custom view
                InputField(
                    text: $challangeName,
                    placeholder: "Придумай назву челенджу",
                    isSecure: false,
                    baseString: "Мій перший челендж",
                    state: self.isAllowedName ? .constant(.passive) : .constant(.error),
                    hint: self.isAllowedName ? "Ліміт 30 символів" : "Ви перевищили ліміт 30 символів",
                    isPasswordVisible: .constant(true)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                InputField(
                    text: $challangeDescription,
                    placeholder: "Придумай опис Челенджу",
                    isSecure: false,
                    baseString: "Опис",
                    state: self.isAllowedDescription ? .constant(.passive) : .constant(.error),
                    hint: self.isAllowedDescription ? "Ліміт 130 символів" : "Ви перевищили ліміт 130 символів",
                    isPasswordVisible: .constant(true)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                Spacer()
                
                Button(action: {
                    if isAllowedContinue {
                        navigateToCreationPrice = true
                        self.challengeDetails.name = self.challangeName
                        self.challengeDetails.description = self.challangeDescription
                    }
                }) {
                    // Assuming SuccessButtonView is a custom view
                    SuccessButtonView(
                        title: "Продовжити",
                        isAllowed: isAllowedContinue,
                        fontSize: 20,
                        fontPaddingSize: 16,
                        cornerRadiusSize: 12
                    )
                    .padding(.bottom, 40)
                    .padding(.horizontal, 30)
                }
                .fullScreenCover(isPresented: $navigateToCreationPrice) {
                    CreationPrice(challengeDetails: self.$challengeDetails)
                    
                }
            }
        }
    }
}


#Preview {
    CreationName()
}
