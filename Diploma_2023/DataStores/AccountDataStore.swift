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
    private let authenticationService: AnyAuthenticationService
    

    
    private var cancellable: AnyCancellable?

    init(accountRepository: AccountRepository, authenticationService: AnyAuthenticationService) {
        self.accountRepository = accountRepository
        self.authenticationService = authenticationService

        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if userId != nil {
                DispatchQueue.main.async {
                    print("AccountDataService - fetching account")
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



