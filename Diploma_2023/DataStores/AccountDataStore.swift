//
//  AccountDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

import Combine
import Foundation

class AccountDataStore: ObservableObject {
    @Published var loggedAccount: Account?
    private let accountRepository: AccountRepository
    private let authenticationService: AuthenticationService
    

    
    private var cancellable: AnyCancellable?

    init(accountRepository: AccountRepository, authenticationService: AuthenticationService) {
        self.accountRepository = accountRepository
        self.authenticationService = authenticationService

        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if userId != nil {
                DispatchQueue.main.async {
                    self?.fetchAccount()
                }

            } else {
                DispatchQueue.main.async {
                    self?.loggedAccount = nil // Clear the account when the user logs out
                }

            }
        }
    }

    deinit {
        cancellable?.cancel()
    }

    
    

    // Account functions
    
    func fetchAccount() {
            guard let userId = authenticationService.userId else {
                print("Error: User ID is not available")
                loggedAccount = nil
                return
            }
            
            accountRepository.fetchAccount(forUserId: userId) { [weak self] result in
                switch result {
                case .success(let account):
                    DispatchQueue.main.async {
                        self?.loggedAccount = account
                    }
                case .failure(let error):
                    print("Error fetching account: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.loggedAccount = nil
                    }
                }
            }
        }


    
    func createAccount(userID: String, email: String, profileName: String, completion: @escaping (Result<Account, Error>) -> Void) {

        let profile = Profile(id:UUID().uuidString, name: profileName, email: email, dateOfCreation: Date.now)
        let account = Account(id: userID, name: nil, email: email, address: "", loggedProfile: profile, profiles: [profile], dateOfCreation: Date.now)

        accountRepository.createAccount(account, for: userID) { [weak self] result in
            switch result {
            case .success:
                
                // Fetch the updated Account
                self?.fetchAccount()
            
                completion(.success(account))
                
            case .failure(let error):
                print("Error creating account: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    func updateAccount(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }

        accountRepository.updateAccount(account, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated Account
                self?.fetchAccount()
                completion(.success(()))
            case .failure(let error):
                print("Error updating account: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteAccount(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }

        accountRepository.deleteAccount(account, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated Account
                self?.fetchAccount()
                completion(.success(()))
            case .failure(let error):
                print("Error deleting account: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    
    
}






// Logging functions

//    func signUp(email: String, password: String, profileName: String, completion: @escaping (Result<Account, Error>) -> Void) {
//        authenticationService.signUp(email: email, password: password) { [weak self] result in
//            switch result {
//            case .success(let user):
//                print("\n SIGNED UP \n")
//
//                let profile = Profile(id:UUID().uuidString, name: profileName, email: email)
//                let account = Account(id: user.uid, name: nil, email: email, address: "", loggedProfile: profile, profiles: [profile])
//
//                self?.createAccount(account) { result in
//                     switch result {
//                     case .success:
//                         DispatchQueue.main.async {
//                             self?.loggedAccount = account
//                         }
//                         completion(.success(account))
//                     case .failure(let error):
//                         print("Error creating account: \(error.localizedDescription)")
//                         completion(.failure(error))
//                     }
//                 }
//             case .failure(let error):
//                 print("Error registering user: \(error.localizedDescription)")
//                 completion(.failure(error))
//             }
//         }
//     }

//    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        authenticationService.signIn(email: email, password: password) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.fetchAccount()
//                print("\n LOGGED IN \(user.uid) .. \(self?.authenticationService.userId ?? "NIL") \n")
//                completion(true)
//            case .failure(let error):
//                print("Error signing in user: \(error.localizedDescription)")
//                completion(false)
//            }
//        }
//    }
//
//    func signOut(completion: @escaping (Bool) -> Void) {
//        authenticationService.signOut { result in
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
//                    self.loggedAccount = nil
//                }
//                completion(true)
//            case .failure(let error):
//                print("Error signing out user: \(error.localizedDescription)")
//                completion(false)
//            }
//        }
//    }
















//
//
//class AccountStore: DataTypeStore {
//    @Published var loggedAccount: Account?
//
//    private let repository: AccountRepository
//
//    init(repository: AccountRepository) {
//        self.repository = repository
//    }
//
//    func fetchData(userId: String, completion: @escaping ([Account]?) -> Void) {
//        repository.fetchAccount(userId: userId) { account in
//            completion([account].compactMap { $0 })
//        }
//    }
//
//    func createItem(item: Account, completion: @escaping (Bool) -> Void) {
//        repositories.createAccount(account: item) { success in
//            completion(success)
//        }
//    }
//
//    func resetData() {
//        loggedAccount = nil
//    }
//}
