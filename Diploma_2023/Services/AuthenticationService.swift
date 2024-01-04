//
//  AuthenticationService.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//


import FirebaseAuth
import Combine
import SwiftUI



// MARK: - AuthenticationService - app service
class AuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    @Published var userId: String? {
        didSet {
            if let userId = userId {
                self.completionHandler?(userId)
            }
        }
    }

    private var handle: AuthStateDidChangeListenerHandle?
    var completionHandler: ((String) -> Void)?
    
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                DispatchQueue.main.async {
                    self?.userId = user.uid
                    print("\n LOGGED IN  userid: \(self?.userId) \n ")
                }
            }
        }
    }
    
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            print("AuthenticationService is being deallocated")

        }
    }
    
    func onLogin(_ completion: @escaping (String) -> Void) {
        self.completionHandler = completion
    }
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                self.userId = user.uid
                print("signed authentication service, userId: \(self.userId) ")

                completion(.success(MyUser(uid: user.uid)))
            }
        }
    }
    

    func signUp(email: String, password: String, profileName: String, completion: @escaping (Result<MyUser, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                self.userId = user.uid
                completion(.success(MyUser(uid: user.uid)))
            }
        }
    }


    func signOut(completion: (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.userId = nil
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}


    


