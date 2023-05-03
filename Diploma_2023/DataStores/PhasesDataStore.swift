//
//  PhasesDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Combine
import Foundation


class PhasesDataStore: ObservableObject {
    @Published private(set) var allPhases: [Phase] = []
    private let phaseRepository: PhaseRepository
    private let authenticationService: AuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(phaseRepository: PhaseRepository, authenticationService: AuthenticationService) {
        self.phaseRepository = phaseRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if let userId = userId {
                self?.fetchPhases(forUserId: userId)
            } else {
                self?.allPhases = [] // Clear the phases when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func fetchPhases(forUserId userId: String) {
        phaseRepository.fetchPhases(forUserId: userId) { result in
            // Handle the result here
        }
    }
    
    func fetchPhases() {
        guard let userId = authenticationService.userId else {
            print("Error: User ID is not available")
            allPhases = []
            return
        }
        
        phaseRepository.fetchPhases(forUserId: userId) { [weak self] result in
            switch result {
            case .success(let phases):
                DispatchQueue.main.async {
                    self?.allPhases = phases
                }
            case .failure(let error):
                print("Error fetching phases: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.allPhases = []
                }
            }
        }
    }
    
    func createPhase(_ phase: Phase, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        phaseRepository.createPhase(phase, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated phases
                self?.fetchPhases()
                completion(.success(()))
            case .failure(let error):
                print("Error adding phase: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updatePhase(_ phase: Phase, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        phaseRepository.updatePhase(phase, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Phase updated successfully")
                // Fetch the updated phases
                self?.fetchPhases()
                completion(.success(()))
            case .failure(let error):
                print("Error updating phase: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deletePhase(_ phase: Phase, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        phaseRepository.deletePhase(phase, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Phase deleted successfully")
                // Fetch the updated phases
                self?.fetchPhases()
                completion(.success(()))
            case .failure(let error):
                print("Error deleting phase: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
}
