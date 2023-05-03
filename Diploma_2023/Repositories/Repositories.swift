//
//  Repositories.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 04/04/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Repository {
    associatedtype T
    func add(_ item: T, completion: @escaping (Result<Void, Error>) -> Void)
    func update(_ item: T, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(_ item: T, completion: @escaping (Result<Void, Error>) -> Void)
    func get(completion: @escaping (Result<[T], Error>) -> Void)
}



class Repositories {
    let accountRepository: AccountRepositoryOLD
//    let clientRepository: ClientRepository
//    let exerciseRepository: ExerciseRepository
//    let trainingPlanRepository: TrainingPlanRepository

    init() {
        self.accountRepository = AccountRepositoryOLD()
//        self.clientRepository = ClientRepository()
//        self.exerciseRepository = ExerciseRepository()
//        self.trainingPlanRepository = TrainingPlanRepository()
    }
}


class AccountRepositoryOLD: Repository {
    typealias T = Account
    private let db = Firestore.firestore()
    private let collectionName = "accounts"
    
    func add(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountRef = db.collection(collectionName).document(account.id)
        
        do {
            try accountRef.setData(from: account)
            completion(.success(()))
        } catch {
            print("Error creating account: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func update(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountRef = db.collection(collectionName).document(account.id)
        
        do {
            try accountRef.setData(from: account, merge: true)
            completion(.success(()))
        } catch {
            print("Error updating account: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func delete(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func get(completion: @escaping (Result<[Account], Error>) -> Void) {
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching accounts: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                let accounts = snapshot?.documents.compactMap { try? $0.data(as: Account.self) }
                completion(.success(accounts ?? []))
            }
        }
    }
}



//class ClientRepository: Repository {
//    typealias T = Client
//
//    let db = Firestore.firestore()
//    let clientsCollection = "clients"
//
//    func add(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            try db.collection(clientsCollection).addDocument(from: client)
//            completion(.success(()))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//
//    func update(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
//        let clientID = client.id
//        do {
//            try db.collection(clientsCollection).document(clientID.uuidString).setData(from: client)
//            completion(.success(()))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//
//    func delete(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
//        let clientID = client.id
//        db.collection(clientsCollection).document(clientID.uuidString).delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func get(completion: @escaping (Result<[Client], Error>) -> Void) {
//        db.collection(clientsCollection).getDocuments { querySnapshot, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let clients = querySnapshot?.documents.compactMap { document -> Client? in
//                    return try? document.data(as: Client.self)
//                }
//                completion(.success(clients ?? []))
//            }
//        }
//    }
//
//
//    func getClientsByAccountID(_ accountID: String, completion: @escaping (Result<[Client], Error>) -> Void) {
//        db.collection(clientsCollection).whereField("accountID", isEqualTo: accountID).getDocuments { querySnapshot, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let clients = querySnapshot?.documents.compactMap { document -> Client? in
//                    return try? document.data(as: Client.self)
//                }
//                completion(.success(clients ?? []))
//            }
//        }
//    }
//
//}


//class ExerciseRepository: Repository {
//    typealias T = Exercise
//
//    let db = Firestore.firestore()
//    let exercisesCollection = "exercises"
//
//    func add(_ exercise: Exercise, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            try db.collection(exercisesCollection).addDocument(from: exercise)
//            completion(.success(()))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//
//    func update(_ exercise: Exercise, completion: @escaping (Result<Void, Error>) -> Void) {
//        let exerciseID = exercise.id
//        do {
//            try db.collection(exercisesCollection).document(exerciseID.uuidString).setData(from: exercise)
//            completion(.success(()))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//
//    func delete(_ exercise: Exercise, completion: @escaping (Result<Void, Error>) -> Void) {
//        let exerciseID = exercise.id
//        db.collection(exercisesCollection).document(exerciseID.uuidString).delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func get(completion: @escaping (Result<[Exercise], Error>) -> Void) {
//        db.collection(exercisesCollection).getDocuments { querySnapshot, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let exercises = querySnapshot?.documents.compactMap { document -> Exercise? in
//                    return try? document.data(as: Exercise.self)
//                }
//                completion(.success(exercises ?? []))
//            }
//        }
//    }
//}



//class AccountRepository: Repository {
//    typealias T = Account
//
//    let db = Firestore.firestore()
//    let accountsCollection = "accounts"
//
//    // ... Implement CRUD methods for Account data model
//}
//
//class ProfileRepository: Repository {
//    typealias T = Profile
//
//    let db = Firestore.firestore()
//    let profilesCollection = "profiles"
//
//    // ... Implement CRUD methods for Profile data model
//}
