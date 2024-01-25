//
//  MockMezocycleRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation


class MockMezoRepository: MezoRepository {
    private var mockMezos: [String: [Mezocycle]] = [MockedData.account.id:MockedData.mezocycles]  // Dictionary to store mock mezocycles by userId

    func fetchMezos(forUserId userId: String, completion: @escaping (Result<[Mezocycle], Error>) -> Void) {
        let mezocycles = mockMezos[userId] ?? []
        completion(.success(mezocycles))
    }

    func createMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userMezos = mockMezos[userId] {
            userMezos.append(mezo)
            mockMezos[userId] = userMezos
        } else {
            mockMezos[userId] = [mezo]
        }
        completion(.success(()))
    }

    func updateMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userMezos = mockMezos[userId], let index = userMezos.firstIndex(where: { $0.id == mezo.id }) {
            userMezos[index] = mezo
            mockMezos[userId] = userMezos
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mezocycle not found"])))
        }
    }

    func deleteMezo(_ mezo: Mezocycle, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userMezos = mockMezos[userId], let index = userMezos.firstIndex(where: { $0.id == mezo.id }) {
            userMezos.remove(at: index)
            mockMezos[userId] = userMezos
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mezocycle not found"])))
        }
    }
}
=======
//  Created by Martin Bernát on 03/01/2024.
//

import Foundation
>>>>>>> main
