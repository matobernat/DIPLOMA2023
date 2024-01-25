//
//  MockCategoryRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation


class MockCategoryRepository: CategoryRepository {
    private var mockCategories: [String: [Category]] = [MockedData.account.id:MockedData.categories]  // Dictionary to store mock categories by userId

    func fetchCategories(forUserId userId: String, completion: @escaping (Result<[Category], Error>) -> Void) {
        // Return mock data for the specified userId
        let categories = mockCategories[userId] ?? []
        completion(.success(categories))
    }

    func createCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Add the category to the mock data
        if var userCategories = mockCategories[userId] {
            userCategories.append(category)
            mockCategories[userId] = userCategories
        } else {
            mockCategories[userId] = [category]
        }
        completion(.success(()))
    }

    func updateCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Update the category in the mock data
        if var userCategories = mockCategories[userId], let index = userCategories.firstIndex(where: { $0.id == category.id }) {
            userCategories[index] = category
            mockCategories[userId] = userCategories
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Category not found"])))
        }
    }

    func deleteCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Delete the category from the mock data
        if var userCategories = mockCategories[userId], let index = userCategories.firstIndex(where: { $0.id == category.id }) {
            userCategories.remove(at: index)
            mockCategories[userId] = userCategories
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Category not found"])))
        }
    }
}
=======
//  Created by Martin Bernát on 03/01/2024.
//

import Foundation
>>>>>>> main
