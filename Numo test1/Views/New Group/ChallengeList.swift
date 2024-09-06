import SwiftUI
import URLImage

struct ChallengeList: View {
    
    @StateObject private var challengeViewModel = ChallengesViewModel()
    @StateObject private var challengeRunViewModel = ChallengeRunsViewModel()
    @State private var challengesWithRuns: [FetchedChallenge] = []
    @State private var listLength = 0
    
    @State private var navigateToCreationName = false
    @State private var navigateToCreationName1 = false
    @State private var navigateToChallengeSearch = false
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
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Список Челенджів")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 32))
                        .padding(.bottom, ss(w: 21))
                        .padding(.leading, ss(w: 17))
                    
                    Button(action:{
                        navigateToChallengeSearch = true
                    }){
                        HStack(spacing: 0) {
                            Image("search")
                                .resizable()
                                .frame(width: ss(w: 20), height: ss(w: 20), alignment: .leading)
                                .padding(.trailing, ss(w: 12))
                            
                            Text("Пошук")
                                .foregroundColor(Color(hex: "#9FA0A0"))
                                .font(.system(size: 16))
                            
                            VStack(alignment: .leading, spacing: 0) {}
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image("adjustments")
                                .resizable()
                                .frame(width: ss(w: 20), height: ss(w: 20), alignment: .leading)
                        }
                        .padding(.vertical, ss(w: 13))
                        .padding(.horizontal, ss(w: 11))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#C6C6C6"), lineWidth: 1))
                        .padding(.bottom, ss(w: 24))
                        .padding(.horizontal, ss(w: 16))
                    }.fullScreenCover(isPresented: $navigateToChallengeSearch, content: {
                        ChallengeSearch()
                    })
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Створи власний Челендж")
                                    .foregroundColor(Color(hex: "#FDFDFD"))
                                    .font(.system(size: 18))
                                    .padding(.bottom, ss(w: 4))
                                
                                Text("Задай унікальні критерії")
                                    .foregroundColor(Color(hex: "#FDFDFD"))
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, ss(w: 4))
                            
                            Button(action: {
                                navigateToCreationName = true
                            }) {
                                Image("cheveron-right")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, ss(w: 14))
                        .fullScreenCover(isPresented: $navigateToCreationName, content: {
                            CreationName()
                        })
                        
                        Button(action: {
                            navigateToCreationName1 = true
                        }) {
                            VStack(spacing: 0) {
                                Spacer()
                                Text("Створити!")
                                    .foregroundColor(Color(hex: "#1B1C1C"))
                                    .font(.system(size: 12))
                                Spacer()
                            }
                            .padding(.vertical, ss(w: 13))
                            .frame(width: ss(w: 97), height: ss(w: 32))
                            .background(Color(hex: "#FDFDFD"))
                            .cornerRadius(12)
                        }
                        .fullScreenCover(isPresented: $navigateToCreationName1, content: {
                            CreationName()
                        })
                    }
                    .padding(.vertical, ss(w: 17))
                    .padding(.horizontal, ss(w: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#07B29D"))
                    .cornerRadius(12)
                    .padding(.bottom, ss(w: 30))
                    .padding(.horizontal, ss(w: 16))
                    
                    Text("Рекомендовані Челенджі")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 20))
                        .padding(.bottom, ss(w: 12))
                        .padding(.leading, ss(w: 18))
                    
                    ForEach(self.challengesWithRuns.filter { $0.challenge.status == 0 }, id: \.id) { el in
                        let ch = el.challenge
                        
                        Button(action:{
                            navigateToChallengeView = true
                            self.transferedChallengeDetails = el
                        }) {
                            VStack {
                                HStack(spacing: 0) {
                                    Text(String(ch.name.prefix(1))) // Get the first letter of the challenge name
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                                .frame(width: ss(w: 40), height: ss(w: 40)) // Circle dimensions
                                                .background(backgroundColors[(ch.id ?? 1) % backgroundColors.count]) // Choose the background color you like
                                                .clipShape(Circle()) // Make it circular
                                                .padding(.trailing, ss(w: 15))
                                    
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(ch.name)
                                            .foregroundColor(Color(hex: "#1B1C1C"))
                                            .font(.system(size: 18))
                                            .padding(.bottom, ss(w: 6))
                                            .padding(.leading, ss(w: 2))
                                        
                                        Text("\(formatDate(el.startDate ?? Date())) / \(el.averageDistance) км")
                                            .foregroundColor(Color(hex: "#5D5E5E"))
                                            .font(.system(size: 16))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing, ss(w: 4))
                                    
                                    Text("₴ \(String(ch.price))")
                                        .foregroundColor(Color(hex: "#1B1C1C"))
                                        .font(.system(size: 16))
                                        .padding(.trailing, ss(w: 12))
                                    
                                    Image("cheveron-right-b")
                                        .resizable()
                                        .frame(width: ss(w: 20), height: ss(w: 20), alignment: .leading)
                                }
                                .frame(maxWidth: .infinity)
                            .padding(.horizontal, ss(w: 16))
                                VStack(alignment: .leading, spacing: 0) {}
                                    .frame(height: ss(w: 1))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(hex: "#C6C6C6"))
                                    .padding(.bottom, ss(w: 7))
                                    .padding(.horizontal, ss(w: 30))
                            }
                            
                            
                        }}.fullScreenCover(isPresented: $navigateToChallengeView, content: {
                            ChallengeView(challengeDetails: self.$transferedChallengeDetails)
                        })
                    
                    
                    
                    
                }
                
                if listLength < challengeViewModel.challenges.count {
                    Button(action: {
                        let challenges = challengeViewModel.challenges.filter { $0.status == 0 }
                        for x in listLength..<(listLength + 10) {
                            if x < challenges.count {
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
                        self.listLength += 10
                    }) {
                        Text("Переглянути більше")
                            .foregroundColor(Color(hex: "#07B29D"))
                    }
                }
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(hex: "#FDFDFD"))
            .cornerRadius(20)
            
        .padding(.bottom, ss(w:75))
            .onAppear {
                challengeViewModel.fetchChallenges()
            }
            .onReceive(challengeViewModel.$challenges) { challenges in
                
                guard !challenges.isEmpty else { return }
                let filteredChallenges = challenges.filter { $0.status == 0 }
                print(filteredChallenges)
                for x in listLength..<(listLength + 4) {
                    if x < filteredChallenges.count {
                        let challenge = filteredChallenges[x]
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
                                self.listLength += 4
            }
            
//            VStack {
//                Spacer()
//                NavigationBarView(selectedTabIndex: .constant(1))
//            }
        }
        
    }
}

#Preview {
    ChallengeList()
}
