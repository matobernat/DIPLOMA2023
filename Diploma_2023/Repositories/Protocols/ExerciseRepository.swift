//
//  ExerciseRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/04/2023.
//

import Foundation


protocol ExerciseRepository {
    func fetchExercises(forUserId userId: String, completion: @escaping (Result<[Exercise], Error>) -> Void)
    func createExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteExercise(_ exercise: Exercise, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
