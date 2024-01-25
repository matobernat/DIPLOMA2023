//
//  FirestoreFoodPlansRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/10/2023.
//

import Foundation
<<<<<<< HEAD


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreFoodPlansRepository: FoodPlansRepository {

    private let collectionName = "foodPlans"
    private let db = Firestore.firestore()

    func fetchFoodPlans(forUserId userId: String, completion: @escaping (Result<[FoodPlan], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
            .order(by: "dateOfCreation", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching foodPlans: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let foodPlans = snapshot?.documents.compactMap { try? $0.data(as: FoodPlan.self) }
                    completion(.success(foodPlans ?? []))
                }
            }
    }

    func createFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let foodPlanRef = db.collection(collectionName).document(foodPlan.id)
        do {
            try foodPlanRef.setData(from: foodPlan)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func updateFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let foodPlanRef = db.collection(collectionName).document(foodPlan.id)
        do {
            try foodPlanRef.setData(from: foodPlan, merge: true)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let foodPlanRef = db.collection(collectionName).document(foodPlan.id)
        foodPlanRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
=======
>>>>>>> main
