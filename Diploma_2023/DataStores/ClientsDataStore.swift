//
//  ClientsDataStore.swift
//  Diploma_2023
//
//  Created b y Martin Bernát on 18/04/2023.
//

import Combine
import Foundation


class ClientsDataStore: ObservableObject {
    @Published private(set) var allClients: [Client] = []
    @Published private(set) var allProgressAlbums: [ProgressAlbum] = []

    private let clientRepository: ClientRepository
    private let authenticationService: AuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(clientRepository: ClientRepository, authenticationService: AuthenticationService) {
        self.clientRepository = clientRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if let userId = userId {
                self?.fetchClients(forUserId: userId)
            } else {
                self?.allClients = [] // Clear the clients when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    



    func fetchClients(forUserId userId: String) {
        print("FETCHING CLIENTS")
        clientRepository.fetchClients(forUserId: userId) { [weak self] result in
            switch result {
            case .success(let clients):
                DispatchQueue.main.async {
                    print("FETCHING CLIENTS - UPDATED LIST")
                    self?.allClients = clients
                    // When the clients are updated, update the progress albums list too
                    self?.allProgressAlbums = clients.flatMap { $0.progressAlbums }
                }
            case .failure(let error):
                print("Error fetching clients: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.allClients = []
                    self?.allProgressAlbums = []  // If clients fetch fails, clear the progress albums too

                }
            }
        }
    }
    
    func getClient(clientID: String?) -> Client?{
        return allClients.first(where: { $0.id == clientID})
    }

    func createClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
            
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
            
        clientRepository.createClient(client, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated clients
                print("CLIENT CREATED \n")
                self?.fetchClients(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error adding client: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    

    func updateClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
            
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
            
        clientRepository.updateClient(client, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("\n Client updated successfully \n")
                // Fetch the updated clients
                self?.fetchClients(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error updating client: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func deleteClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
            
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
            
        clientRepository.deleteClient(client, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Client deleted successfully")
                // Fetch the updated clients
                self?.fetchClients(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error deleting client: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    func clearClientImageUrl(clientId: String, completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        
        clientRepository.clearClientImageUrl(clientId: clientId) { [weak self] result in
            switch result {
            case .success:
                print("Client's imageUrl cleared successfully")
                // Fetch the updated clients
                self?.fetchClients(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error deleting client's imageUrl: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // ProgressAlbum function
    func updateProgressAlbum( progressAlbum: ProgressAlbum, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // fetch Client from Almbum's clientID
        if var updatedClient = self.getClient(clientID: progressAlbum.clientID){
            
            // updating existing album
            if let albumIndex = updatedClient.getProgressAlbumIndex(progressAlbumId: progressAlbum.id){
                updatedClient.progressAlbums[albumIndex] = progressAlbum
            }
            // adding new album
            else{
                updatedClient.progressAlbums.append(progressAlbum)
            }
            
            // Update the client in the repository
            updateClient(updatedClient, completion: completion)
        }
        

    }
    
    
}

