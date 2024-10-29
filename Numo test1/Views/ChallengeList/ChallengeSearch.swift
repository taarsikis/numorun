//
//  ChallengeSearch.swift
//  Numo test1
//
//  Created by Тасік on 11.06.2024.
//

import SwiftUI

struct ChallengeSearch: View {
    
    @StateObject private var challengeViewModel = ChallengesViewModel()
    @StateObject private var challengeRunViewModel = ChallengeRunsViewModel()
    @State private var challengesWithRuns: [FetchedChallenge] = []
    @State private var listLength = 0
    
    @State private var navigateToCreationName = false
    @State private var navigateToCreationName1 = false
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText = ""
    @State private var showingFilter = false
    
    @State private var isPressedLowerThan10Runs = false
    @State private var isPressedLowerThan20Runs = false
    @State private var isPressedAbove20Runs = false
    
    @State private var isPressedLowerThan5km = false
    @State private var isPressedLowerThan15km = false
    @State private var isPressedAbove15km = false
    
    @State private var isPressedLowerThan1000 = false
    @State private var isPressedLowerThan4000 = false
    @State private var isPressedAbove4000 = false
    
    @State private var navigateToChallengeView = false
    @State private var transferedChallengeDetails : FetchedChallenge = FetchedChallenge(
        challenge: Challenge(
            id: 12,
            name: "Error Occured" ,
            description: "This is a detailed description of the sample challenge.",
            price: 99,
            capacity: 100,
            slowest_pace: 360,
            creator: "0", status: 0
        ),
        challengeRuns: [
            ChallengeRun(id: 1,challenge_id: 1, date: "2024-06-12", distance_km: 5),
            ChallengeRun(id: 2, challenge_id: 1, date: "2024-06-19", distance_km: 10)
        ],
        averageDistance: 3
    )
    
    private var isFilterApplied : Bool {
        if isPressedAbove15km || isPressedAbove4000 || isPressedAbove20Runs || isPressedLowerThan5km || isPressedLowerThan1000 || isPressedLowerThan15km || isPressedLowerThan4000 || isPressedLowerThan10Runs || isPressedLowerThan20Runs {
            return true
        }else{
            return false
        }
    }

