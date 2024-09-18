//
//  ChallengeView.swift
//  Numo test1
//
//  Created by Тасік on 12.06.2024.
//

import SwiftUI

struct ChallengeView: View {
    @AppStorage("uid") var userID: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    
    @Binding var challengeDetails : FetchedChallenge
    
    
    
    
    private var isUserParticipant: Bool {
        for participant in participantViewModel.participants{
            if self.userID == participant.user_id{
                return true
            }
        }
        return false
    }
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        if self.userViewModel.user?.balance ?? 0 >= challengeDetails.challenge.price{
            return true
        }
        return false
    }
    
    @State private var navigateToChallengeList = false
    //    @State private var navigateToChallengeView = false
    
    @State private var navigateToList = false
    @State private var navigateToCompletedRunsList = false
    
    @StateObject private var challengeViewModel = ChallengesViewModel()
    @StateObject private var userViewModel = UsersViewModel()
    @StateObject var participantViewModel = ParticipantsViewModel()
    
    @State private var showAlert = false
    @State private var showingAlert = false
    @State private var isLoading = false
    
    
    @State private var runList : [Run] = []
    @State private var runViewModel = RunsViewModel()
    
    
    func validateRun (run : ChallengeRun) -> (Bool){
        print("Validating....")
        print(run)
        for element in runList{
            print("Checking")
            print(element)
            if run.date == element.date
                && Int(element.distance) >= run.distance_km * 1000
                && Int(element.pace)*60 <= challengeDetails.challenge.slowest_pace {
                
                    print("success")
                return true
            }else{
                print("error")
            }
                
        }
        return false
    }
    
    func isDate(_ date1: Date, laterThan date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        if let day1 = calendar.date(from: components1), let day2 = calendar.date(from: components2) {
            return day1 > day2
        }
        
        return false
    }
    
    func getImageForRun(run : ChallengeRun) -> (String){
        
        if validateRun(run: run){
            return "check-circle"
        }
        
        if isDate(run.date.toDate(withFormat: "yyyy-MM-dd") ?? Date(), laterThan: Date()){
            return "dots-circle-horizontal"
        }
        
        
        
        return "x-circle"
    }
    
    
    func getNextChallengeRun(for challengeRuns: [ChallengeRun]) -> ChallengeRun? {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Parse the date strings in the challengeRuns and reset their time components to midnight
        let filteredAndSortedRuns = challengeRuns.compactMap { run -> (run: ChallengeRun, date: Date)? in
            if let runDate = run.date.toDate(withFormat: "yyyy-MM-dd") {
                let runDateAtMidnight = Calendar.current.startOfDay(for: runDate)
                return (run: run, date: runDateAtMidnight)
            }
            return nil
        }.filter { (run, date) in
            // Filter for runs that are today or in the future
            return date >= today
        }.sorted { (first, second) in
            // Sort by date ascending
            return first.date < second.date
        }
        
        // Return the first element from the sorted list
        return filteredAndSortedRuns.first?.run
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
                        
                        Spacer()
                    }
                    
                    Text(self.challengeDetails.challenge.name)
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
                    Text(String(self.challengeDetails.challenge.name.prefix(1))) // Get the first letter of the challenge name
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                                .frame(width: ss(w: 80), height: ss(w: 80)) // Circle dimensions
                                .background(backgroundColors[(self.challengeDetails.challenge.id ?? 1) % backgroundColors.count]) // Choose the background color you like
                                .clipShape(Circle()) // Make it circular
                                .padding(ss(w:10))
                    

                    
                    Spacer()
                }
                
                
                HStack {
                    Spacer()
                    
                    Text("ID #\(self.challengeDetails.challenge.id ?? 0)")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 20))
                        .padding(.bottom,ss(w: 10))
                    
                    Spacer()
                }
                
                
                if !self.challengeDetails.challenge.description.isEmpty{
                    HStack {
                        Spacer()
                        Text(self.challengeDetails.challenge.description)
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
                
                
                if challengeDetails.challenge.status != 0 && isUserParticipant {
                    
                    
                    if let nextRun = getNextChallengeRun(for: challengeDetails.challengeRuns) {
                        Text("Найближча пробіжка")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 20))
                            .padding(.bottom,ss(w: 16))
                            .padding(.leading,ss(w: 12))
                        HStack(spacing: 0) {
                            Image("calendar-w")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .leading)
                                .padding(.trailing, 9)
                            
                            
                            Text("\(formatDate(nextRun.date.toDate(withFormat: "yyyy-MM-dd") ?? Date()))")
                                .foregroundColor(Color(hex: "#FDFDFD"))
                                .font(.system(size: 22))
                            Spacer()
                            
                            
                            Text("\(nextRun.distance_km) км")
                                .foregroundColor(Color(hex: "#B2E7E1"))
                                .font(.system(size: 19))
                            
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#07B29D"))
                        .cornerRadius(12)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 16)
                        
                        Button(action: {
                            navigateToCompletedRunsList = true
                        }) {
                            Text("Переглянути всі пробіжки")
                                .foregroundColor(Color(hex: "#07B29D"))
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                            
                        }.fullScreenCover(isPresented: $navigateToCompletedRunsList, content: {
                            ChallengeViewCompletedRuns(runs: self.challengeDetails.challengeRuns, pace: self.challengeDetails.challenge.slowest_pace)
                        })
                        
                    } else {
                        Text("Пробіжки які були у челенджі")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 20))
                            .padding(.bottom,ss(w: 16))
                            .padding(.leading,ss(w: 12))
                        
                        VStack(alignment: .leading, spacing: 0){
                            ForEach(challengeDetails.challengeRuns.prefix(3).sorted(by: {$0.date.toDate(withFormat: "yyyy-MM-dd") ?? Date() < $1.date.toDate(withFormat: "yyyy-MM-dd") ?? Date()}), id: \.id) { run in
                                
                                HStack(spacing: 0){
                                    Text(run.date.toDate(withFormat: "yyyy-MM-dd") ?? Date(), style: .date)
                                        .foregroundColor(Color(hex: "#1B1C1C"))
                                        .font(.system(size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing,ss(w: 4))
                                    Text("\(run.distance_km) км")
                                        .foregroundColor(Color(hex: "#5D5E5E"))
                                        .font(.system(size: 16))
                                    Image(getImageForRun(run: run)) // x-circle
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .leading)
                                        .padding(.horizontal, 9)
                                }
                                .frame(height: ss(w: 18))
                                .frame(maxWidth: .infinity)
                                .padding(.bottom,ss(w: 7))
                                VStack(alignment: .leading, spacing: 0){
                                }
                                .frame(height: ss(w: 1))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(hex: "#C6C6C6"))
                                .padding(.bottom,ss(w: 5))
                                
                            }
                            
                            Button(action: {
                                navigateToCompletedRunsList = true
                            }) {
                                Text("Переглянути всі пробіжки")
                                    .foregroundColor(Color(hex: "#07B29D"))
                                    .padding(.horizontal, 5)
                                    .padding(.bottom,ss(w: 5))
                                
                            }.fullScreenCover(isPresented: $navigateToCompletedRunsList, content: {
                                ChallengeViewCompletedRuns(runs: self.challengeDetails.challengeRuns, pace: self.challengeDetails.challenge.slowest_pace)
                            })
                            
                        }
                        .padding(.horizontal,ss(w: 14))
                        .padding(.top, ss(w:10))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#FDFDFD"))
                        .cornerRadius(12)
                        .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                        .padding(.horizontal,ss(w: 12))
                        
                        .padding(.bottom, 16)
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
                        Text("₴ \(self.challengeDetails.challenge.price)")
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
                        Text(String(self.challengeDetails.challenge.capacity))
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
                        Text("\((self.challengeDetails.challenge.slowest_pace - (self.challengeDetails.challenge.slowest_pace % 60))/60):\(String(format: "%02d", self.challengeDetails.challenge.slowest_pace % 60)) хв/км")
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
                        Text("\(String( self.challengeDetails.averageDistance)) км")
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
                
                
                if challengeDetails.challenge.status == 0 || !isUserParticipant{
                    Text("Календар пробіжок")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 20))
                        .padding(.bottom,ss(w: 16))
                        .padding(.leading,ss(w: 12))
                    
                    VStack(alignment: .leading) {
                        VStack {
                            ForEach(self.challengeDetails.challengeRuns.prefix(4), id: \.id) { run in
                                
                                HStack(spacing: 0){
                                    Text("\(formatDate(run.date.toDate(withFormat: "yyyy-MM-dd") ?? Date()))")
                                        .foregroundColor(Color(hex: "#1B1C1C"))
                                        .font(.system(size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing,ss(w: 4))
                                    Text("\(run.distance_km) км")
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
                                ChallengeViewRuns(runs: self.challengeDetails.challengeRuns)
                            })
                        }.padding(10)
                    }
                    .background(Color(hex: "#FDFDFD"))
                    .cornerRadius(12)
                    .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                    .padding(.horizontal)
                    .padding(.bottom, ss(w:36))
                }
                if challengeDetails.challenge.status == 0 {
                    Button(action: {
                        if !isUserParticipant && isAllowedContinue{
                            if let challengeId = challengeDetails.challenge.id {
                                if let user = userViewModel.user {
                                                    isLoading = true  // Start loading

                                                    // Create updated user with deducted balance
                                                    let updatedUser = User(id: user.id, email: user.email, name: user.name, sex: user.sex, date_of_birth: user.date_of_birth, weight: user.weight, experience: user.experience, balance: user.balance - challengeDetails.challenge.price)

                                                    // First API call: update user balance
                                                    userViewModel.updateUser(userId: self.userID, user: updatedUser) { userResult in
                                                        switch userResult {
                                                        case .success:
                                                            // User update succeeded, now create participant
                                                            let participant = Participant(challenge_id: challengeId, user_id: self.userID, user_status: 1)

                                                            // Second API call: create participant
                                                            participantViewModel.createParticipant(participant: participant) { participantResult in
                                                                isLoading = false  // Stop loading after participant is created

                                                                switch participantResult {
                                                                case .success:
                                                                    // Perform success action, like navigation
                                                                    // navigateToChallengeView = true
                                                                    isLoading = false
                                                                case .failure(let error):
                                                                    // Handle error on participant creation
                                                                    isLoading = false
                                                                    showingAlert = true
                                                                }
                                                            }

                                                        case .failure(let error):
                                                            isLoading = false  // Stop loading on failure
                                                            // Handle error on user update
                                                            showingAlert = true
                                                        }
                                                    }
                                                }
                                else{
                                    showingAlert = true
                                }
                            }else{
                                showingAlert = true
                            }
                        }
                    }){
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()  // Show loading spinner while processing API calls
                                    .padding(.horizontal, 30)
                                Spacer()
                            }
                        } else {
                            SuccessButtonView(title: isUserParticipant ? "Ви вже зареєстровані" : "Зареєструватися", isAllowed: !isUserParticipant && isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                                .padding(.horizontal, 30)
                        }
                    }
                    //                        .fullScreenCover(isPresented: $navigateToChallengeView, content: {
                    //                    ChallengeView(challengeDetails: self.$challengeDetails)
                    //                })
                    
                    if !isAllowedContinue && !isUserParticipant{
                        
                        HStack{
                            Spacer()
                            Text("У вас недостатньо коштів на балансі (\(userViewModel.user?.balance ?? 0)/\(challengeDetails.challenge.price) грн.)")
                                .font(.caption)
                                .foregroundColor(Color(hex: "EB6048"))
                                .padding(.top, 4)
                            Spacer()
                        }
                    }
                }
                
            }
            
            
            
        }.onAppear{
            runViewModel.fetchRunsByUserId(userId: userID)
            if let challengeId = self.challengeDetails.challenge.id{
                self.participantViewModel.fetchParticipantsByChallengeId(challengeId: challengeId)
                userViewModel.getUser(userId: userID)
            }else{
                showAlert = true
            }
        }
        .onReceive(runViewModel.$runs) { runs in
            for run in runs{
                print(run.id)
                self.runList.append(run)
            }
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Помилка!"), message: Text("Ми не змогли відобразити цей челендж. Спробуйте, будь ласка, пізніше."), dismissButton: .default(Text("OK"), action: {
                // Navigate to the ChallengeList after dismissing the alert
                navigateToChallengeList = true
            }))
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Помилка!"), message: Text("Ми не змогли добавити вас у цей челендж. Спробуйте, будь ласка, пізніше."), dismissButton: .default(Text("OK"), action: {
                // Navigate to the ChallengeList after dismissing the alert
                navigateToChallengeList = true
            }))
        }
        .fullScreenCover(isPresented: $navigateToChallengeList) {
            ChallengeList()
        }
    }
}

//#Preview {
//    ChallengeView()
//}
extension FetchedChallenge {
    static var sample: FetchedChallenge {
        FetchedChallenge(
            challenge: Challenge(
                id: 1,
                name: "Sample Challenge" ,
                description: "This is a detailed description of the sample challenge.",
                price: 1,
                capacity: 100,
                slowest_pace: 360,
                creator: "0", status: 0
            ),
            challengeRuns: [
                ChallengeRun(id: 1,challenge_id: 1, date: "2024-06-12", distance_km: 5),
                ChallengeRun(id: 1,challenge_id: 1, date: "2024-06-12", distance_km: 5),
                ChallengeRun(id: 1,challenge_id: 1, date: "2024-06-12", distance_km: 5),
                ChallengeRun(id: 1,challenge_id: 1, date: "2024-06-12", distance_km: 5),
                ChallengeRun(id: 2, challenge_id: 1, date: "2024-07-17", distance_km: 10)
            ],
            averageDistance: 3
        )
    }
}


func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM yyyy"
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter.string(from: date)
}

// Preview Provider
struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challengeDetails: .constant(FetchedChallenge.sample))
    }
}
