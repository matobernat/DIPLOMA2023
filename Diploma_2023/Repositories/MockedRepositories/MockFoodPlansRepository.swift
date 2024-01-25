//
//  MockFoodPlansRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation


class MockFoodPlansRepository: FoodPlansRepository {
    private var mockFoodPlans: [String: [FoodPlan]] = [MockedData.account.id:MockedData.foodPlans]  // Dictionary to store mock food plans by userId

    func fetchFoodPlans(forUserId userId: String, completion: @escaping (Result<[FoodPlan], Error>) -> Void) {
        let foodPlans = mockFoodPlans[userId] ?? []
        completion(.success(foodPlans))
    }

    func createFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userFoodPlans = mockFoodPlans[userId] {
            userFoodPlans.append(foodPlan)
            mockFoodPlans[userId] = userFoodPlans
        } else {
            mockFoodPlans[userId] = [foodPlan]
        }
        completion(.success(()))
    }

    func updateFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userFoodPlans = mockFoodPlans[userId], let index = userFoodPlans.firstIndex(where: { $0.id == foodPlan.id }) {
            userFoodPlans[index] = foodPlan
            mockFoodPlans[userId] = userFoodPlans
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Food Plan not found"])))
        }
    }

    func deleteFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userFoodPlans = mockFoodPlans[userId], let index = userFoodPlans.firstIndex(where: { $0.id == foodPlan.id }) {
            userFoodPlans.remove(at: index)
            mockFoodPlans[userId] = userFoodPlans
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Food Plan not found"])))
        }
    }
}
=======
//  Created by Martin Bernát on 03/01/2024.
//

import Foundation
>>>>>>> main
