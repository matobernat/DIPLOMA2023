//
//  AppDependencyContainer.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

struct AppDependencyContainer {
    
    // private init
    // lazy var
    
    
    static var shared = AppDependencyContainer()

    var authenticationService: AuthenticationService
    
    
    var accountRepository: AccountRepository
    var categoryRepository: CategoryRepository
    var clientRepository: ClientRepository
    let exerciseRepository: ExerciseRepository
    let phaseRepository: PhaseRepository
    let mezoRepository: MezoRepository
    let imageRepository: ImageRepository
    // Add other repositories and services as needed

    
    var accountDataStore: AccountDataStore
    var categoryDataStore: CategoryDataStore
    var clientsDataStore: ClientsDataStore
    let exercisesDataStore: ExercisesDataStore
    let phasesDataStore: PhasesDataStore
    let mezoDataStore: MezoDataStore
    // Add other data stores as properties

    init() {
        authenticationService = AuthenticationService()
        
        accountRepository = FirestoreAccountRepository()
        categoryRepository = FirestoreCategoryRepository()
        clientRepository = FirestoreClientRepository()
        exerciseRepository = FirestoreExerciseRepository()
        phaseRepository = FirestorePhaseRepository()
        mezoRepository = FirestoreMezoRepository()
        imageRepository = FirebaseStorageImageRepository()
        // Initialize other repositories and services

        
        accountDataStore = AccountDataStore(accountRepository: accountRepository, authenticationService: authenticationService)
        categoryDataStore = CategoryDataStore(categoryRepository: categoryRepository, authenticationService: authenticationService)
        clientsDataStore = ClientsDataStore(clientRepository: clientRepository, authenticationService: authenticationService)
        exercisesDataStore = ExercisesDataStore(exerciseRepository: exerciseRepository, authenticationService: authenticationService)
        phasesDataStore = PhasesDataStore(phaseRepository: phaseRepository, authenticationService: authenticationService)
        mezoDataStore = MezoDataStore(mezoRepository: mezoRepository, authenticationService: authenticationService)
        // Initialize other data stores
    }
    
    
    
}
