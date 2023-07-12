//
//  MockClientDataStore.swift
//  Diploma_2023Tests
//
//  Created by Martin Bernát on 28/06/2023.
//

import Foundation


class MockClientsDataStore: ClientsDataStore {
    var allClients: [Client] = [] // Mutable for testing
    var wasCreateClientCalled = false
    var wasUpdateClientCalled = false
    var wasDeleteClientCalled = false

    override func createClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasCreateClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    override func updateClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasUpdateClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    override func deleteClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasDeleteClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    // No need to override fetchClients or other methods, because those won't be called in tests.
}
