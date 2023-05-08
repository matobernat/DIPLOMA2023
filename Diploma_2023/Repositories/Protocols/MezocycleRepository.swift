//
//  MezocycleRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Foundation


protocol MezoRepository {
    func fetchMezos(forUserId userId: String, completion: @escaping (Result<[Mezocycle], Error>) -> Void)
    func createMezo(_ client: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateMezo(_ client: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteMezo(_ client: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
