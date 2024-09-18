//
//  AvtivityView.swift
//  Numo test1
//
//  Created by Тасік on 18.06.2024.
//

import SwiftUI
import URLImage

struct AvtivityView: View {
    
    @StateObject private var userViewModel = UsersViewModel()
    @StateObject private var challengeViewModel = ChallengesViewModel()
    @StateObject private var challengeRunViewModel = ChallengeRunsViewModel()
    @StateObject private var participantViewModel = ParticipantsViewModel()
    @StateObject private var challengeFinancialsViewModel = ChallengeFinancialsViewModel()
        
    @State private var challengesWithRuns: [FetchedChallenge] = []
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    @AppStorage("uid") var userID: String = ""
    
    @State private var navigateToChallengeView = false
    @State private var transferedChallengeDetails : FetchedChallenge = FetchedChallenge(
        challenge: Challenge(
            id: 12,
            name: "Error Occured",
            description: "This is a detailed description of the sample challenge.",
            price: 99,
            capacity: 100,
            slowest_pace: 360,
            creator: "0", status: 0
        ),
        challengeRuns: [
            ChallengeRun(id: 1, challenge_id: 1, date: "2024-06-12", distance_km: 5),
            ChallengeRun(id: 2, challenge_id: 1, date: "2024-06-19", distance_km: 10)
        ],
        averageDistance: 3
    )
    
    func getUserChallengeStatus(challengeId : Int) -> (Int){
        
        for participant in self.participantViewModel.participants{
//            print(participant)
            if participant.challenge_id == challengeId && participant.user_id == self.userID{
                return participant.user_status
            }
        }
        return 1
    }
    
    func getParticipantByChallenge(challengeId : Int) -> (Participant){
        
        for participant in self.participantViewModel.participants{
//            print(participant)
            if participant.challenge_id == challengeId && participant.user_id == self.userID{
                return participant
            }
        }
        return Participant(id: 0, challenge_id: 0, user_id: "", user_status: 0)
    }
    
    func validateActiveChallange(gChallenge : FetchedChallenge) -> Bool {
        let status = gChallenge.challenge.status
        let userStatus = getUserChallengeStatus(challengeId: gChallenge.challenge.id ?? 1)
        return (status == 0 || status == 1) && userStatus != 2 ||
               (status == 2 && userStatus == 3)
    }

    func validateInActiveChallange(gChallenge : FetchedChallenge) -> Bool {
        let status = gChallenge.challenge.status
        let userStatus = getUserChallengeStatus(challengeId: gChallenge.challenge.id ?? 1)
        return (status == 2 && userStatus != 3 && status != 0) || userStatus == 2
    }

    var activeChallenges: [FetchedChallenge] {
        challengesWithRuns.filter { validateActiveChallange(gChallenge: $0) }
    }

