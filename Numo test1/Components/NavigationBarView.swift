import SwiftUI

struct NavigationBarView: View {
    @Binding var selectedTabIndex: Int  // Binding to control the current view
    @Binding var startRun : Bool
    
    var body: some View {
        if self.startRun == false{
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundColor(Color(red: 0.99, green: 0.99, blue: 0.99))
                        .frame(height: 60)
                        .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.25), radius: 25, x: 0, y: 10)
                    
                    HStack(spacing: 30) {
                        // Each Image now has a TapGesture that updates selectedTabIndex
                        Image(self.selectedTabIndex == 0 ? "MenuActive" : "menu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .onTapGesture { self.selectedTabIndex = 0 }
                        
                        Image(self.selectedTabIndex == 1 ? "CalendarActive" :"Calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .onTapGesture { self.selectedTabIndex = 1 }
                        
                        Button(action:{
                            if self.startRun == false && self.selectedTabIndex == 4{
                                self.startRun = true
                            }else{
                                self.selectedTabIndex = 4
                            }
                        }){
                            Image(self.selectedTabIndex == 4 ?  "Play Icon" : "Logo Button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70.4, height: 70.4)
                                .offset(y: -12)
                                
                        }
                        
                        Image(self.selectedTabIndex == 2 ? "BalanceActive" :"briefcase")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .onTapGesture { self.selectedTabIndex = 2 }
                        
                        Image(self.selectedTabIndex == 3 ? "UserActive" :"user-circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .onTapGesture { self.selectedTabIndex = 3 }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 4)
            }
        }
    }
}


struct ContentViewNavigationBar: View {
    @State private var selectedTabIndex = 0
    
    @State private var startRun = false

    var body: some View {
        VStack {
            // Your content view here
//            Spacer()
            
            NavigationBarView(selectedTabIndex: $selectedTabIndex, startRun: $startRun)
        }
    }
}

struct ContentViewNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNavigationBar()
    }
}
