import SwiftUI
import URLImage
import FirebaseAuth

struct RegistrationPassword: View {
    
    @AppStorage("uid") var userID: String = ""
    @Binding var email: String
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var isPasswordVisible: Bool? = false // To control password visibility
    @State private var isRepeatedPasswordVisible: Bool? = false // To control password visibility
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var userData = UserData()
    @StateObject private var userViewModel = UsersViewModel()
    
    @State private var isLoading = false // State to manage loading indicator
    @State private var showAlert = false // State to manage alert presentation
    @State private var alertMessage = "" // State to store the alert message
    
    private var isAllowedContinue: Bool {
        !password.isEmpty && !repeatedPassword.isEmpty && password == repeatedPassword && password.validatePassword()
    }
    
    @State private var navigateToRegistrationName = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image("arrow-sm-left")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(width: 47, height: 8, alignment: .leading)
                    .background(Color(hex: "#07B29D"))
                    .cornerRadius(30)
                    .padding(.top,1)
                }
                .padding(.horizontal,1)
                .frame(width: 122, height: 9, alignment: .leading)
                .background(Color(hex: "#B2E7E1"))
                .cornerRadius(30)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            Text("Крок 3")
                .foregroundColor(Color(hex: "#07B29D"))
                .font(.system(size: 20))
                .padding(.bottom,56)
                .padding(.horizontal,160)
            
            Text("Придумай\nпароль")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,26)
                .padding(.horizontal,16)
            
            InputField(text: $password, placeholder: "Придумай пароль", imageName: "lock-closed", isSecure: true, baseString: "******", state: .constant(.passive), isPasswordVisible: $isPasswordVisible)
                .padding(.bottom, 9)
                .padding(.horizontal, 16)
            
            InputField(text: $repeatedPassword, placeholder: "Повтори введений пароль", imageName: "lock-closed", isSecure: true, baseString: "******", state: .constant(.passive), isPasswordVisible: $isRepeatedPasswordVisible)
                .padding(.horizontal, 16)
         
            if !password.validatePassword() {
                HStack {
                    Text("Пароль повинен містити мінімум 6 символів та хоча б дві цифри")
                        .font(.caption)
                        .foregroundColor(Color(hex: "EB6048"))
                        .padding(.top, 4)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
            
            if password != repeatedPassword {
                HStack {
                    Text("Введені паролі відрізняються")
                        .font(.caption)
                        .foregroundColor(Color(hex: "EB6048"))
                        .padding(.top, 4)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
            
            Spacer()
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView() // Loading indicator
                        .padding(.bottom, 110)
                    .padding(.horizontal, 30)
                    Spacer()
                }
            } else {
                Button(action: {
                    if isAllowedContinue {
                        isLoading = true // Start loading
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            isLoading = false // Stop loading
                            
                            if let error = error as NSError? {
                                // Check if the error is a network error (code 17020)
                                if error.domain == AuthErrorDomain && error.code == 17020 {
                                    alertMessage = "Network error: Please check your internet connection and try again."
                                } else {
                                    // Handle all other errors
                                    alertMessage = error.localizedDescription
                                }
                                showAlert = true
                                return
                            }
                            
                            if let authResult = authResult {
                                print(authResult.user.uid)
                                userID = authResult.user.uid
                                userData.addUser(email: email, name: authResult.user.uid, dateOfBirth: Date(), sex: "", weight: 0.0, experience: "", registrationStage: "name")
                                
                                userViewModel.createUser(user: User(id: userID, email: self.email, name: userID, sex: "", date_of_birth: "2022-03-03", weight: 0, experience: 0, balance: 0))
                                
                                navigateToRegistrationName = true
                            }
                        }
                    }
                }) {
                    SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                        .padding(.bottom, 110)
                        .padding(.horizontal, 30)
                }
                .disabled(isLoading) // Disable button while loading
                .fullScreenCover(isPresented: $navigateToRegistrationName) {
                    RegistrationName()
                }
                .alert(isPresented: $showAlert) { // Alert presentation
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .padding(.top, 29)
    }
}

#Preview {
    RegistrationPassword(email: .constant("Test12@gmail.com"))
}