    private var searchChallenges: [FetchedChallenge] {
        var result: [FetchedChallenge] = []
        
        for element in self.challengesWithRuns {
            if filterValidateElement(element: element) {
                if searchText.isEmpty {
                    result.append(element)
                } else if element.challenge.name.contains(searchText) {
                    result.append(element)
                }
            }
        }
        
        // Sort the result in descending order by challenge.id before returning
        return result.sorted(by: { ($0.challenge.id ?? 0) > ($1.challenge.id ?? 1) })
    }

    
    func filterValidateElement(element: FetchedChallenge) -> Bool {
        if !isFilterApplied {
            return true
        }
        
        var matchesRunFilter = false
        if isPressedLowerThan10Runs && element.challengeRuns.count <= 10 {
            matchesRunFilter = true
        } else if isPressedLowerThan20Runs && element.challengeRuns.count <= 20 && element.challengeRuns.count >= 10 {
            matchesRunFilter = true
        } else if isPressedAbove20Runs && element.challengeRuns.count >= 20 {
            matchesRunFilter = true
        } else if !isPressedLowerThan10Runs && !isPressedLowerThan20Runs && !isPressedAbove20Runs {
            matchesRunFilter = true  // No run filter is active
        }
        
        var matchesPriceFilter = false
        if isPressedLowerThan1000 && element.challenge.price <= 1000 {
            matchesPriceFilter = true
        } else if isPressedLowerThan4000 && element.challenge.price <= 4000 && element.challenge.price > 1000 {
            matchesPriceFilter = true
        } else if isPressedAbove4000 && element.challenge.price >= 4000 {
            matchesPriceFilter = true
        } else if !isPressedLowerThan1000 && !isPressedLowerThan4000 && !isPressedAbove4000 {
            matchesPriceFilter = true  // No price filter is active
        }
        
        var matchesDistanceFilter = false
        if isPressedLowerThan5km && element.averageDistance <= 5 {
            matchesDistanceFilter = true
        } else if isPressedLowerThan15km && element.averageDistance <= 15 && element.averageDistance > 5 {
            matchesDistanceFilter = true
        } else if isPressedAbove15km && element.averageDistance >= 15 {
            matchesDistanceFilter = true
        } else if !isPressedLowerThan5km && !isPressedLowerThan15km && !isPressedAbove15km {
            matchesDistanceFilter = true  // No distance filter is active
        }
        
        return matchesRunFilter && matchesPriceFilter && matchesDistanceFilter
    }

    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 0) {
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
                    
                    Text("Пошук челенджу")
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
                
                //                Text("Список Челенджів")
                //                    .foregroundColor(Color(hex: "#1B1C1C"))
                //                    .font(.system(size: 32))
                //                    .padding(.bottom, ss(w: 21))
                //                    .padding(.leading, ss(w: 17))
                
                HStack(spacing: 0) {
                    Image("search")
                        .resizable()
                        .frame(width: ss(w: 20), height: ss(w: 20), alignment: .leading)
                        .padding(.leading, ss(w: 12))
                    
                    TextField("Пошук", text: $searchText) // Replaced Text with TextField
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 16))
                        .padding(.vertical, ss(w: 13))
                        .padding(.horizontal, ss(w: 11))
                    
                    Button(action:{
                        showingFilter = true
                    }){
                        Image(isFilterApplied ? "adjustments-a" : "adjustments")
                            .resizable()
                            .frame(width: ss(w: 20), height: ss(w: 20), alignment: .leading)
                            .padding(.trailing, ss(w:12))
                    }
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#C6C6C6"), lineWidth: 1))
                .padding(.bottom, ss(w: 24))
                .padding(.horizontal, ss(w: 16))
                
                if self.searchChallenges.count == 0{
                    Text("За даним запитом нічого не знайдено")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 20))
                        .padding(.bottom, ss(w: 12))
                        .padding(.leading, ss(w: 18))
                }
                ScrollView {
                    
                    ForEach(self.searchChallenges, id: \.id) { el in
                        let ch = el.challenge
                        
                        Button(action:{
                            navigateToChallengeView = true
                            self.transferedChallengeDetails = el
                        }) {
                            
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
                            .padding(.bottom, ss(w: 8))
                        .padding(.horizontal, ss(w: 16))
                        }.fullScreenCover(isPresented: $navigateToChallengeView, content: {
                            ChallengeView(challengeDetails: self.$transferedChallengeDetails)
                        })
                        
                        VStack(alignment: .leading, spacing: 0) {}
                            .frame(height: ss(w: 1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#C6C6C6"))
                            .padding(.bottom, ss(w: 7))
                            .padding(.horizontal, ss(w: 30))
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(hex: "#FDFDFD"))
            .cornerRadius(20)
            .onAppear {
                challengeViewModel.fetchChallenges()
            }
            .onReceive(challengeViewModel.$challenges) { challenges in
                guard !challenges.isEmpty else { return }
                for x in 0..<(challenges.count) {
                    if x < challenges.count {
                        let challenge = challenges[x]
                        challengeRunViewModel.fetchChallengeRunsByChallengeId(challengeId: challenge.id ?? 1) {
                            // This block will only be executed after the data is fetched
                            let runs = challengeRunViewModel.challengeRuns
                            let totalDistance = runs.reduce(0) { $0 + $1.distance_km }
                            let avgDist = runs.isEmpty ? 0 : Int(Double(totalDistance) / Double(runs.count))
                            
                            let firstRun = runs.sorted(by: { $0.date < $1.date }).first
                            //                            let dateFormatter = ISO8601DateFormatter()
                            let startDate = firstRun?.date.toDate(withFormat: "yyyy-MM-dd") //dateFormatter.date(from: firstRun?.date ?? "")
                            
                            let fetchedChallenge = FetchedChallenge(id: challenge.id, challenge: challenge, challengeRuns: runs, averageDistance: avgDist, startDate: startDate)
                            self.challengesWithRuns.append(fetchedChallenge)
                        }
                    }
                }
            }
            
            
            if showingFilter {
                // Background dimming
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Dismiss the Filter view when tapping the background
                        showingFilter = false
                    }
                
                // Filter view configuration
                VStack {
                    Spacer()  // This spacer pushes the Filter view to the bottom half
                    Filter(
                        isPressedLowerThan10Runs: $isPressedLowerThan10Runs,
                        isPressedLowerThan20Runs: $isPressedLowerThan20Runs,
                        isPressedAbove20Runs: $isPressedAbove20Runs,
                        isPressedLowerThan5km: $isPressedLowerThan5km,
                        isPressedLowerThan15km: $isPressedLowerThan15km,
                        isPressedAbove15km: $isPressedAbove15km,
                        isPressedLowerThan1000: $isPressedLowerThan1000,
                        isPressedLowerThan4000: $isPressedLowerThan4000,
                        isPressedAbove4000: $isPressedAbove4000,
                        isFilterShowed: $showingFilter
                    )
                        .frame(height: UIScreen.main.bounds.height / 2)  // Set the height to half of the screen
                        .transition(.move(edge: .bottom))  // Transition effect from the bottom
                        .background(Color.white)  // Set the background color to white
                        .cornerRadius(20, corners: [.topLeft, .topRight])  // Rounded corners on the top
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(showingFilter)
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    ChallengeSearch()
}
