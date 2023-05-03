//
//  CategoryDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/04/2023.
//

import Combine
import Foundation

class CategoryDataStore: ObservableObject {
    
    
    private var allCategories: [Category] = []
    
    @Published private(set) var categoriesClients: [Category] = []
    @Published private(set) var categoriesExercises: [Category] = []
    @Published private(set) var categoriesTrainingPlans: [Category] = []
    
    
    
    private let categoryRepository: CategoryRepository
    private let authenticationService: AuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(categoryRepository: CategoryRepository, authenticationService: AuthenticationService) {
        self.categoryRepository = categoryRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if userId != nil {
                print("\n CATEGORY FETCH \n")
                DispatchQueue.main.async {
                    self?.fetchCategories(for: userId)
                }
            } else {
                print("\n CATEGORY NIL \n")
                self?.allCategories = [] // Clear the categories when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    
    // Filtering
    
    private func filterCategoriesByType() -> (clients: [Category], exercises: [Category], trainingPlans: [Category]) {
        let clients = allCategories.filter { $0.section == .client }
        let exercises = allCategories.filter { $0.section == .exercise }
        let trainingPlans = allCategories.filter { $0.section == .trainingPlan }
        
        return (clients: clients, exercises: exercises, trainingPlans: trainingPlans)
    }
    
    private func updateCategories(_ categories: [Category]) {
        allCategories = categories
        let filteredCategories = filterCategoriesByType()

        DispatchQueue.main.async {
            self.categoriesClients = filteredCategories.clients
            self.categoriesExercises = filteredCategories.exercises
            self.categoriesTrainingPlans = filteredCategories.trainingPlans
        }
        
    }
    
    
    
    // Categories functions
    func getCategoryIDs(subString: String, section: DataType) -> [String]{
        var categories = [Category]()

        switch section {
        case .client:
            categories = self.categoriesClients
        case .exercise:
            categories = self.categoriesExercises
        case .trainingPlan:
            categories = self.categoriesTrainingPlans
        default:
            categories = self.categoriesClients
            print("getCategoryID error")
        }
        
        return categories.filter { $0.name.contains(subString) }.map{$0.id}
        
    }
    
    // Repository functions
    
    func fetchCategories(for userID: String? = nil) {
        
        let userId = userID ?? authenticationService.userId ?? ""
        
        guard !userId.isEmpty else {
            print("Error: User ID is not available")
            allCategories = []
            return
        }
        
        categoryRepository.fetchCategories(forUserId: userId) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.updateCategories(categories)
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
                self?.allCategories = []
            }
        }
        
    }

