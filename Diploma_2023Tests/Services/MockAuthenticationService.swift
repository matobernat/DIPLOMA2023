//
//  MockAuthenticationService.swift
//  Diploma_2023Tests
//
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation

class MockAuthenticationService: AuthenticationServiceProtocol {
//    @Published var userId: String? = MockAccount.accountID
    @Published var userId: String? = MockedData.account.id

    var completionHandler: ((String) -> Void)?
    
    enum MockAuthResult {
        case success
        case failure
    }

    enum MockAuthenticationError: Error {
        case signInFailed
    }
    
    var resultType: MockAuthResult = .success

    

    func onLogin(_ completion: @escaping (String) -> Void) {
//        self.completionHandler = completion
        completion(MockedData.account.id)
    }
    
    
    var lastSignInEmail: String?
    var lastSignInPassword: String?

    func signIn(email: String, password: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        lastSignInEmail = email
        lastSignInPassword = password
        
        
        if resultType == .success {
            let mockUser = MyUser(uid: MockedData.account.id)
            self.userId = mockUser.uid
            completion(.success(mockUser))
        } else {
            completion(.failure(MockAuthenticationError.signInFailed))
        }
    }
    
    
    func signUp(email: String, password: String, profileName: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        // Simulate successful sign-up
        let mockUser = MyUser(uid: MockedData.account.id) // Assume User is a model you've defined
        self.userId = MockedData.account.id
        completion(.success(mockUser))
    }
    
    func signOut(completion: (Result<Void, Error>) -> Void) {
        // Simulate successful sign-out
        self.userId = nil
        print("\n MockAuthenticationService.singOut()")
        print("setting userId == nil")
        print("Current Thread: \(Thread.current)")
        completion(.success(()))
    }
}