    var inactiveChallenges: [FetchedChallenge] {
        challengesWithRuns.filter { validateInActiveChallange(gChallenge: $0) }
    }

    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0){
                Text("Активність")
                
                    .foregroundColor(Color(hex: "#1B1C1C"))
                    .font(.system(size: 32))
                    .padding(.bottom,ss(w: 27))
                    .padding(.leading,ss(w: 16))
                
                ScrollView(){
                    VStack(alignment: .leading, spacing: 0) {
                        
                        
                        Text("Активні челенджі")
                        
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 20))
                            .padding(.bottom,ss(w: 14))
                            .padding(.leading,ss(w: 18))
                        
                        
                        
                        if activeChallenges.count == 0{
                            Text("У немає активних челенджів")
                                .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 16))
                            .padding(.bottom,ss(w: 14))
                            .padding(.leading,ss(w: 18))
                        }
                        
                        ForEach(activeChallenges
                                                                                                                           , id: \.id) { el in
                            let ch = el.challenge
                            
                            if getUserChallengeStatus(challengeId: ch.id ?? 1) == 3 {
                                Button(action:{
                                    if let user = self.userViewModel.user {
                                        isLoading = true
                                        // Fetch challenge financials
                                        challengeFinancialsViewModel.fetchChallengeFinancials(challengeId: ch.id ?? 1) { result in
                                            switch result {
                                            case .success(let financials):
                                                let winnerEarnings = financials.winnerEarnings
                                                
                                                var participant = getParticipantByChallenge(challengeId: ch.id ?? 1)
                                                participant.user_status = 4
                                                participantViewModel.updateParticipant(participantId: participant.id ?? 1, participant: participant)
                                                
                                                userViewModel.partialUpdateUser(userId: userID, data: ["balance" : user.balance + winnerEarnings]){                                     isLoading = false
                                                }
                                            case .failure(let error):
                                                alertMessage = "Failed to fetch financials: \(error.localizedDescription)"
                                                                                                showAlert = true
                                            }
                                        }
                                    }
                                }) {
                                    HStack(spacing: 0){
                                        HStack(alignment: .center, spacing: 10) {
                                            if isLoading {
                                                                ProgressView()  // Loading spinner
                                                                    .frame(width: ss(w: 24), height: ss(w: 24), alignment: .leading)
                                                            } else {
                                                                Image("check-circle 1")
                                                                    .resizable()
                                                                    .frame(width: ss(w: 24), height: ss(w: 24), alignment: .leading)
                                                            }
                                            
                                        }
                                        .padding(8)
                                        .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                                        .cornerRadius(55555)
                                        .padding(.trailing, ss(w:16))
                                        
                                        Text("Забрати приз!")
                                        
                                            .foregroundColor(Color(hex: "#FFFFFF"))
                                            .font(.system(size: 20))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    }
                                    .padding(ss(w: 12))
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#07B29D"))
                                    .cornerRadius(12)
                                    .padding(.bottom,ss(w: 12))
                                    .padding(.horizontal,ss(w: 16))
                                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                                }.alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Error"),
                                        message: Text(alertMessage),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                            }else{
                                
                                Button(action:{
                                    navigateToChallengeView = true
                                    self.transferedChallengeDetails = el
                                }) {
                                    HStack(spacing: 0){
                                        Text(String(ch.name.prefix(1))) // Get the first letter of the challenge name
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: ss(w: 40), height: ss(w: 40)) // Circle dimensions
                                                    .background(backgroundColors[(ch.id ?? 1) % backgroundColors.count]) // Choose the background color you like
                                                    .clipShape(Circle()) // Make it circular
                                                    .padding(.trailing, ss(w: 15))
                                        
                                        VStack(alignment: .leading, spacing: 0){
                                            HStack {
                                                Text(ch.name)
                                                
                                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                                    .font(.system(size: 18))
                                                    .padding(.bottom,ss(w: 5))
                                                .padding(.leading,ss(w: 1))
                                                
                                            }
                                            
                                            Text("\(formatDate(el.startDate ?? Date())) / \(el.averageDistance) км")
                                            
                                                .foregroundColor(Color(hex: "#5D5E5E"))
                                                .font(.system(size: 16))
                                            
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing,ss(w: 4))
                                        
                                        Image("cheveron-right-b")
                                            .resizable()
                                            .frame(width : ss(w: 18), height: ss(w: 18), alignment: .leading)
                                        
                                        
                                    }
                                    .padding(ss(w: 12))
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#FDFDFD"))
                                    .cornerRadius(12)
                                    .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                                    .padding(.bottom,ss(w: 12))
                                .padding(.horizontal,ss(w: 16))
                                }.fullScreenCover(isPresented: $navigateToChallengeView, content: {
                                    ChallengeView(challengeDetails: self.$transferedChallengeDetails)
                                })
                            }
                            
                        }
                        
                        Text("Історія Челенджів")
                        
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 20))
                            .padding(.bottom,ss(w: 14))
                            .padding(.leading,ss(w: 18))
                        
                        if inactiveChallenges.count == 0{
                            Text("У вас ще немає завершених челенджів")
                                .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 16))
                            .padding(.bottom,ss(w: 14))
                            .padding(.leading,ss(w: 18))
                        }
                        ForEach(inactiveChallenges, id: \.id) { el in
                            let ch = el.challenge
                            
                            
                            
                            Button(action:{
                                navigateToChallengeView = true
                                self.transferedChallengeDetails = el
                            }) {
                                HStack(spacing: 0){
                                    Text(String(ch.name.prefix(1))) // Get the first letter of the challenge name
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                                .frame(width: ss(w: 40), height: ss(w: 40)) // Circle dimensions
                                                .background(backgroundColors[(ch.id ?? 1) % backgroundColors.count]) // Choose the background color you like
                                                .clipShape(Circle()) // Make it circular
                                                .padding(.trailing, ss(w: 15))
                                    
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack {
                                            Text("\(ch.name)")
                                            
                                                .foregroundColor(Color(hex: "#1B1C1C"))
                                                .font(.system(size: 18))
                                            .padding(.bottom,ss(w: 5))
                                            
                                            
                                            Image(getUserChallengeStatus(challengeId: el.challenge.id ?? 1) != 2 ? "check-circle" : "x-circle")
                                                .resizable()
                                                .frame(width: 24, height: 24, alignment: .leading)
                                                .padding(.horizontal, 9)
                                        }
                                        
                                        Text("\(formatDate(el.startDate ?? Date())) / \(el.averageDistance) км")
                                        
                                            .foregroundColor(Color(hex: "#5D5E5E"))
                                            .font(.system(size: 16))
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing,ss(w: 4))
                                    Image("cheveron-right-b")
                                            .resizable()
                                            .frame(width : ss(w: 18), height: ss(w: 18), alignment: .leading)
                                }
                                .padding(ss(w: 12))
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#FDFDFD"))
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                                .padding(.bottom,ss(w: 12))
                            .padding(.horizontal,ss(w: 16))
                            }.fullScreenCover(isPresented: $navigateToChallengeView, content: {
                                ChallengeView(challengeDetails: self.$transferedChallengeDetails)
                            })
                        }
                                
                            }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(Color(hex: "#FDFDFD"))
                .cornerRadius(20)
            }
            .padding(.top,0.1)
            .padding(.bottom,0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(hex: "#FFFFFF"))
            .padding(.bottom, 75)
            .onAppear {
                challengeViewModel.loadUserChallenges(userId: self.userID)
                participantViewModel.fetchParticipants()
                userViewModel.getUser(userId: self.userID)
            }
            .onReceive(challengeViewModel.$challenges) { challenges in
                
                guard !challenges.isEmpty else { return }
                for x in 0..<(challenges.count) {
                    
                        let challenge = challenges[x]
                        challengeRunViewModel.fetchChallengeRunsByChallengeId(challengeId: challenge.id ?? 1) {
                            // This block will only be executed after the data is fetched
                            let runs = challengeRunViewModel.challengeRuns
                            let totalDistance = runs.reduce(0) { $0 + $1.distance_km }
                            let avgDist = runs.isEmpty ? 0 : Int(Double(totalDistance) / Double(runs.count))
                            
                            let firstRun = runs.sorted(by: { $0.date < $1.date }).first
                            let startDate = firstRun?.date.toDate(withFormat: "yyyy-MM-dd")
                            
                            let fetchedChallenge = FetchedChallenge(id: challenge.id, challenge: challenge, challengeRuns: runs, averageDistance: avgDist, startDate: startDate)
                            self.challengesWithRuns.append(fetchedChallenge)
                        
                    }
                }
        }
            
//            VStack {
//                Spacer()
//                NavigationBarView(selectedTabIndex: .constant(1))
//            }
        }
    }
}

#Preview {
    AvtivityView()
}
