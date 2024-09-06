//
//  ProfileUserRuns.swift
//  Numo test1
//
//  Created by Тасік on 27.06.2024.
//

import SwiftUI

struct ProfileUserRuns: View {
    @AppStorage("uid") var userID: String = ""
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @State private var runViewModel = RunsViewModel()
    
    @State private var runList : [Run] = []
    
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
            
            if self.runList.isEmpty{
                Text("У вас ще немає пробіжок")
                    .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 16))
                .padding(.bottom,ss(w: 14))
            }
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        ForEach(self.runList, id: \.id) { run in

                            HStack(spacing: 0){
                                VStack(alignment: .leading){
                                    
                                        Text(run.date.toDate(withFormat: "yyyy-MM-dd") ?? Date(), style: .date)
                                            .foregroundColor(Color(hex: "#1B1C1C"))
                                            .font(.system(size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    
                                        Text(run.city)
                                            .foregroundColor(Color(hex: "#5D5E5E"))
                                        .font(.system(size: 16))
                                    
                                }
                                .padding(.trailing,ss(w: 4))
                                
                                VStack {
                                    Text(formatDistance(run.distance))
                                        .foregroundColor(Color(hex: "#5D5E5E"))
                                    .font(.system(size: 16))
                                    .padding(.top, ss(w:1))
                                    
                                    Text(formatDuration(run.duration))
                                        .foregroundColor(Color(hex: "#5D5E5E"))
                                    .font(.system(size: 16))
                                    .padding(.top, ss(w:1))
                                    
                                    Text(formatPace(run.pace))
                                        .foregroundColor(Color(hex: "#5D5E5E"))
                                    .font(.system(size: 16))
                                    .padding(.top, ss(w:1))
                                }
//                                Image("check-circle") // x-circle
//                                    .resizable()
//                                    .frame(width: 24, height: 24, alignment: .leading)
//                                    .padding(.horizontal, 9)
                            }
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
    
    
    private func formatPace(_ pace: Double) -> String {
        let paceMin = Int(pace)
        let paceSec = Int((pace - Double(paceMin)) * 60)
        return String(format: "%d:%02d хв/км", paceMin, paceSec)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let durationMinutes = Int(duration / 60)
        let durationSeconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d хв", durationMinutes, durationSeconds)
    }

    private func formatDistance(_ distance: Double) -> String {
        String(format: "%.2f км", distance / 1000)
    }
}

#Preview {
    ProfileUserRuns()
}
