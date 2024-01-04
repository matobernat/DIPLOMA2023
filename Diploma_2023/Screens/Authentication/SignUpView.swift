//
//  RegisterView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 06/04/2023.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var profileName = ""

    private let accountDataStore: AccountDataStore
    private let categoryDataStore: CategoryDataStore
    private let authenticationService: AnyAuthenticationService
    

    init() {
        self.accountDataStore = AppDependencyContainer.shared.accountDataStore
        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        self.authenticationService = AppDependencyContainer.shared.authenticationService
    }

    func signUp() {
        authenticationService.signUp(email: email, password: password, profileName: profileName) { [weak self] result in
            switch result {
            case .success(let user):
                let accountId = user.uid
                
                print("SingUpView - userId: \(accountId)")
                
                // Create Account + Profile
                self?.accountDataStore.createAccount(userID: accountId, email: self?.email ?? "", profileName: self?.profileName ?? "Main Coach"){ result in
                    switch result {
                    case .success(let account):
                        
                        print("SingUpView - account.ic: \(account.id)")
                        
                        // Create Account's categories
                        self?.categoryDataStore.createCategoriesForAccount(forAccount: account.id) { result in
                            switch result {
                            case .success:
                                print("Successfully created categories for account")
                            case .failure(let error):
                                print("Error creating categories for account: \(error.localizedDescription)")
                            }
                        }
                        
                        // Create Profile's categories
                        if let profileId = account.loggedProfile?.id {
                            self?.categoryDataStore.createCategoriesForProfile(forProfile: profileId, forAccount: account.id) { result in
                                                switch result {
                                                case .success:
                                                    print("Successfully created categories for profile")
                                                case .failure(let error):
                                                    print("Error creating categories for profile: \(error.localizedDescription)")
                                                }
                                            }
                            
                        } else {
                            print("Error: Failed to get profile ID")
                        }
                        
                    case .failure(_):
                        print("Error: Failed to create Account")
                    }
                    
                }
                
                                
                



                
            case .failure(let error):
                print("Error signing up: \(error.localizedDescription)")
                // Handle failure (e.g., show an alert)
            }
        }
    }

}




struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        VStack {
            Spacer()

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 20) {
                Text("Account Email")
                    .font(.headline)
                TextField("example@example.com", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.all, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Text("Password")
                    .font(.headline)
                SecureField("Password", text: $viewModel.password)
                    .padding(.all, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Text("Profile Name")
                    .font(.headline)
                TextField("Profile Name", text: $viewModel.profileName)
                    .autocapitalization(.none)
                    .padding(.all, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                viewModel.signUp()
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Register")
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
