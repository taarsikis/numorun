//
//  ChallengeViewRuns.swift
//  Numo test1
//
//  Created by Тасік on 12.06.2024.
//

import SwiftUI

struct ChallengeViewCompletedRuns: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @AppStorage("uid") var userID: String = ""
    @State private var runViewModel = RunsViewModel()
    
    @State private var runList : [Run] = []
    var runs : [ChallengeRun]
    var pace : Int
    
    func validateRun (run : ChallengeRun) -> (Bool){
        print("Validating....")
        print(run)
        for element in runList{
            print("Checking")
            print(element)
            if run.date == element.date
                && Int(element.distance) >= run.distance_km * 1000
                && Int(element.pace)*60 <= pace {
                
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
            return day1 >= day2
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
    
    var body: some View {
        VStack{
            
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
                
                Text("Список пробіжок")
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
            
            
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        ForEach(runs.sorted(by: {$0.date.toDate(withFormat: "yyyy-MM-dd") ?? Date() < $1.date.toDate(withFormat: "yyyy-MM-dd") ?? Date()}), id: \.id) { run in
                            
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
                            .padding(.bottom,ss(w: 12))
                            
                        }
                        
                    }.padding(10)
                }
                .background(Color(hex: "#FDFDFD"))
                .cornerRadius(12)
                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                .padding(.horizontal)
            .padding(.bottom, ss(w:36))
            }
            
            Spacer()
        }.onAppear{
            runViewModel.fetchRunsByUserId(userId: userID)
            
        }
        .onReceive(runViewModel.$runs) { runs in
            for run in runs{
                print(run.id)
                self.runList.append(run)
            }
        }
    }
}

struct ChallengeViewCompletedRuns_Previews: PreviewProvider {
    static func ss(w: Double) -> CGFloat {
        return CGFloat(w) // Simplified for preview purposes
    }
    
    static var previews: some View {
        ChallengeViewCompletedRuns(runs: [
            ChallengeRun(id: 1, challenge_id: 1, date: Date().toString(withFormat: "yyyy-MM-dd"), distance_km: 5),
            ChallengeRun(id: 2, challenge_id: 2, date: "2024-07-15", distance_km: Int(7.5)),
            ChallengeRun(id: 3, challenge_id: 3, date: "2024-07-31", distance_km: Int(0.00001))
        ], pace: 540)
        .environmentObject(UserData()) // Assuming UserData conforms to ObservableObject
    }
}
