//
//  InputField.swift
//  Numo test1
//
//  Created by Тасік on 02.04.2024.
//

import SwiftUI

enum FieldState {
    case passive, active, success, warning, error, blocked
}

struct InputField: View {
    @Binding var text: String
    var placeholder: String
    var imageName: String?
    var isSecure: Bool
    var baseString: String
    @Binding var state: FieldState
    var hint: String? // Hint is optional
    @Binding var isPasswordVisible: Bool? // Make it optional
    @FocusState private var isInputActive: Bool
    
    private var imageColor: Color {
            switch state {
            case .passive:
                return Color(.black)
            case .active:
                return Color(.black)
            case .success:
                return Color(hex: "09D059")
            case .warning:
                return Color(hex: "EBC248")
            case .error:
                return Color(hex: "EB6048")
            case .blocked:
                return Color(hex: "C6C6C6")
            }
        }
    
    private var borderColor: Color{
        switch state{
        case .passive:
            return Color(hex: "C6C6C6")
        case .active:
            return Color(hex: "07B29D")
        case .success:
            return Color(hex: "09D059")
        case .warning:
            return Color(hex: "EBC248")
        case .error:
            return Color(hex: "EB6048")
        case .blocked:
            return Color(hex: "C6C6C6")
        }
    }
    
    private var hintFontColor: Color{
        switch state{
        case .passive:
            return Color(hex: "5D5E5E")
        case .active:
            return Color(hex: "5D5E5E")
        case .success:
            return Color(hex: "09D059")
        case .warning:
            return Color(hex: "EBC248")
        case .error:
            return Color(hex: "EB6048")
        case .blocked:
            return Color(hex: "5D5E5E")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(placeholder)
                .foregroundColor(imageColor)
                .font(.system(size: 20))
                .padding(.bottom, 8)
            
            HStack(spacing: 0) {
                if let imageName = imageName {
                                    Image(imageName)
                                        .foregroundColor(imageColor)
                                        .font(.system(size: 20))
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                        .padding(.bottom, 8)
                                }
                
                if isSecure, let isPasswordVisible = isPasswordVisible, !isPasswordVisible {
                    SecureField(baseString, text: $text)
                        .foregroundColor(imageColor)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .focused($isInputActive)
                        .padding(.top, 8.5)
                        .padding(.bottom, 8.5)
                    
                        .padding(.leading, 8)
                    
                } else {
                    TextField(baseString, text: $text, onEditingChanged: { isEditing in
                        self.state = isEditing ? .active : .passive
                    })
                    .foregroundColor(imageColor)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
                    .focused($isInputActive)
                    .padding(.top, 8.5)
                    .padding(.bottom, 8.5)
                    
                    .padding(.leading, 8)
                }
                
                if isSecure {
                    Button(action: { self.isPasswordVisible?.toggle() }) {
                        Image(systemName: isPasswordVisible ?? false ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(imageColor)
                            .padding(.trailing, 10)
                            .padding(.leading, 8)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(9.6)
            .overlay(RoundedRectangle(cornerRadius: 9.6)
                .stroke(borderColor, lineWidth: 1))
            
            .onChange(of: isInputActive, perform: {
                state = $0 ? .active : .passive
            })
            
            if let hint = hint {
                if state != .active{
                    Text(hint)
                        .font(.caption)
                        .foregroundColor(hintFontColor)
                        .padding(.top, 4)
                }
                        }
            
        }.onTapGesture {
            self.isInputActive = true
        }
    }
}


struct ContentViewInputField: View {
    @State var password: String = ""
    @State var isPasswordVisible: Bool? = false // To control password visibility

    var body: some View {
        
        InputField(text: $password, placeholder: "Пароль", imageName: "lock-closed", isSecure: true, baseString: "NuMo345$s_df", state: .constant(.success), hint: "text", isPasswordVisible: $isPasswordVisible)
            .padding(20)
    }
}


#Preview {
    ContentViewInputField()
}
