import SwiftUI

enum FieldStateNum {
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

struct NumericInput: View {
    @Binding var amount: String
    
    var placeholder: String
    var currencySymbol: String? // Default is nil, can be set to any currency symbol
    @FocusState private var isInputActive: Bool
    @Binding var state: FieldStateNum

    // Custom binding to ensure the input is numeric only
//    private var numericBinding: Binding<String> {
//        Binding<String>(
//            get: { self.amount },
//            set: {
//                self.amount = String($0.filter { "0123456789".contains($0) })
//            }
//        )
//    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                .padding(.bottom, 8)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                Spacer() // Spacer before the currency symbol to center the content
                
                if let symbol = currencySymbol {
                    Text(symbol)
                        .font(.system(size: 40))
                        .padding(.leading, 10)
                }
                
                TextField("", text: self.$amount)
                    .multilineTextAlignment(.center) // Center the text within the TextField
                    .keyboardType(.numberPad)
                    .padding(.leading, currencySymbol == nil ? 10 : 0)
                    .foregroundColor(Color.black)
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity)
                    .focused($isInputActive)
                    .padding(.all, 8)

                Spacer() // Spacer after the text field to ensure the content remains centered
            }
            .padding(.top,ss(w: 12))
            .padding(.bottom,ss(w: 12))
            .frame(height: ss(w: 72))
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "#07B29D"), lineWidth: 2))
           
            .onChange(of: isInputActive, perform: {
                state = $0 ? .active : .passive
            })
        }
        .onTapGesture {
            self.isInputActive = true
        }
    }
}

struct ContentViewNumericInput: View {
    @State var amount: String = ""
    @State var state: FieldStateNum = .passive

    var body: some View {
        NumericInput(amount: $amount, placeholder: "Enter Amount", currencySymbol: "€", state: $state)
            .padding(20)
    }
}

#Preview{
    ContentViewNumericInput()
}
