import SwiftUI

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject var userData = UserData()
    @State private var selectedTabIndex = 2
    @State private var startRun = false
    
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
                    ZStack {
                        switch selectedTabIndex {
                        case 0:
                            ChallengeList()
                                .padding(.top, ss(w: 1))
                                .padding(.bottom, ss(w:1))
                            
                        case 1:
                            AvtivityView()
//                                .padding(.top, ss(w: 1))
//                                .padding(.bottom, ss(w:1))
                        case 2:
                            BalanceView()
                        case 3:
                            ProfileView()
//                                .padding(.top, ss(w: 1))
//                                .padding(.bottom, ss(w:1))
                        case 4:
                            TrackerView(startRun: $startRun, selectedTabIndex: $selectedTabIndex)
                        default:
                            ChallengeList()
//                                .padding(.top, ss(w: 1))
//                                .padding(.bottom, ss(w:1))
                        }
                        
                        VStack {
                            Spacer()
                            NavigationBarView(selectedTabIndex: $selectedTabIndex, startRun: $startRun)
                        }
//                        .padding(.bottom, ss(w:1))
                        
                    }
                default:
                    WelcomeView()
                }
            } else {
                ProgressView()
            }
        }
//        .ignoresSafeArea()
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
