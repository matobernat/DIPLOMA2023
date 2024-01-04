//
//  Authentication.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 15/04/2023.
//


import FirebaseAuth

//class Authentication: ObservableObject {
//
//    @Published var signedIn = false
//
//
//    var handle: AuthStateDidChangeListenerHandle?
//    var userIdChanged: ((String?) -> Void)?
//
//
//
//    init() {
//        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
//            self?.userIdChanged?(user?.uid)
//        }
//    }
//
//    deinit {
//        if let handle = handle {
//            Auth.auth().removeStateDidChangeListener(handle)
//        }
//    }
//
//
//
//    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let user = result?.user {
//                self.signedIn = true
//                completion(.success(user))
//            }
//        }
//    }
//
//    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let user = result?.user {
//                self.signedIn = true
//                completion(.success(user))
//            }
//        }
//    }
//
//
//
//    func signOut(completion: (Result<Void, Error>) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            self.signedIn = false
//            completion(.success(()))
//        } catch {
//            completion(.failure(error))
//        }
//    }
//}
