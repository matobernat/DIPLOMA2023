//
//  AnyAuthenticationService.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 27/09/2023.
//

import Foundation
<<<<<<< HEAD
import Combine


// MARK: - AuthenticationService - Protocol
protocol AuthenticationServiceProtocol: ObservableObject {
    var userId: String? { get set }
    var completionHandler: ((String) -> Void)? { get set }
    
    func onLogin(_ completion: @escaping (String) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<MyUser, Error>) -> Void)
    func signUp(email: String, password: String, profileName: String, completion: @escaping (Result<MyUser, Error>) -> Void)
    func signOut(completion: (Result<Void, Error>) -> Void)
}




// MARK: - Any AuthenticationService - protocol wrapper
class AnyAuthenticationService: AuthenticationServiceProtocol, ObservableObject {

    @Published var userId: String? {
        didSet {
            if let userId = userId {
                self.completionHandler?(userId)
            }
        }
    }
    var completionHandler: ((String) -> Void)?

    private let _onLogin: (@escaping (String) -> Void) -> Void
    private let _signIn: (String, String, @escaping (Result<MyUser, Error>) -> Void) -> Void
    private let _signUp: (String, String, String, @escaping (Result<MyUser, Error>) -> Void) -> Void
    private let _signOut: ((Result<Void, Error>) -> Void) -> Void
    
    
    // added subscriber
    private var cancellable: AnyCancellable?

    init<T: AuthenticationServiceProtocol>(_ service: T) {
        self.userId = service.userId
        self.completionHandler = service.completionHandler

        _onLogin = service.onLogin
        _signIn = service.signIn
        _signUp = service.signUp
        _signOut = service.signOut
        
        // This will ensure that when the underlying service's `userId` changes,
         // the wrapper's `userId` will also update, triggering UI updates as needed.
        self.cancellable = service.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.userId = service.userId
                print("AnyAuthenticationService: Observed change in underlying service \(self?.userId) ")
                print("Directly from service \(service.userId)")
            }
            
                 }
             
    }

    func onLogin(_ completion: @escaping (String) -> Void) {
        _onLogin(completion)
    }

    func signIn(email: String, password: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        _signIn(email, password, completion)
    }

    func signUp(email: String, password: String, profileName: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        _signUp(email, password, profileName, completion)
    }

    func signOut(completion: (Result<Void, Error>) -> Void) {
        _signOut(completion)
    }
}


=======
>>>>>>> main
