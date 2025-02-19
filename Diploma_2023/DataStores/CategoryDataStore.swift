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
    @Published private(set) var categoriesProgressAlbum: [Category] = []
    @Published private(set) var categoriesMeasurements: [Category] = []
    @Published private(set) var categoriesFoodPlans: [Category] = []

    
    
    
    
    private let categoryRepository: CategoryRepository
    private let authenticationService: AnyAuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(categoryRepository: CategoryRepository, authenticationService: AnyAuthenticationService) {
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
    
    private func filterCategoriesByType() -> (clients: [Category],
                                              exercises: [Category],
                                              trainingPlans: [Category],
                                              progressAlbum: [Category],
                                              measurements: [Category],
                                              foodPlans: [Category]) {
        
        let clients = allCategories.filter { $0.dataType == .client }
        let exercises = allCategories.filter { $0.dataType == .exercise }
        let trainingPlans = allCategories.filter { $0.dataType == .trainingPlan }
        let progressAlbum = allCategories.filter { $0.dataType == .progressAlbum }
        let measurements = allCategories.filter { $0.dataType == .measurement }
        let foodPlans = allCategories.filter { $0.dataType == .foodPlan }


        
        return (clients: clients,
                exercises: exercises,
                trainingPlans: trainingPlans,
                progressAlbum: progressAlbum,
                measurements: measurements,
                foodPlans: foodPlans)
    }
    
    private func updateCategories(_ categories: [Category]) {
        allCategories = categories
        let filteredCategories = filterCategoriesByType()

        DispatchQueue.main.async {
            self.categoriesClients = filteredCategories.clients
            self.categoriesExercises = filteredCategories.exercises
            self.categoriesTrainingPlans = filteredCategories.trainingPlans
            self.categoriesProgressAlbum = filteredCategories.progressAlbum
            self.categoriesMeasurements = filteredCategories.measurements
            self.categoriesFoodPlans = filteredCategories.foodPlans

        }
        
    }
    
    
    
    // GET BY ID local functions
    func getCategoryIDs(subStrings: [String], section: DataType) -> [String]{
        var categories = [Category]()

        switch section {
        case .client:
            categories = self.categoriesClients
        case .exercise:
            categories = self.categoriesExercises
        case .trainingPlan:
            categories = self.categoriesTrainingPlans
        case .progressAlbum:
            categories = self.categoriesProgressAlbum
        case .measurement:
            categories = self.categoriesMeasurements
        case .foodPlan:
            categories = self.categoriesFoodPlans
        default:
            categories = self.categoriesClients
            print("getCategoryID error")
        }
                
        return categories.filter { category in
            subStrings.contains(where: category.name.contains)
        }.map{$0.id}
    }
    
    func getCategoryIDs(selectedCategory: Category) -> [String]{
        var IDs=[String]()
        
        allCategories = [Category]()
        
        switch selectedCategory.dataType{
        case .client:
            allCategories = self.categoriesClients
        case .exercise:
            allCategories = self.categoriesExercises
        case .trainingPlan:
            allCategories = self.categoriesTrainingPlans
        case .progressAlbum:
            allCategories = self.categoriesProgressAlbum
        case .measurement:
            allCategories = self.categoriesMeasurements
        case .foodPlan:
            allCategories = self.categoriesFoodPlans
        default:
            print("getCategoryIDs ERROR")
            allCategories = [Category]()
        }
        
        for category in self.allCategories {
            
            // if archived, add only to archived
            if selectedCategory.name.contains("Archived"){
                if category.name.contains("Archived"){
                    IDs.append(category.id)
                }
                continue
            }
                
                
            // This is the default rule
            if category.name.contains("All") ||
                category.name.contains("Recent") ||
                category.name.contains("My") {
                
                IDs.append(category.id)
            }
            
            // Favorites is optional
            if selectedCategory.name.contains("Favorite"){
                if category.name.contains("Favorite"){
                    IDs.append(category.id)
                }
            }
            
        }
        return IDs
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

    func createCategory(_ category: Category, forUserId userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
//        guard let userId = authenticationService.userId else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
//            print("CategoryDataStore.createCategory() - userID is not available")
//            return
//        }
        
        
        
        print("func createCategory() - started")
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
    
    
    func createCategoriesForAccount(forAccount userId: String, completion: @escaping (Result<Void, Error>) -> Void) {

        
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
        
        
        let dataTypes: [DataType] = [.client, .exercise, .trainingPlan, .progressAlbum, .measurement, .foodPlan]
        
//        let dataTypes: [DataType] =  [.foodPlan] // for manual add function
        
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
                dataType: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(allTimeInterval),
                imageName: iconDict[dataType.rawValue] ?? "folder")
            
            let categoryRecent = Category(
                id: UUID().uuidString,
                name: "Recent \(nameDict[dataType.rawValue] ?? "")",
                dataType: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(recentTimeInterval),
                imageName: iconDict["Recent"] ?? "folder")
            
            
            let categoryArchived = Category(
                id: UUID().uuidString,
                name: "Archived \(nameDict[dataType.rawValue] ?? "")",
                dataType: dataType,
                isGlobal: true,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(archivedTimeInterval),
                imageName: iconDict["Archived"] ?? "folder")
                        
            
            dispatchGroup.enter()

            print("CategoryDataStore.createCategories() - try to call createCategory()")
            createCategory(categoryAll, forUserId: userId) { result in
                results.append(result)
                dispatchGroup.leave()
            }

            dispatchGroup.enter()

            createCategory(categoryRecent, forUserId: userId) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()

            createCategory(categoryArchived, forUserId: userId) { result in
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

    func createCategoriesForProfile(forProfile profileID: String, forAccount userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
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
        
        let dataTypes: [DataType] = [.client, .exercise, .trainingPlan, .progressAlbum, .measurement, .foodPlan]
        
//        let dataTypes: [DataType] = [.foodPlan] // for manual add function
        
    
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
                dataType: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(allTimeInterval),
                profileID: profileID,
                imageName: iconDict[dataType.rawValue] ?? "folder")
            
            let categoryFavorite = Category(
                id: UUID().uuidString,
                name: "Favorite \(nameDict[dataType.rawValue] ?? "")",
                dataType: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(recentTimeInterval),
                profileID: profileID,
                imageName: iconDict["Favorite"] ?? "folder")
            
            let categoryArchived = Category(
                id: UUID().uuidString,
                name: "Archived \(nameDict[dataType.rawValue] ?? "")",
                dataType: dataType,
                isGlobal: false,
                accountID: userId,
                dateOfCreation: date.addingTimeInterval(archivedTimeInterval),
                profileID: profileID,
                imageName: iconDict["Archived"] ?? "folder")
            
            dispatchGroup.enter()

            createCategory(categoryMy, forUserId: userId) { result in
                results.append(result)
                dispatchGroup.leave()
            }

            dispatchGroup.enter()

            createCategory(categoryFavorite, forUserId: userId) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()

            createCategory(categoryArchived, forUserId: userId) { result in
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
