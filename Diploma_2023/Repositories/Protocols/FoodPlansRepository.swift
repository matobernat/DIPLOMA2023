//
//  FoodPlansRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/10/2023.
//

import Foundation

protocol FoodPlansRepository {
    func fetchFoodPlans(forUserId userId: String, completion: @escaping (Result<[FoodPlan], Error>) -> Void)
    func createFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFoodPlan(_ foodPlan: FoodPlan, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
