//
//  ExercisesDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Combine
import Foundation


class ExercisesDataStore: ObservableObject {
    @Published private(set) var allExercises: [Exercise] = []
    private let exerciseRepository: ExerciseRepository
    private let authenticationService: AuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(exerciseRepository: ExerciseRepository, authenticationService: AuthenticationService) {
        self.exerciseRepository = exerciseRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if let userId = userId {
                self?.fetchExercises(forUserId: userId)
            } else {
                self?.allExercises = [] // Clear the exercises when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    

    func fetchExercises(forUserId userId: String) {
        
        exerciseRepository.fetchExercises(forUserId: userId) { [weak self] result in
            switch result {
            case .success(let exercises):
                DispatchQueue.main.async {
                    self?.allExercises = exercises
                }
            case .failure(let error):
                print("Error fetching exercises: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.allExercises = []
                }
            }
        }
    }
    
    func createExercise(_ exercise: Exercise, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        exerciseRepository.createExercise(exercise, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated exercises
                self?.fetchExercises(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error adding exercise: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updateExercise(_ exercise: Exercise, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        exerciseRepository.updateExercise(exercise, for: userId) { [weak self] result in
            switch result {
            case .success:
                print("Exercise updated successfully")
                // Fetch the updated exercises
                self?.fetchExercises(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error updating exercise: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
            
        exerciseRepository.deleteExercise(exercise, for: userId) { [weak self] result in
           
            switch result {
            case .success:
                print("Exercise deleted successfully")
                // Fetch the updated clients
                self?.fetchExercises(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


