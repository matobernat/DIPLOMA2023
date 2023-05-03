//
//  FirestoreExerciseRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/04/2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreExerciseRepository: ExerciseRepository {

    private let collectionName = "exercises"
    private let db = Firestore.firestore()

    
    func fetchExercises(forUserId userId: String, completion: @escaping (Result<[Exercise], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
            .order(by: "title")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching exercises: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let exercises = snapshot?.documents.compactMap { try? $0.data(as: Exercise.self) }
                    completion(.success(exercises ?? []))
                }
            }
    }

    func createExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let exerciseRef = db.collection(collectionName).document(exercise.id)
        do {
            try exerciseRef.setData(from: exercise)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func updateExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let exerciseRef = db.collection(collectionName).document(exercise.id)
        do {
            try
            exerciseRef.setData(from: exercise, merge: true)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let exerciseRef = db.collection(collectionName).document(exercise.id)
            
            exerciseRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


}
