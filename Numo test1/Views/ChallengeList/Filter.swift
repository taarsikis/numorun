//
//  Filter.swift
//  Numo test1
//
//  Created by Тасік on 11.06.2024.
//

import SwiftUI
import URLImage

struct Filter: View {
    
    @Binding var isPressedLowerThan10Runs  : Bool
    @Binding var isPressedLowerThan20Runs : Bool
    @Binding var isPressedAbove20Runs : Bool
    
    @Binding var isPressedLowerThan5km : Bool
    @Binding var isPressedLowerThan15km : Bool
    @Binding var isPressedAbove15km : Bool
    
    @Binding var isPressedLowerThan1000 : Bool
    @Binding var isPressedLowerThan4000 : Bool
    @Binding var isPressedAbove4000 : Bool
    
    @Binding var isFilterShowed : Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0){
                        Text("Фільтр")
                        
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 24))
                            .padding(.bottom,ss(w: 20))
                            .padding(.leading,ss(w: 151))
                            .padding(.top, ss(w:20))
                        
                        Text("Кількість пробіжок у Челенджі")
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .padding(.bottom,ss(w: 11))
                            .padding(.leading,ss(w: 18))
                        
                        HStack(spacing: 0){
                            Button(action: {
                                if isPressedLowerThan10Runs{
                                    isPressedLowerThan10Runs = false
                                }else{
                                    isPressedLowerThan10Runs = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("4-10")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan10Runs ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan10Runs ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedLowerThan20Runs{
                                    isPressedLowerThan20Runs = false
                                }else{
                                    isPressedLowerThan20Runs = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("10-20")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan20Runs ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan20Runs ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedAbove20Runs{
                                    isPressedAbove20Runs = false
                                }else{
                                    isPressedAbove20Runs = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("Більше 20")
                                    
                                        .foregroundColor(Color(hex: isPressedAbove20Runs ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedAbove20Runs ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom,ss(w: 20))
                        .padding(.horizontal,ss(w: 17))
                        
                        
                        Text("Середня відстань пробіжок")
                        
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .padding(.bottom,ss(w: 16))
                            .padding(.leading,ss(w: 17))
                        
                        HStack(spacing: 0){
                            Button(action: {
                                if isPressedLowerThan5km{
                                    isPressedLowerThan5km = false
                                }else{
                                    isPressedLowerThan5km = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("1-5 км")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan5km ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan5km ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedLowerThan15km{
                                    isPressedLowerThan15km = false
                                }else{
                                    isPressedLowerThan15km = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("5-15 км")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan15km ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan15km ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedAbove15km{
                                    isPressedAbove15km = false
                                }else{
                                    isPressedAbove15km = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("Більше 15 км")
                                    
                                        .foregroundColor(Color(hex: isPressedAbove15km ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedAbove15km ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom,ss(w: 20))
                        .padding(.horizontal,ss(w: 17))
                        
                        Text("Ціна")
                        
                            .foregroundColor(Color(hex: "#1B1C1C"))
                            .font(.system(size: 18))
                            .padding(.bottom,ss(w: 16))
                            .padding(.leading,ss(w: 18))
                        
                        HStack(spacing: 0){
                            Button(action: {
                                if isPressedLowerThan1000{
                                    isPressedLowerThan1000 = false
                                }else{
                                    isPressedLowerThan1000 = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("До 1000 грн.")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan1000 ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan1000 ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedLowerThan4000{
                                    isPressedLowerThan4000 = false
                                }else{
                                    isPressedLowerThan4000 = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("1000-4000 грн.")
                                    
                                        .foregroundColor(Color(hex: isPressedLowerThan4000 ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedLowerThan4000 ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                            Spacer()
                            Button(action: {
                                if isPressedAbove4000{
                                    isPressedAbove4000 = false
                                }else{
                                    isPressedAbove4000 = true
                                }
                            }){
                                VStack(spacing: 0){
                                    Text("Більше 4000 грн.")
                                    
                                        .foregroundColor(Color(hex: isPressedAbove4000 ? "#FDFDFD" : "#9FA0A0"))
                                        .font(.system(size: 12))
                                    
                                }
                                .padding(.vertical,ss(w: 12))
                                .frame(width : ss(w: 110))
                                .background(Color(hex: isPressedAbove4000 ? "#07B29D" : "#EDEDED"))
                                .cornerRadius(6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom,ss(w: 20))
                        .padding(.horizontal,ss(w: 17))
                        
                        
                        HStack(spacing: 0){
                            Button(action:{
                                self.isPressedLowerThan10Runs = false
                                self.isPressedLowerThan20Runs = false
                                self.isPressedAbove20Runs = false
                                
                                self.isPressedLowerThan5km = false
                                self.isPressedLowerThan15km = false
                                self.isPressedAbove15km = false
                                
                                self.isPressedLowerThan1000 = false
                                self.isPressedLowerThan4000 = false
                                self.isPressedAbove4000 = false
                            }) {
                                VStack(spacing: 0){
                                    Text("Скинути")
                                    
                                        .foregroundColor(Color(hex: "#07B29D"))
                                        .font(.system(size: 16))
                                    
                                }
                                .padding(.vertical,ss(w: 16))
                                .frame(width : ss(w: 167))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#07B29D"), lineWidth: 1))
                            }
                            
                            Spacer()
                            
                            Button(action:{
                                self.isFilterShowed = false
                            })
                            {
                                VStack(spacing: 0){
                                    Text("Застосувати")
                                    
                                        .foregroundColor(Color(hex: "#FDFDFD"))
                                        .font(.system(size: 16))
                                    
                                }
                                .padding(.vertical,ss(w: 16))
                                .frame(width : ss(w: 167))
                                .background(Color(hex: "#07B29D"))
                                .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom,ss(w: 65))
                        .padding(.horizontal,ss(w: 15))
                    }
                    .padding(.top,ss(w: 43))
                    .padding(.bottom,ss(w: 8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#FDFDFD"))
                    
                }
        }
//        .padding(.top,0.1)
        .padding(.bottom,0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(hex: "#FFFFFF"))
        
    }
}



struct Filter_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isPressedLowerThan10Runs = false
        @State private var isPressedLowerThan20Runs = false
        @State private var isPressedAbove20Runs = false
        
        @State private var isPressedLowerThan5km = false
        @State private var isPressedLowerThan15km = false
        @State private var isPressedAbove15km = false
        
        @State private var isPressedLowerThan1000 = false
        @State private var isPressedLowerThan4000 = false
        @State private var isPressedAbove4000 = false
        
        @State private var isFilterShowed = true  // Assume you want to show the filter in the preview

        var body: some View {
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
                isFilterShowed: $isFilterShowed
            )
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
