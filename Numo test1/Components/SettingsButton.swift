//
//  SettingsButton.swift
//  Numo test1
//
//  Created by Тасік on 06.04.2024.
//

import SwiftUI

struct SettingsButton: View {
    var text : String
    var imageName: String
    
    var body: some View {
        HStack(spacing: 0){
            Text(text)
                .foregroundColor(Color(hex: "#1B1C1C"))
                .font(.system(size: 16))
            Spacer()
            Image(imageName)
                    .resizable()
                    .frame(width : 24, height: 24)
            
        }
        .padding(.vertical,15.5)
        .padding(.horizontal,8)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .cornerRadius(9.6)
        .overlay(RoundedRectangle(cornerRadius: 9.6)
            .stroke(Color(hex: "#C6C6C6"), lineWidth: 1))
    }
}

#Preview {
    SettingsButton(text: "Test text", imageName: "cog")
}
