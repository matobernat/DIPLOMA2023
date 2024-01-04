//
//  Diploma_2023App.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

//    @StateObject private var authenticationService = AppDependencyContainer.shared.authenticationService


import SwiftUI
import FirebaseCore

@main
struct Diploma_2023App: App {

    private var appDependencyContainer: AppDependencyContainer?
    @State private var userID: String?
    @StateObject private var authenticationService: AnyAuthenticationService  //type-erased wrapper

    init() {
        
        // RUN
        if NSClassFromString("XCTest") == nil{
            
            FirebaseApp.configure()
            self.appDependencyContainer = AppDependencyContainer()

            // Initalizing the StateObject inside of the shared instance
            self._authenticationService = StateObject(wrappedValue: AppDependencyContainer.shared.authenticationService)
            
        // TEST
        }else{
            self.appDependencyContainer = nil
            self.appDependencyContainer = AppDependencyContainer(useMockedRepositories: true)

            self._authenticationService = StateObject(wrappedValue: AnyAuthenticationService((MockAuthenticationService())))

        }
    }

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
