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
    private let authenticationService: AnyAuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(phaseRepository: PhaseRepository, authenticationService: AnyAuthenticationService) {
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
    
    
    func getPhase(phaseID: String?) -> Phase?{
        return allPhases.first(where: { $0.id == phaseID})
    }
    
    func fetchPhases(forUserId userId: String) {
        print("FETCHING PHASES")
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
                self?.fetchPhases(forUserId: userId)
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
                self?.fetchPhases(forUserId: userId)
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
                self?.fetchPhases(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error deleting phase: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
}
