import SwiftUI

struct RunningDay: Identifiable {
    let id: UUID = UUID()
    var date: Date
    var kilometers: Int
}

struct CreationCalendar: View {
    @State private var runningDays: [RunningDay] = []
    @State private var currentDate = Date()
    @State private var showingDistanceEntry = false
    @State private var tempKilometers = 0
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userData = UserData()
    
    @Binding var challengeDetails : Challenge
    
    private var isAllowedContinue: Bool {
        // Your validation logic here. For demonstration, let's just check they are not empty.
        return !runningDays.isEmpty && runningDays.allSatisfy { $0.kilometers != nil && $0.kilometers > 0 } && hint == ""
    }
    
    @State private var navigateToCreationCalendar = false
    
    private var allowedDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: 2, to: Date())!
        let end = calendar.date(byAdding: .day, value: 60, to: start)!
        return start...end
    }
    
    
    private var hint:  String{
        
        
        
        if runningDays.count < 4{
            return "Тобі потрібно вибрати мінімум 4 пробіжки"
        }
        
        if runningDays.count > 60{
            return "Максимальна к-сть пробіжок - 60"
        }
        
        
        
        if runningDays.allSatisfy({ $0.kilometers != nil && $0.kilometers >= 1 }) {
                "У вас є пробіжки, у яких вказано невірне значення кілометрів"
            }

        let sortedRunningDays = runningDays.sorted(by: { $0.date < $1.date })

        if let firstDate = sortedRunningDays.first?.date,
           let lastDate = sortedRunningDays.last?.date {
            let calendar = Calendar.current
            if let diff = calendar.dateComponents([.month], from: firstDate, to: lastDate).month, diff <= 2 {
                return ""
            } else {
                return "Максимальна тривалість челенджу - 2 місяці"
            }
        }
        

        
        
        return ""
        
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
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
                        
                        Button(action:{
                            
                        }){
                            Image("information-circle") // Your arrow image
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                        }
                    }
                    
                    Text("Коли будемо бігати?")
                        .foregroundColor(Color(hex: "#1B1C1C"))
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity)
                    
                    
                    Spacer()
                }
                .frame(height: ss(w: 24))
                .frame(maxWidth: .infinity)
                //            .padding(.bottom,ss(w: 5))
                .padding(.top, ss(w: 35))
                
                NavigationView {
                    VStack {
                        DatePicker("Select a day", selection: $currentDate,
                                   in: allowedDateRange,
                                   displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(Color(hex: "#07B29D"))
                        .onChange(of: currentDate) { newDate in
                            if !runningDays.contains(where: { $0.date.isSameDay(as: newDate) }) {
                                tempKilometers = 0
                                showingDistanceEntry = true
                            }
                        }
                        List {
                            ForEach(runningDays) { day in
                                HStack {
                                    Text(day.date, style: .date)
                                    Spacer()
                                    Text("\(day.kilometers ) км")
                                    Spacer()
                                    Button(action: {
                                        deleteDay(day)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .onDelete(perform: deleteDays)
                        }
                    }
                    .padding(.horizontal, ss(w:10))
//                    .sheet(isPresented: $showingDistanceEntry) {
//                        DistanceEntryView(kilometers: $tempKilometers) {
//                            addRunningDay(distance: tempKilometers)
//                            showingDistanceEntry = false
//                        }
//                    }
                }
                
                
                Button(action: {
                    if isAllowedContinue{
                        navigateToCreationCalendar = true
                    }
                }){
                    SuccessButtonView(title: "Продовжити", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
                        .padding(.horizontal, 30)
                }.fullScreenCover(isPresented: $navigateToCreationCalendar, content: {
                    CreationConfirm(challengeDetails: self.$challengeDetails, runs: self.$runningDays)
                })
                
                HStack{
                    Spacer()
                    Text(hint)
                        .font(.caption)
                        .foregroundColor(Color(hex: "EB6048"))
                        .padding(.top, 4)
                    Spacer()
                }
                
                Button(action: clearAllDays) {
                    Text("Видалити все")
                        .foregroundColor(Color(hex: "#07B29D"))
                    
                }
                
                
        }
            if showingDistanceEntry {
                            // Background dimming
                            Color.black.opacity(0.4)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    // Dismiss the picker view when tapping the background
                                    showingDistanceEntry = false
                                }

                            // Custom modal view for distance entry
                            DistanceEntryView(kilometers: $tempKilometers, curentDate: $currentDate) {
                                addRunningDay(distance: tempKilometers)
                                showingDistanceEntry = false
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .transition(.move(edge: .bottom))
                        }
                    }
                    .navigationBarHidden(showingDistanceEntry)
    }
    
    func clearAllDays() {
        runningDays.removeAll()
    }
    
    func addRunningDay(distance: Int) {
        if let index = runningDays.firstIndex(where: { $0.date.isSameDay(as: currentDate) }) {
            runningDays[index].kilometers = distance
        } else {
            let newDay = RunningDay(date: currentDate, kilometers: distance)
            runningDays.append(newDay)
        }
        runningDays.sort { $0.date < $1.date }
    }
    
    func deleteDay(_ day: RunningDay) {
        if let index = runningDays.firstIndex(where: { $0.id == day.id }) {
            runningDays.remove(at: index)
        }
        runningDays.sort { $0.date < $1.date }
    }
    
    func deleteDays(at offsets: IndexSet) {
        runningDays.remove(atOffsets: offsets)
        runningDays.sort { $0.date < $1.date }
    }
}

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }
}

struct DistanceEntryView: View {
    @Binding var kilometers: Int
    @Binding var curentDate: Date
    var onSave: () -> Void
    private let kilometerOptions: [Int] = Array(0...100) // Range from 1 to 100
    
    private var isAllowedContinue: Bool {
        // Check if selected kilometers is not zero
        kilometers != 0
    }
    
    var body: some View {
        VStack {
            Text("К-сть кілометрів для \(curentDate, style: .date)")
            
            Picker("Kilometers", selection: $kilometers) {
                ForEach(kilometerOptions, id: \.self) { km in
                    Text("\(km) км").tag(km)
                }
            }
            .pickerStyle(WheelPickerStyle()) // This gives a wheel picker
            .frame(height: 150) // Set a frame height to ensure it displays correctly
            .clipped() // Ensures the picker does not overflow its bounds
            
            Button(action: onSave){
                SuccessButtonView(title: "Зберегти", isAllowed: isAllowedContinue, fontSize: 20, fontPaddingSize: 16, cornerRadiusSize: 12)
            }
            .disabled(!isAllowedContinue) // Button is disabled if no kilometers are selected
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

//struct RunningPlannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreationCalendar()
//    }
//}
