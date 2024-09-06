//
//  CreationListOfRuns.swift
//  Numo test1
//
//  Created by Тасік on 16.05.2024.
//

import SwiftUI

struct CreationListOfRuns: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @Binding var runs : [RunningDay]
    
//    let runs = [
//        ("23 Жовт 2023", "5 km"),
//        ("27 Жовт 2023", "7 km"),
//        ("01 Лист 2023", "5 km"),
//        ("05 Лист 2023", "7 km"),
//        ("23 Жовт 2023", "5 km"),
//
//        ("10 Лист 2023", "5 km")
//    ]
    
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
                        
                    }.padding(10)
                }
                .background(Color(hex: "#FDFDFD"))
                .cornerRadius(12)
                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                .padding(.horizontal)
            .padding(.bottom, ss(w:36))
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    CreationListOfRuns()
//}
