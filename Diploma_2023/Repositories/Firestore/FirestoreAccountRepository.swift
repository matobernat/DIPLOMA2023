//
//  FirestoreAccountRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreAccountRepository: AccountRepository {
    private let collectionName = "accounts"
    private let db = Firestore.firestore()
    

    func fetchAccount(forUserId userId: String, completion: @escaping (Result<Account, Error>) -> Void) {
        db.collection(collectionName)
            .whereField("id", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching accounts: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let accounts = snapshot?.documents.compactMap { try? $0.data(as: Account.self) }
                    if let account = accounts?.first {
                        completion(.success(account))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Account not found"])))
                    }
                }
            }
    }

    
    func createAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountRef = db.collection(collectionName).document(account.id)
        
        do {
            try accountRef.setData(from: account)
            completion(.success(()))
        } catch {
            print("Error creating account: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func updateAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountRef = db.collection(collectionName).document(account.id)
        
        do {
            try accountRef.setData(from: account, merge: true)
            completion(.success(()))
        } catch {
            print("Error updating account: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func deleteAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountRef = db.collection(collectionName).document(account.id)
        
        accountRef.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
