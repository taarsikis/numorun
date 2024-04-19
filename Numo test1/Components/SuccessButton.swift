import SwiftUI

struct SuccessButtonView: View {
    var title: String
    var isAllowed: Bool
    var fontSize: CGFloat
    var fontPaddingSize: CGFloat
    var cornerRadiusSize: CGFloat
    
    var body: some View {
            Text(title)
                .foregroundColor(Color(hex: isAllowed ? "FDFDFD" : "#9FA0A0"))
                .font(.system(size: fontSize))
                .padding(fontPaddingSize)
                .frame(maxWidth: .infinity, maxHeight: 55)
                .background(Color(hex: isAllowed ? "#07B29D" : "#EDEDED"))
                .cornerRadius(cornerRadiusSize)
    }
}



// Usage example
struct ContentViewSuccessButton: View {
    @State private var isAllowedLogin = true // This should be bound to your login logic

    var body: some View {
        SuccessButtonView(title: "Увійти", isAllowed: isAllowedLogin, fontSize: 20, fontPaddingSize: 10, cornerRadiusSize: 12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSuccessButton()
    }
}
