import SwiftUI
import FirebaseAuth

struct RestorePasswordEmailView: View {
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToRegistrationPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check the email is not empty.
        !email.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image("arrow-sm-left") // Your arrow image
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16) // Apply leading padding here
                    }
                    Spacer() // Ensures the arrow stays at the leading edge
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)

            Text("Відновлення\nпаролю")
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 40))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 117)
                .padding(.bottom, 26)
                .padding(.horizontal, 16)

            InputField(text: $email, placeholder: "Електронна адреса", imageName: "mail", isSecure: false, baseString: "numo@gmail", state: .constant(.passive), isPasswordVisible: .constant(false))
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            Spacer()
            
            Button(action: {
                if isAllowedContinue {
                    sendPasswordResetEmail()
                }
            }){
                SuccessButtonView(title: "Далі", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 89)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding(.top, 29)
    }

    func sendPasswordResetEmail() {
        // Log to check the process flow
        print("Attempting to fetch sign-in methods for the email: \(email)")

        // First, check if there is a user associated with this email
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                // Log error details
                print("Error fetching sign-in methods: \(error.localizedDescription)")
                self.alertMessage = "Error: \(error.localizedDescription)"
                self.showingAlert = true
            } else if let methods = methods, methods.isEmpty {
                // Log for no user found
                print("No user found for the email: \(email)")
                self.alertMessage = "No account found with this email address."
                self.showingAlert = true
            } else {
                // Log for existing user, proceed with sending reset email
                print("User found, sending password reset email to: \(email)")
                Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                    if let error = error {
                        print("Failed to send reset email: \(error.localizedDescription)")
                        self.alertMessage = "Failed to send reset email: \(error.localizedDescription)"
                        self.showingAlert = true
                    } else {
                        print("Reset email sent successfully to: \(email)")
                        self.alertMessage = "If your email ( \(self.email) ) is registered with us, you will receive a password reset email shortly."
                        self.showingAlert = true
                    }
                }
            }
        }
    }

}

// For previewing the SwiftUI view
struct RestorePasswordEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RestorePasswordEmailView()
    }
}
