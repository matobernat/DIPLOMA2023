//
//  MezocycleDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Combine
import Foundation


class MezoDataStore: ObservableObject {
    @Published private(set) var allMezos: [Mezocycle] = []
    private let mezoRepository: MezoRepository
    private let authenticationService: AnyAuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(mezoRepository: MezoRepository, authenticationService: AnyAuthenticationService) {
        self.mezoRepository = mezoRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if let userId = userId {
                print("FETCHING MESO USER IN ")
                self?.fetchMezos(forUserId: userId)
            } else {
                self?.allMezos = [] // Clear the mezos when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    

    func getMezo(mezoID: String?) -> Mezocycle?{
        return allMezos.first(where: { $0.id == mezoID})
    }
    
    
    func fetchMezos(forUserId userId: String) {
        mezoRepository.fetchMezos(forUserId: userId) { [weak self] result in
            switch result {
            case .success(let mezos):
                DispatchQueue.main.async {
                    self?.allMezos = mezos
                }
            case .failure(let error):
                print("Error fetching mezos: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.allMezos = []
                }
            }
        }
    }
    
    func createMezo(_ mezo: Mezocycle, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        mezoRepository.createMezo(mezo, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated mezos
                self?.fetchMezos(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error adding mezo: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updateMezo(_ mezo: Mezocycle, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        mezoRepository.updateMezo(mezo, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Mezo updated successfully")
                // Fetch the updated mezos
                self?.fetchMezos(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error updating mezo: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteMezo(_ mezo: Mezocycle, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        mezoRepository.deleteMezo(mezo, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Mezo deleted successfully")
                // Fetch the updated mezos
                self?.fetchMezos(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error deleting mezo: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
}
