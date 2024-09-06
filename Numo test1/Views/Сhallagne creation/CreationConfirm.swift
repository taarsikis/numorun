//
//  CreationConfirm.swift
//  Numo test1
//
//  Created by Тасік on 16.05.2024.
//

import SwiftUI

struct CreationConfirm: View {
    @AppStorage("uid") var userID: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    
    @Binding var challengeDetails : Challenge
    
    @Binding var runs : [RunningDay]
    
//    let runs = [
//        ("23 Жовт 2023", "5 km"),
//        ("27 Жовт 2023", "7 km"),
//        ("01 Лист 2023", "5 km"),
//        ("05 Лист 2023", "7 km"),
//        ("10 Лист 2023", "5 km")
//    ]
    

    
    @State private var navigateToChallengeList = false
    
    @State private var navigateToList = false
    
    
    @StateObject private var challengeViewModel = ChallengesViewModel()
    @StateObject private var userViewModel = UsersViewModel()
    @StateObject private var participantViewModel = ParticipantsViewModel()
    @State private var showingAlert = false


    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        if self.userViewModel.user?.balance ?? 0 >= challengeDetails.price{
            return true
        }
        return false
    }
    
    var averageDistance: Double {
        let totalDistance = runs.reduce(0) { $0 + $1.kilometers }
        return runs.isEmpty ? 0 : Double(totalDistance) / Double(runs.count)
    }
    
    var body: some View {
        ScrollView {
            
            
            
            VStack(alignment: .leading, spacing: 0){
                ZStack{
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
                        
                        //                                Button(action:{
                        //
                        //                                }){
                        //                                    Image("information-circle") // Your arrow image
                        //                                        .resizable()
                        //                                        .frame(width: 24, height: 24)
                        //                                        .padding(.trailing, 16)
                        //                                }
                    }
                    
                    Text(self.challengeDetails.name)
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity)
                    
                    
                    Spacer()
                }
                .frame(height: ss(w: 24))
                .frame(maxWidth: .infinity)
                //            .padding(.bottom,ss(w: 5))
                .padding(.top, ss(w: 35))
                .padding(.bottom, ss(w:24))
                
                
                
                
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
                    
                    Text("ID #\(self.challengeDetails.id ?? 0)")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 20))
                        .padding(.bottom,ss(w: 10))
                    
                    Spacer()
                }
                
                
                if !self.challengeDetails.description.isEmpty{
                    HStack {
                        Spacer()
                        Text(self.challengeDetails.description)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom,ss(w: 31))
                            .padding(.horizontal,ss(w: 5))
                        Spacer()
                    }
                }
                
                Text("Характеристики Челенджу")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 20))
                    .padding(.bottom,ss(w: 16))
                    .padding(.leading,ss(w: 12))
                
                
                
                VStack(alignment: .leading, spacing: 0){
                    HStack(spacing: 0){
                        Text("Ціна")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing,ss(w: 4))
                        Text("₴ \(self.challengeDetails.price)")
                            .foregroundColor(Color(hex: "#5D5E5E"))
                            .font(.system(size: 16))
                    }
                    .frame(height: ss(w: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,ss(w: 7))
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(height: ss(w: 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#C6C6C6"))
                    .padding(.bottom,ss(w: 12))
                    HStack(spacing: 0){
                        Text("Кількість учасників")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .frame(width : ss(w: 90))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text(String(self.challengeDetails.capacity))
                            .foregroundColor(Color(hex: "#5D5E5E"))
                            .font(.system(size: 16))
                    }
                    .frame(height: ss(w: 36))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,ss(w: 11))
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(height: ss(w: 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#C6C6C6"))
                    .padding(.bottom,ss(w: 12))
                    HStack(spacing: 0){
                        Text("Найповільніший темп")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing,ss(w: 4))
                        Text("\((self.challengeDetails.slowest_pace - (self.challengeDetails.slowest_pace % 60))/60):\(String(format: "%02d", self.challengeDetails.slowest_pace % 60)) км/хв")
                            .foregroundColor(Color(hex: "#5D5E5E"))
                            .font(.system(size: 16))
                    }
                    .frame(height: ss(w: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,ss(w: 11))
                    VStack(alignment: .leading, spacing: 0){
                    }
                    .frame(height: ss(w: 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#C6C6C6"))
                    .padding(.bottom,ss(w: 12))
                    HStack(spacing: 0){
                        Text("Середня відстань пробіжки")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing,ss(w: 4))
                        Text("\(String(format: "%.2f", averageDistance)) км")
                            .foregroundColor(Color(hex: "#5D5E5E"))
                            .font(.system(size: 16))
                    }
                    .frame(height: ss(w: 18))
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical,ss(w: 17))
                .padding(.horizontal,ss(w: 14))
                .frame(height: ss(w: 192))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#FDFDFD"))
                .cornerRadius(12)
                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                .padding(.bottom,ss(w: 24))
                .padding(.horizontal,ss(w: 12))
                
                
                
                Text("Календар пробіжок")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 20))
                    .padding(.bottom,ss(w: 16))
                    .padding(.leading,ss(w: 12))
                
                VStack(alignment: .leading) {
                    VStack {
                        ForEach(runs, id: \.id) { run in
                            
                            HStack(spacing: 0){
                                Text(run.date, style: .date)
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing,ss(w: 4))
                                Text("\(run.kilometers) км")
                                    .foregroundColor(Color(hex: "#5D5E5E"))
                                    .font(.system(size: 16))
                            }
                            .frame(height: ss(w: 18))
                            .frame(maxWidth: .infinity)
                            .padding(.bottom,ss(w: 7))
                            VStack(alignment: .leading, spacing: 0){
                            }
                            .frame(height: ss(w: 1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#C6C6C6"))
                            .padding(.bottom,ss(w: 12))
                            
                        }
                        Button(action: {
                            navigateToList = true
                        }) {
                            Text("Переглянути всі пробіжки")
                                .foregroundColor(Color(hex: "#07B29D"))
                            
                        }.fullScreenCover(isPresented: $navigateToList, content: {
                            CreationListOfRuns(runs: self.$runs)
                        })
                    }.padding(10)
                }
                .background(Color(hex: "#FDFDFD"))
                .cornerRadius(12)
                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                .padding(.horizontal)
                .padding(.bottom, ss(w:36))
                
                
                Button(action: {
//                    if isAllowedContinue{
//                        navigateToChallengeList = true
//                        self.challengeDetails.creator  = self.userID
//                        
//                        print(self.challengeDetails)
////                        challengeViewModel.createChallenge(challenge: self.challengeDetails)
//                        challengeViewModel.createChallengeWithRuns(challenge: self.challengeDetails, runningDays: self.runs)
//                        if let challengeId = challengeViewModel.challenge?.id, let user = userViewModel.user{
//                            participantViewModel.createParticipant(participant: Participant(challenge_id: challengeId, user_id: self.userID, user_status: 1))
//
//                            let updatedUser = User(id: user.id, email: user.email, name: user.name, sex: user.sex, date_of_birth: user.date_of_birth, weight: user.weight, experience: user.experience, balance: (user.balance) - challengeDetails.price)
//                            userViewModel.updateUser(userId: self.userID, user: updatedUser)
//                            
//                        }else{
//                            showingAlert = true
//
//                        }
//                        
//                    }
                    
                    if isAllowedContinue {
                        navigateToChallengeList = true
                        self.challengeDetails.creator  = self.userID
                        print("Button pressed!")
                        print("Started challenge creation")
                            challengeViewModel.createChallengeWithRuns(challenge: self.challengeDetails, runningDays: self.runs) { result in
                                switch result {
                                case .success(let createdChallenge):
                                    print("Succes in challenge creation and getting ID")
                                    // Now that the challenge is successfully created, you can use its ID
                                    if let challengeId = createdChallenge.id {
                                        
                                        // Proceed to update user and navigate
                                        if let user = userViewModel.user {
                                            let updatedUser = User(id: user.id, email: user.email, name: user.name, sex: user.sex, date_of_birth: user.date_of_birth, weight: user.weight, experience: user.experience, balance: user.balance - challengeDetails.price)
                                            let participant = Participant(challenge_id: challengeId, user_id: self.userID, user_status: 1)
                                            participantViewModel.createParticipant(participant: participant)
                                            userViewModel.updateUser(userId: self.userID, user: updatedUser)
                                            navigateToChallengeList = true
                                        }else{
                                            showingAlert = true
                                        }
                                    }else{
                                        showingAlert = true
                                    }
                                case .failure(let error):
                                    
                                    print("Fail in challenge creation and getting ID")
                                    // Handle error, perhaps set showingAlert to true here
                                    print("Error creating challenge: \(error)")
                                    showingAlert = true
                                }
                            }
                        }
                }){
                    SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                        .padding(.horizontal, 30)
                }.fullScreenCover(isPresented: $navigateToChallengeList, content: {
                    ContentView()
                })
                if !isAllowedContinue{
                    
                    HStack{
                        Spacer()
                        Text("У вас недостатньо коштів на балансі (\(userViewModel.user?.balance ?? 0)/\(challengeDetails.price) грн.)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "EB6048"))
                            .padding(.top, 4)
                        Spacer()
                    }
                }
                
                
            }
        }.onAppear {
            userViewModel.getUser(userId: userID)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Помилка!"), message: Text("Ми створили ваш челендж, але не змогли вас додати до нього. Зробіть це самостійно."), dismissButton: .default(Text("OK"), action: {
                // Navigate to the ChallengeList after dismissing the alert
                navigateToChallengeList = true
            }))
        }
        .fullScreenCover(isPresented: $navigateToChallengeList) {
            ContentView()
        }
    }
}

//#Preview {
//    CreationConfirm()
//}
