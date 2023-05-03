//
//  Diploma_2023App.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI
import FirebaseCore



//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}




@main
struct Diploma_2023App: App {

    private var appDependencyContainer: AppDependencyContainer
    @State private var userID: String?

    // Add this line
    @StateObject private var authenticationService: AuthenticationService


    init() {
        FirebaseApp.configure()
        self.appDependencyContainer =  AppDependencyContainer()
        // Set the StateObject to the shared instance
        self._authenticationService = StateObject(wrappedValue: AppDependencyContainer.shared.authenticationService)

    }

    
//     AppDependencyContainer.shared.authenticationService.userId{ is probably not alive so
    var body: some Scene {
        WindowGroup {
            if let _ = authenticationService.userId{
                TabBarView()
            } else {
                SignInView(userID: AppDependencyContainer.shared.authenticationService.userId)
            }
        }
    }
         
}

//
//@main
//struct Diploma_2023App: App {
//
//
//    @StateObject private var authenticationService = AuthenticationService()
//    @State private var appDataStores: AppDataStores?
//
//    init() {
//        FirebaseApp.configure()
//
//        authenticationService.onLogin { userId in
//            print("LOGGED USER ID: \(userId)")
//
//            // Initialize AppDataStores after successful login
//            appDataStores = AppDataStores(authenticationService: authenticationService)
//        }
//
////        authenticationService.onLogout {
////            // Clear AppDataStores after logout
////            appDataStores = nil
////        }
//
//    }
//
//
//    var body: some Scene {
//        WindowGroup {
//            if let _ = authenticationService.userId, let appDataStores = appDataStores {
//                TabBarView(appDataStores: appDataStores, authenticationService: authenticationService)
//            } else {
//                SignInView(authenticationService: authenticationService)
//            }
//        }
//    }
//}

