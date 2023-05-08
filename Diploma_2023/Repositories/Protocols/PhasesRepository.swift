//
//  PhasesRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Foundation


protocol PhaseRepository {
    func fetchPhases(forUserId userId: String, completion: @escaping (Result<[Phase], Error>) -> Void)
    func createPhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deletePhase(_ phase: Phase, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
