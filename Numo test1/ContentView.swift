import SwiftUI

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject var userData = UserData()

    var body: some View {
        ZStack {
            if userID.isEmpty {
                WelcomeView()
            } else if let user = userData.user {
                switch user.registrationStage {
                case "name":
                    RegistrationName()
                case "sex":
                    RegistrationSex()
                case "date":
                    RegistrationDate()
                case "weight":
                    RegistrationWeight()
                case "experience":
                    RegistrationExperience()
                case "done":
                    ProfileView()
                default:
                    WelcomeView()
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
                    print("ContentView appeared with userID: \(userID)")
                    if !userID.isEmpty {
                        userData.fetchUser(userId: userID)
                        print("UserData was fetched")
                        print("Here is user name and ID" + (userData.user?.name ?? "") + (userData.user?.email ?? ""))
                    }
                }
                .onChange(of: userID) { newUserID in
                    print("UserID changed: \(newUserID)")
                    if !newUserID.isEmpty {
                        userData.fetchUser(userId: newUserID)
                    }
                }
    }
}

#Preview{
    ContentView()
}
