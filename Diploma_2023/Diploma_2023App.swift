//
//  Diploma_2023App.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI
import FirebaseCore


@main
struct Diploma_2023App: App {

    private var appDependencyContainer: AppDependencyContainer
    @State private var userID: String?

    @StateObject private var authenticationService: AuthenticationService

    init() {
        FirebaseApp.configure()
        self.appDependencyContainer =  AppDependencyContainer()
        
        // Initalize the StateObject inside of the shared instance
        self._authenticationService = StateObject(wrappedValue: AppDependencyContainer.shared.authenticationService)
        
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
