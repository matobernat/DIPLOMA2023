//
//  FirestorePhasesRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePhaseRepository: PhaseRepository {

    private let collectionName = "phases"
    private let db = Firestore.firestore()

    func fetchPhases(forUserId userId: String, completion: @escaping (Result<[Phase], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
            .order(by: "dateOfCreation", descending: true)

            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching phases: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let phases = snapshot?.documents.compactMap { try? $0.data(as: Phase.self) }
                    completion(.success(phases ?? []))
                }
            }
    }

    func createPhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let phaseRef = db.collection(collectionName).document(phase.id)
        do {
            try phaseRef.setData(from: phase)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func updatePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let phaseRef = db.collection(collectionName).document(phase.id)
        do {
            try
            phaseRef.setData(from: phase, merge: true)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deletePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let phaseRef = db.collection(collectionName).document(phase.id)
        phaseRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
