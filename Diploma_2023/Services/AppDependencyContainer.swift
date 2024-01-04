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
    
//    static var shared: AppDependencyContainer = {
//        return AppDependencyContainer(authenticationService: AnyAuthenticationService(AuthenticationService()))
//    }()

    var authenticationService: AnyAuthenticationService // <-- Using the type-erased wrapper

    
    
    var accountRepository: AccountRepository
    var categoryRepository: CategoryRepository
    var clientRepository: ClientRepository
    let exerciseRepository: ExerciseRepository
    let phaseRepository: PhaseRepository
    let mezoRepository: MezoRepository
    let imageRepository: ImageRepository
    let foodPlansRepository: FoodPlansRepository
    let pdfRepository: PdfRepository
    // Add other repositories and services as needed

    
    var accountDataStore: AccountDataStore
    var categoryDataStore: CategoryDataStore
    var clientsDataStore: ClientsDataStore
    let exercisesDataStore: ExercisesDataStore
    let phasesDataStore: PhasesDataStore
    let mezoDataStore: MezoDataStore
    let foodPlansDataStore: FoodPlansDataStore
    // Add other data stores as properties

//    init(
//        authenticationService : AnyAuthenticationService = AnyAuthenticationService(AuthenticationService())
//
//    ) {
//        self.authenticationService = authenticationService
    
    
    // Initialize either real or mocked repositories
    init(useMockedRepositories: Bool = false) {
        
        
        
        
        // ----------   TEST CODE --------- Comment/Uncomment this
        
//        authenticationService = AnyAuthenticationService(MockAuthenticationService())
//        
//        // Initialize mocked repositories
//        accountRepository = MockAccountRepository()
//        categoryRepository = MockCategoryRepository()
//        clientRepository = MockClientRepository()
//        exerciseRepository = MockExerciseRepository()
//        phaseRepository = MockPhaseRepository()
//        mezoRepository = MockMezoRepository()
//        imageRepository = MockImageRepository()
//        foodPlansRepository = MockFoodPlansRepository()
//        pdfRepository = MockPdfRepository()
//        
//        
//        
        
            // ----------   PRODUCTION CODE --------- Comment/Uncomment this

            authenticationService = AnyAuthenticationService(AuthenticationService())

            // Initialize real repositories
            accountRepository = FirestoreAccountRepository()
            categoryRepository = FirestoreCategoryRepository()
            clientRepository = FirestoreClientRepository()
            exerciseRepository = FirestoreExerciseRepository()
            phaseRepository = FirestorePhaseRepository()
            mezoRepository = FirestoreMezoRepository()
            imageRepository = FirebaseStorageImageRepository()
            foodPlansRepository = FirestoreFoodPlansRepository()
            pdfRepository = FirebaseStoragePdfRepository()
            // Initialize other repositories and services
        
        
        
        
        
        
        
        // Initialize data stores with either real or mocked repositories
        accountDataStore = AccountDataStore(accountRepository: accountRepository, authenticationService: authenticationService)
        categoryDataStore = CategoryDataStore(categoryRepository: categoryRepository, authenticationService: authenticationService)
        clientsDataStore = ClientsDataStore(clientRepository: clientRepository, authenticationService: authenticationService)
        exercisesDataStore = ExercisesDataStore(exerciseRepository: exerciseRepository, authenticationService: authenticationService)
        phasesDataStore = PhasesDataStore(phaseRepository: phaseRepository, authenticationService: authenticationService)
        mezoDataStore = MezoDataStore(mezoRepository: mezoRepository, authenticationService: authenticationService)
        foodPlansDataStore = FoodPlansDataStore(foodPlansRepository: foodPlansRepository, pdfRepository: pdfRepository,  authenticationService: authenticationService)
        // Initialize other data stores
        
        
    }
    
    
    
}
