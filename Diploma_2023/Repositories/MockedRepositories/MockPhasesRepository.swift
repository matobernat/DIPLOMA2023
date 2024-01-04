//
//  MockPhasesRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation


class MockPhaseRepository: PhaseRepository {
    private var mockPhases: [String: [Phase]] = [MockedData.account.id:MockedData.phases]  // Dictionary to store mock phases by userId

    func fetchPhases(forUserId userId: String, completion: @escaping (Result<[Phase], Error>) -> Void) {
        let phases = mockPhases[userId] ?? []
        completion(.success(phases))
    }

    func createPhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userPhases = mockPhases[userId] {
            userPhases.append(phase)
            mockPhases[userId] = userPhases
        } else {
            mockPhases[userId] = [phase]
        }
        completion(.success(()))
    }

    func updatePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userPhases = mockPhases[userId], let index = userPhases.firstIndex(where: { $0.id == phase.id }) {
            userPhases[index] = phase
            mockPhases[userId] = userPhases
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Phase not found"])))
        }
    }

    func deletePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userPhases = mockPhases[userId], let index = userPhases.firstIndex(where: { $0.id == phase.id }) {
            userPhases.remove(at: index)
            mockPhases[userId] = userPhases
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Phase not found"])))
        }
    }
}
