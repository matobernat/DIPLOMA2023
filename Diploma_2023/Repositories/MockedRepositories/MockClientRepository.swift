//
//  MockClientRepository.swift
//  Diploma_2023Tests
//
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation


class MockClientRepository: ClientRepository {
    // You can use these arrays to hold your mock data for each function
<<<<<<< HEAD
    var fetchedClients: [Client] = MockedData.clients
=======
    var fetchedClients: [Client] = []
>>>>>>> main
    var createdClients: [Client] = []
    var updatedClients: [Client] = []
    var deletedClients: [Client] = []
    var clearedImageUrls: [String] = []
    
    // flags
    var wasFetchClientsCalled = false

    func fetchClients(forUserId userId: String, completion: @escaping (Result<[Client], Error>) -> Void) {
        wasFetchClientsCalled = true
        completion(.success(fetchedClients))
    }

    func createClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        createdClients.append(client)
        completion(.success(()))
    }

    func updateClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // You can find the existing client and replace it
        if let index = updatedClients.firstIndex(where: { $0.id == client.id }) {
            updatedClients[index] = client
        } else {
            // Or simply append if the client is not yet in the array
            updatedClients.append(client)
        }
        completion(.success(()))
    }

    func deleteClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deletedClients.append(client)
        completion(.success(()))
    }

    func clearClientImageUrl(clientId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        clearedImageUrls.append(clientId)
        completion(.success(()))
    }
}
