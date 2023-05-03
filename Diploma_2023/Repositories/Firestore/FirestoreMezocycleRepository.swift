//
//  FirestoreMezocycleRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreMezoRepository: MezoRepository {

    private let collectionName = "mezocycles"
    private let db = Firestore.firestore()

    func fetchMezos(forUserId userId: String, completion: @escaping (Result<[Mezocycle], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
            .order(by: "dateOfCreation", descending: true)

            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching mezocycles: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let mezocycles = snapshot?.documents.compactMap { try? $0.data(as: Mezocycle.self) }
                    completion(.success(mezocycles ?? []))
                }
            }
    }

    func createMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let mezoRef = db.collection(collectionName).document(mezo.id)
        do {
            try mezoRef.setData(from: mezo)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func updateMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let mezoRef = db.collection(collectionName).document(mezo.id)
        do {
            try mezoRef.setData(from: mezo, merge: true)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let mezoRef = db.collection(collectionName).document(mezo.id)

        mezoRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
