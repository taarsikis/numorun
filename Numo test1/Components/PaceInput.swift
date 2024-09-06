import SwiftUI

enum FieldStatePace {
    case passive, active, success, warning, error, blocked

    var borderColor: Color {
        switch self {
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
}

struct PaceInput: View {
    @Binding var minutes: String
    @Binding var seconds: String
    @FocusState private var isMinutesFocused: Bool
    @FocusState private var isSecondsFocused: Bool
    @Binding var state: FieldStatePace

    // Custom binding to ensure the input is numeric only and within valid range
    private var minutesBinding: Binding<String> {
        Binding<String>(
            get: { self.minutes },
            set: {
                let filtered = String($0.filter { "0123456789".contains($0) })
                if let intValue = Int(filtered), intValue > 30 {
                    self.minutes = "30"
                    state = .error // Set to error state if minutes exceed 30
                } else {
                    self.minutes = filtered
                    state = .active // Set to active as the user types
                }
            }
        )
    }

    private var secondsBinding: Binding<String> {
        Binding<String>(
            get: { self.seconds },
            set: {
                var filtered = String($0.filter { "0123456789".contains($0) })
                if let intValue = Int(filtered) {
                    if intValue > 59 {
                        filtered = "59"
                        state = .error // Set to error state if seconds exceed 59
                    }
                    self.seconds = String(format: "%02d", Int(filtered) ?? 0)
                } else {
                    self.seconds = "00"
                }
                state = .active // Set to active as the user types
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                TextField("", text: minutesBinding)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .foregroundColor(Color.black)
                    .font(.system(size: 40))
                    .padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(state.borderColor, lineWidth: 2))
                    .focused($isMinutesFocused)
                    .onChange(of: isMinutesFocused) { focused in
                        state = focused ? .active : .passive
                    }.onTapGesture {
                        isMinutesFocused = true
                        minutes = ""
                    }

                Text(":")
                    .font(.system(size: 40))

                TextField("", text: secondsBinding)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .foregroundColor(Color.black)
                    .font(.system(size: 40))
                    .padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(state.borderColor, lineWidth: 2))
                    .focused($isSecondsFocused)
                    .onChange(of: isSecondsFocused) { focused in
                        state = focused ? .active : .passive
                    }
                    .onTapGesture {
                        isSecondsFocused = true
                        seconds = ""
                    }

                Text("хв/км")
                    .font(.system(size: 20))
                    .padding(.leading, 10)

                Spacer()
            }
        }
    }
}

struct ContentViewPaceInput: View {
    @State private var minutes: String = "5"
    @State private var seconds: String = "00"
    @State private var state: FieldStatePace = .active

    var body: some View {
        PaceInput(minutes: $minutes, seconds: $seconds, state: $state)
            .padding(20)
    }
}

struct ContentViewPaceInput_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewPaceInput()
    }
}