    func createCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        categoryRepository.createCategory(category, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated categories
                self?.fetchCategories()
                completion(.success(()))
            case .failure(let error):
                print("Error creating category: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updateCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        categoryRepository.updateCategory(category, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated categories
                self?.fetchCategories()
                completion(.success(()))
            case .failure(let error):
                print("Error updating category: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
        categoryRepository.deleteCategory(category, for: userId) { [weak self] result in
            switch result {
            case .success:
                // Fetch the updated categories
                self?.fetchCategories()
                completion(.success(()))
            case .failure(let error):
                print("Error deleting category: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    // Category functions
    
    
    func createCategoriesForAccount(for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {

        
        let iconDict: [String: String] = [
            "Recent": "clock.fill",
            "Favorite": "star.fill",
            "Archived": "archivebox",

            
            "client": "person.3.fill",
            "exercise": "sportscourt.fill",
            "trainingPlan": "list.bullet.rectangle",
            "foodPlan": "leaf.fill",
            "measurement": "chart.bar.fill",
            "progressAlbum": "camera.fill",

        ]
        
        let nameDict: [String: String] = [
            "client": "Clients",
            "exercise": "Exercises",
            "traniningPlan": "Training Protocols",
            "foodPlan": "Food Protocols",
            "measurement": "Measurements",
            "progressAlbum": "Progress Albums",

        ]
        
        
        let dataTypes: [DataType] = [.client, .exercise, .trainingPlan]
        let date = Date.now
        
        var results: [Result<Void, Error>] = []

        let dispatchGroup = DispatchGroup()

        var index = 1

        for dataType in dataTypes {
            
            // setting different time intervals for firestore sorting by date
            let allTimeInterval = TimeInterval(index * 10)  // multiply index by time interval
            let recentTimeInterval = TimeInterval(index * 20)
            let archivedTimeInterval = TimeInterval(index * 30)

            let categoryAll = Category(
                id: UUID().uuidString,
                name: "All \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(allTimeInterval),
                imageName: iconDict[dataType.rawValue] ?? "folder")
            
            let categoryRecent = Category(
                id: UUID().uuidString,
                name: "Recent \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(recentTimeInterval),
                imageName: iconDict["Recent"] ?? "folder")
            
            
            let categoryArchived = Category(
                id: UUID().uuidString,
                name: "Archived \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(archivedTimeInterval),
                imageName: iconDict["Archived"] ?? "folder")
                        
            
            dispatchGroup.enter()

            createCategory(categoryAll) { result in
                results.append(result)
                dispatchGroup.leave()
            }

            dispatchGroup.enter()

            createCategory(categoryRecent) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()

            createCategory(categoryArchived) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
            
            index += 3 // increment index by 3 for the next loop iteration
        }

        
        dispatchGroup.notify(queue: .main) {
            if results.contains(where: { result in
                if case .failure = result {
                    return true
                }
                return false
            }) {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating categories"])))
            } else {
                completion(.success(()))
            }
        }
    }

    func createCategoriesForProfile(for profileID: String, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let iconDict: [String: String] = [
            "Recent": "clock.fill",
            "Favorite": "star.fill",
            "Archived": "archivebox",

            "client": "person.2.fill",
            "exercise": "sportscourt",
            "trainingPlan": "list.bullet.rectangle.portrait",
            "foodPlan": "leaf.fill",
            "measurement": "chart.bar.fill",
            "progressAlbum": "camera.fill"

        ]
        
        let nameDict: [String: String] = [
            "client": "Clients",
            "exercise": "Exercises",
            "trainingPlan": "Training Protocols",
            "foodPlan": "Food Protocols",
            "measurement": "Measurements",
            "progressAlbum": "Progress Albums",

        ]
        
        let dataTypes: [DataType] = [.client, .exercise, .trainingPlan]
        let date = Date.now.addingTimeInterval(200)
        
        var results: [Result<Void, Error>] = []
        let dispatchGroup = DispatchGroup()
        
        var index = 1
        for dataType in dataTypes {
            
            // setting different time intervals for firestore sorting by date
            let allTimeInterval = TimeInterval(300 + index * 10)
            let recentTimeInterval = TimeInterval(300 + index * 20)
            let archivedTimeInterval = TimeInterval(300 + index * 30)
            
            let categoryMy = Category(
                id: UUID().uuidString,
                name: "My \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(allTimeInterval),
                profileID: profileID,
                imageName: iconDict[dataType.rawValue] ?? "folder")
            
            let categoryFavorite = Category(
                id: UUID().uuidString,
                name: "Favorite \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(recentTimeInterval),
                profileID: profileID,
                imageName: iconDict["Favorite"] ?? "folder")
            
            let categoryArchived = Category(
                id: UUID().uuidString,
                name: "Archived \(nameDict[dataType.rawValue] ?? "")",
                section: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(archivedTimeInterval),
                profileID: profileID,
                imageName: iconDict["Archived"] ?? "folder")
            
            dispatchGroup.enter()

            createCategory(categoryMy) { result in
                results.append(result)
                dispatchGroup.leave()
            }

            dispatchGroup.enter()

            createCategory(categoryFavorite) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()

            createCategory(categoryArchived) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
                index += 3
        }
        

        dispatchGroup.notify(queue: .main) {
            if results.contains(where: { result in
                if case .failure = result {
                    return true
                }
                return false
            }) {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating categories"])))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    
}
