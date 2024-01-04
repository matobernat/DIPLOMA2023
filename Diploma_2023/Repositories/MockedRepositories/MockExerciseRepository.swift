//
//  MockExerciseRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation



class MockExerciseRepository: ExerciseRepository {
    private var mockExercises: [String: [Exercise]] = [MockedData.account.id:MockedData.exercises]  // Dictionary to store mock exercises by userId

    func fetchExercises(forUserId userId: String, completion: @escaping (Result<[Exercise], Error>) -> Void) {
        let exercises = mockExercises[userId] ?? []
        completion(.success(exercises))
    }

    func createExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userExercises = mockExercises[userId] {
            userExercises.append(exercise)
            mockExercises[userId] = userExercises
        } else {
            mockExercises[userId] = [exercise]
        }
        completion(.success(()))
    }

    func updateExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userExercises = mockExercises[userId], let index = userExercises.firstIndex(where: { $0.id == exercise.id }) {
            userExercises[index] = exercise
            mockExercises[userId] = userExercises
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Exercise not found"])))
        }
    }

    func deleteExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if var userExercises = mockExercises[userId], let index = userExercises.firstIndex(where: { $0.id == exercise.id }) {
            userExercises.remove(at: index)
            mockExercises[userId] = userExercises
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Exercise not found"])))
        }
    }
}
