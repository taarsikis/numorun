import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var cityOccurrences: [String: Int] = [:]  // Track city occurrences

    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.allowsBackgroundLocationUpdates = true  // Allow updates in the background
                self.locationManager?.pausesLocationUpdatesAutomatically = false 
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopTracking() {
        self.locationManager?.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation = newLocation
            self?.updateCityOccurrences(for: newLocation)
        }
    }

    // Reverse geocode and update city occurrences
    private func reverseGeocodeLocation(_ location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            completion(placemark.locality) // locality gives you the city name
        }
    }

    // Update city occurrences when location updates
    private func updateCityOccurrences(for location: CLLocation) {
        reverseGeocodeLocation(location) { [weak self] city in
            guard let city = city else { return }
            DispatchQueue.main.async {
                self?.cityOccurrences[city, default: 0] += 1
            }
        }
    }

    // Find the most frequent city
    func mostFrequentCity() -> String? {
        return cityOccurrences.max(by: { $0.value < $1.value })?.key
    }
}

struct TrackerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var path: [CLLocationCoordinate2D] = []
    @State private var tracking = false
    @State private var startTime: Date?
    @State private var tryToFinish = false
    @State private var navigateToRunStats = false
    @StateObject private var runViewModel = RunsViewModel()
    
    @Binding var startRun: Bool
    @Binding var selectedTabIndex: Int
    
    private var duration: Double {
        guard let start = startTime, path.count > 1 else { return 0.0 }
        return Date().timeIntervalSince(start)

    }
    private var distance : Double {
        guard let start = startTime, path.count > 1 else { return 0.0 }
        return calculateDistance(path: path)
    }
    private var averagePace : Double {
        guard let start = startTime, path.count > 1 else { return 0.0 }
        return distance > 0 ? (duration / 60) / (distance / 1000) : 0.0 // Pace in min/km
    }

    @AppStorage("uid") var userID: String = ""
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapView(centerCoordinate: locationManager.currentLocation?.coordinate, path: $path)
                .ignoresSafeArea()
            
            
            if startRun {
                HStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: ss(w:358), height: ss(w:100))
                            .background(.white)
                            .cornerRadius(18)
                            .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.15), radius: 25, x: 0, y: 10)
                        
                        ZStack {
                        Button(action: {
                            
                            tryToFinish = true
                        }){
                            
                                Image("Pause Icon")
                                    .frame(width: 66, height: 66)
                            
                            }
                        }
                        .frame(width: 70.4, height: 70.4)
                        .offset(y: -60)
                        
                        VStack(alignment: .center, spacing: 0) {
                            
                            HStack(alignment: .center, spacing: 0) {
                                VStack(alignment: .center, spacing: 0) {
                                    // Large Bold
                                    Text(formatPace(averagePace))
                                        .font(
                                            Font.custom("Kyiv*Type Sans", size: 20)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    
                                    // Para
                                    Text("Темп")
                                        .font(Font.custom("Kyiv*Type Sans", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.37, blue: 0.37))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .top)
                                
                                VStack(alignment: .center, spacing: 0) {
                                    // Large Bold
                                    Text(formatDistance(distance))
                                        .font(
                                            Font.custom("Kyiv*Type Sans", size: 20)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    
                                    // Para
                                    Text("Відстань")
                                        .font(Font.custom("Kyiv*Type Sans", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.37, blue: 0.37))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .top)
                                
                                VStack(alignment: .center, spacing: 0) {
                                    // Large Bold
                                    Text(formatDuration(duration))
                                        .font(
                                            Font.custom("Kyiv*Type Sans", size: 20)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    
                                    // Para
                                    Text("Час")
                                        .font(Font.custom("Kyiv*Type Sans", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.37, blue: 0.37))
                                        .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .top)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                            .frame(width: 358, alignment: .center)
                        }
                    }
                    Spacer()
                }
            }
            if tryToFinish{
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .center, spacing: 16) {
                            Image("Logo Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                        }
                        VStack(alignment: .center, spacing: 16) {
                            VStack(alignment: .center, spacing: 8) {
                                // Large Bold
                                Text("Завершив?")
                                  .font(
                                    Font.custom("Kyiv*Type Sans", size: 20)
                                      .weight(.medium)
                                  )
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                                  .frame(maxWidth: .infinity, alignment: .top)
                                
                                // Small
                                Text("Ти впевнений, що хочеш закінчити та зберегти пробіжку?\n")
                                  .font(Font.custom("Kyiv*Type Sans", size: 14))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                                  .frame(width: 334, alignment: .top)
                            }
                            .padding(0)
                            
                            VStack(alignment: .center, spacing: 0) {
                                HStack(alignment: .center, spacing: 0) {
                                    Button(action:{
                                        startRun = false
                                        navigateToRunStats = true
                                        
                                        self.selectedTabIndex = 3
                                        print("Run finished")
                                        let city = locationManager.mostFrequentCity() ?? "Unknown"
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                            let date = dateFormatter.string(from: startTime ?? Date())
                                            let timezone = TimeZone.current.identifier
                                        runViewModel.createRun(run: Run(id: 1, user_id: userID, date: date, timezone: timezone, distance: self.distance, duration: self.duration, pace: self.averagePace, city: city))
                                    }){
                                        HStack(alignment: .center, spacing: 10) {
                                            // Para
                                            Text("Завершити")
                                                .font(Font.custom("Kyiv*Type Sans", size: 16))
                                                .foregroundColor(Color(red: 0.99, green: 0.99, blue: 0.99))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 0)
                                    }
                                    
//                                        RunStats(duration: self.$resDuration, distance: self.$resDistance, pace: self.$resPace)
//                                    })
//
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(width: 167, height: 40, alignment: .center)
                                .background(Color(red: 0.03, green: 0.7, blue: 0.62))
                                .cornerRadius(10)
                                
                                HStack(alignment: .center, spacing: 0) {
                                    
                                    Button(action:{
                                        tryToFinish = false
                                    }){
                                        HStack(alignment: .center, spacing: 10) {
                                            // Para
                                            Text("Скасувати")
                                                .font(Font.custom("Kyiv*Type Sans", size: 16))
                                                .foregroundColor(Color(red: 0.03, green: 0.7, blue: 0.62))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 0)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(width: 167, height: 40, alignment: .center)
                                .cornerRadius(10)
                            }
                            .padding(0)
                        }
                        .padding(0)
                    }
                    .padding(12)
                    .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                    .cornerRadius(12)
                .shadow(color: Color(red: 0.03, green: 0.7, blue: 0.62).opacity(0.35), radius: 50, x: 0, y: 10)
                .padding(.horizontal, ss(w:12))
                    Spacer()
                }
            }
        }
        .onAppear {
            locationManager.startTracking()
        }
        .onChange(of: self.startRun){ _ in
            if startRun{
                startTime = Date()
                path.removeAll()
                print("Run Started (OnChange)")
            }else{
                locationManager.stopTracking()
                guard let start = startTime, path.count > 1 else { return }
                let duration = Date().timeIntervalSince(start)
                let distance = calculateDistance(path: path)
                let averagePace = distance > 0 ? (duration / 60) / (distance / 1000) : 0 // Pace in min/km
                print("Distance: \(distance) meters")
                print("Duration: \(duration) seconds")
                print("Average Pace: \(averagePace) min/km")
            }
        }
        .onChange(of: locationManager.currentLocation) { _ in
            if startRun, let newLocation = locationManager.currentLocation {
                path.append(newLocation.coordinate)
                
                
            }
        }
    }

    func toggleTracking() {
        tracking.toggle()
        if tracking {
            startTime = Date()
            path.removeAll()
        } else {
            locationManager.stopTracking()
            guard let start = startTime, path.count > 1 else { return }
            let duration = Date().timeIntervalSince(start)
            let distance = calculateDistance(path: path)
            let averagePace = distance > 0 ? (duration / 60) / (distance / 1000) : 0 // Pace in min/km
            print("Distance: \(distance) meters")
            print("Duration: \(duration) seconds")
            print("Average Pace: \(averagePace) min/km")
        }
    }

    func calculateDistance(path: [CLLocationCoordinate2D]) -> Double {
        guard path.count > 1 else { return 0 }
        let locations = path.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        let distances = zip(locations, locations.dropFirst()).map { $0.distance(from: $1) }
        return distances.reduce(0, +)
    }
    
    private func formatPace(_ pace: Double) -> String {
        let paceMin = Int(pace)
        let paceSec = Int((pace - Double(paceMin)) * 60)
        return String(format: "%d:%02d хв/км", paceMin, paceSec)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let durationMinutes = Int(duration / 60)
        let durationSeconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d хв", durationMinutes, durationSeconds)
    }

    private func formatDistance(_ distance: Double) -> String {
        String(format: "%.2f км", distance / 1000)
    }
}

struct MapView: UIViewRepresentable {
    var centerCoordinate: CLLocationCoordinate2D?
    @Binding var path: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let centerCoordinate = centerCoordinate {
            let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
        updatePath(uiView)
    }

    private func updatePath(_ mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        let polyline = MKPolyline(coordinates: path, count: path.count)
        mapView.addOverlay(polyline)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}



#Preview{
    TrackerView(startRun: .constant(false), selectedTabIndex: .constant(4))
}
