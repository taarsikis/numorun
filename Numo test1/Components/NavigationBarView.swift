import SwiftUI

struct NavigationBarView: View {
    
    var body: some View {
        VStack {
            ZStack {
                // The background shape with rounded corners
                RoundedRectangle(cornerRadius: 32)
                    .foregroundColor(Color(red: 0.99, green: 0.99, blue: 0.99))
                    .frame(height: 60)
                    .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)

                // The navigation items
                HStack(spacing: 30) {
                    Image("menu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)

                    Image("Calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)

                    // The middle button is larger and overlaps the background shape
                    Image("Logo Icon") // Replace with your logo button image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70.4, height: 70.4)
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
                        .offset(y: -12) // Adjusts the position to overlap

                    Image("briefcase")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)

                    Image("user-circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.bottom, 4)
        }
    }
}

struct ContentViewNavigationBar: View {
    @State private var selectedTabIndex = 0

    var body: some View {
        VStack {
            // Your content view here
//            Spacer()
            
            NavigationBarView()
        }
    }
}

struct ContentViewNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNavigationBar()
    }
}
