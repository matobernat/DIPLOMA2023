//
//  SignInView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 07/04/2023.
//



import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    private let authenticationService: AnyAuthenticationService
    
    init() {
        self.authenticationService = AppDependencyContainer.shared.authenticationService
    }
        
    func signIn() {
        authenticationService.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                // Handle success (e.g., show an alert)
                print("Signed in")
            case .failure(let error):
                // Handle failure (e.g., show an alert)Main
                print("Failed to sign in: \(error.localizedDescription)")
            }
        }
    }
    
    
}



struct SignInView: View {

    @StateObject var viewModel = SignInViewModel()
    
    @State private var isRegistering = false
    
    var userID: String?
    

    var body: some View {
        VStack {
            
            Text("USERID: \(userID ?? "NONE")")
            Spacer()

            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 20) {
                Text("Email")
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
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                viewModel.signIn()
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Button(action: {
                isRegistering = true
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.label))
            }
            .sheet(isPresented: $isRegistering) {
                SignUpView()
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Sign In")
    }
    
}


