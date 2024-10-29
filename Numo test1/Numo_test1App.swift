//
//  Numo_test1App.swift
//  Numo test1
//
//  Created by Тасік on 28.03.2024.
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    var deepLinkURL: URL?

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Attempting to handle URL: \(url.absoluteString)")
        
        if url.scheme == "numorun" && url.host == "payment" {
            print("URL scheme and host matched")
            
            deepLinkURL = url
            NotificationCenter.default.post(name: NSNotification.Name("DeepLinkHandled"), object: nil)
            return true
        }
        
        print("URL scheme or host didn't match")
        return false
    }


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}





@main
struct Numo_test1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var navigateToPayment = false // State to control navigation

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DeepLinkHandled"))) { _ in
                        // This will trigger when the deep link is captured
                        print("Deep link received!")
                        
                        navigateToPayment = true
                    }
                    .background(
                        NavigationLink(
                            destination: BalanceView(), // Replace with your PaymentView
                            isActive: $navigateToPayment,
                            label: { EmptyView() }
                        )
                    )
            }
        }
    }
}
