//
//  CategoryRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/04/2023.
//

import Foundation


protocol CategoryRepository {
    func fetchCategories(forUserId userId: String, completion: @escaping (Result<[Category], Error>) -> Void)
    func createCategory(_ client: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateCategory(_ client: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteCategory(_ client: Category, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
