//
//  MockAccountRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation



class MockAccountRepository: AccountRepository {
    private var mockAccounts: [String: Account] = [MockedData.account.id:MockedData.account]  // Dictionary to store mock accounts

    init() {
        // Initialize with some mock data
//        mockAccounts["user1"] = Account(id: "user1", name: "John Doe", ... )  // Replace with actual Account initializer
//        mockAccounts["user2"] = Account(id: "user2", name: "Jane Smith", ... ) // Replace with actual Account initializer
    }

    func fetchAccount(forUserId userId: String, completion: @escaping (Result<Account, Error>) -> Void) {
        if let account = mockAccounts[userId] {
            completion(.success(account))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Account not found"])))
        }
    }

    func createAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mockAccounts[userId] = account
        completion(.success(()))
    }

    func updateAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if mockAccounts[userId] != nil {
            mockAccounts[userId] = account
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Account not found"])))
        }
    }

    func deleteAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if mockAccounts[userId] != nil {
            mockAccounts.removeValue(forKey: userId)
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Account not found"])))
        }
    }
}
=======
//  Created by Martin Bernát on 03/01/2024.
//

import Foundation
>>>>>>> main
