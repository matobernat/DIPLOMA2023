//
//  ClientRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

import Foundation

protocol ClientRepository {
    func fetchClients(forUserId userId: String, completion: @escaping (Result<[Client], Error>) -> Void)
    func createClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func clearClientImageUrl(clientId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
