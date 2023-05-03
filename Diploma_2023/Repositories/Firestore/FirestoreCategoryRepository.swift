//
//  FirestoreCategoryRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreCategoryRepository: CategoryRepository {
    private let collectionName = "categories"
    private let db = Firestore.firestore()
    
    func fetchCategories(forUserId userId: String, completion: @escaping (Result<[Category], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
//            .order(by: "dateOfCreation")
            .order(by: "dateOfCreation", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\n CATEGORY REPOSITORY ERROR: \n")

                    print("Error fetching categories: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let categories = snapshot?.documents.compactMap { try? $0.data(as: Category.self) }
                    
                    print("\n CATEGORY REPOSITORY SUCCESS: \n")
                    completion(.success(categories ?? []))
                }
            }
    }
    
    func createCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let categoryRef = db.collection(collectionName).document(category.id)
        
        do {
            try categoryRef.setData(from: category)
            completion(.success(()))
        } catch {
            print("Error creating category: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func updateCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let categoryRef = db.collection(collectionName).document(category.id)
        
        do {
            try categoryRef.setData(from: category, merge: true)
            completion(.success(()))
        } catch {
            print("Error updating category: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func deleteCategory(_ category: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let categoryRef = db.collection(collectionName).document(category.id)
        
        categoryRef.delete { error in
            if let error = error {
                print("Error deleting category: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
