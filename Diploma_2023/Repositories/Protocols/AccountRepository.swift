//
//  AccountRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

import Foundation

protocol AccountRepository {
    func fetchAccount(forUserId userId: String, completion: @escaping (Result<Account, Error>) -> Void)
    func createAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAccount(_ account: Account, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
