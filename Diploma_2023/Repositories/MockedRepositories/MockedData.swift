//
//  MockedData.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 09/01/2024.
//

import Foundation



struct MockedData {
    static let categories = allMockCategories
    static let exercises = mockExercises
    static let phases = mockPhases
    static let mezocycles = mockMezocycles
    static let measurements = mockMeasurements
    static let foodPlans = mockFoodPlans
    static let progressAlbums = mockProgressAlbums
    static let account = mockAccount
    static let profile = mockProfile
    static let clients = mockClients
    // ... other mock data ...
}








// CLIENTS


let mockClients = [
    Client(
        id: "client01",
        categoryIDs: ["category01","category02"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        firstName: "Alice",
        lastName: "Smith",
        gender: .female,
        email: "alice.smith@example.com",
        phone: "555-0101",
        age: "30",
        weight: "65kg",
        height: "170cm",
        active: true,
        trainingStyle: .inPerson,
        injury: "None",
        healthIssues: "None",
        paymentType: .monthly,
        phases: [mockPhases[0]],
        mezocycles: [mockMezocycles[0]],
        progressAlbums: [mockProgressAlbums[1]],
        measurements: [mockMeasurements],
        foodPlans: [mockFoodPlans[0]],
        foodPlanIDs: [],
        measurementIDs: [],
        progressAlbumIDs: []
    ),
    Client(
        id: "client02",
        categoryIDs: ["category01","category02"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        firstName: "Bob",
        lastName: "Johnson",
        gender: .male,
        email: "bob.johnson@example.com",
        phone: "555-0202",
        age: "35",
        weight: "80kg",
        height: "180cm",
        active: false,
        trainingStyle: .distant,
        injury: "Lower back pain",
        healthIssues: "Hypertension",
        paymentType: .perSession,
        phases: [mockPhases[1]],
        mezocycles: [mockMezocycles[1]],
        progressAlbums: [],
        measurements: [],
        foodPlans: [],
        foodPlanIDs: [],
        measurementIDs: [],
        progressAlbumIDs: []
    )
]









// Mock Profile
let mockProfile = Profile(
    id: "profile01",
    name: "John Trainer",
    email: "john.trainer@example.com",
    dateOfCreation: Date()
)

// Mock Account with the Profile
let mockAccount = Account(
    id: "account01",
    name: "Fitness Pro Inc.",
    email: "contact@fitnesspro.com",
    address: "123 Fitness Street, Healthy City",
    loggedProfile: mockProfile,
    profiles: [mockProfile],
    dateOfCreation: Date()
)


// PROGRESS ALBUM

let photoPath1 = "/Users/martinbernat/DIPLOMA2023/mockData/ProgressPhoto1.jpeg"
let photoPath2 = "/Users/martinbernat/DIPLOMA2023/mockData/ProgressPhoto2.jpeg"
let foodPlanPath1 = "/Users/martinbernat/DIPLOMA2023/mockData/foodPlan01.pdf"

let mockProgressAlbums = [
    ProgressAlbum(
        title: "Empty Album",
        subTitle: "No Photos",
        categoryIDs: ["category09"],
        accountID: "account01",
        clientID: "client01",
        profileID: "profile01",
        dateOfCreation: Date(),
        dateLastModification: Date(),
        progressPhotos: []  // No photos in this album
    ),
    ProgressAlbum(
        title: "Training Progress",
        subTitle: "2 Photos",
        categoryIDs: ["category09"],
        accountID: "account01",
        clientID: "client02",
        profileID: "profile01",
        dateOfCreation: Date(),
        dateLastModification: Date(),
        progressPhotos: [
            ProgressPhoto(id: "photo01", imageUrl: photoPath1, dateOfCreation: Date()),
            ProgressPhoto(id: "photo02", imageUrl: photoPath2, dateOfCreation: Date())
        ]
    )
]



//FOOD PLAN

let mockFoodPlans = [
    FoodPlan(
        id: "foodPlan01",
        title: "Weight Loss Meal Plan",
        subTitle: "1200 Calorie Diet",
        categoryIDs: ["category11"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "",
        apiKey: "mockAPIKey",
        pdfMonkeyTemplateID: "mockTemplateID",
        inputData: FoodPlan.convertJSONStringToFoodPlanData(FoodPlan.template3_InputData)!,  // my predefined FoodPlanData
        firestoreDownloadURL: foodPlanPath1,  // Local or placeholder URL
        pdfMonkeyDownloadURL: nil,
        documentID: nil,
        status: nil
    ),
    FoodPlan(
        id: "foodPlan01",
        title: "Weight Loss Meal Plan",
        subTitle: "1200 Calorie Diet",
        categoryIDs: ["category11"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "client01",
        apiKey: "mockAPIKey",
        pdfMonkeyTemplateID: "mockTemplateID",
        inputData: FoodPlan.convertJSONStringToFoodPlanData(FoodPlan.template3_InputData)!,  // my predefined FoodPlanData
        firestoreDownloadURL: foodPlanPath1,  // Local or placeholder URL
        pdfMonkeyDownloadURL: nil,
        documentID: nil,
        status: nil
    )
    
]





// MEASUREMENT

let mockMeasurements = Measurements(
    id: "measurements01",
    clientName: "John Doe",
    dateOfCreation: Date(),
    measurements: [
        Measurement(
            date: "2023-09-01",
            age: "30",
            height: "180",
            weight: "80",
            chin: "5", cheek: "6", pec: "12", triceps: "8", subscap: "10", midAx: "7", suprailiac: "9", umbilical: "11", knee: "6", calve: "7", quad: "12", hamstring: "11", biceps: "9",
            ratingChin: 2, ratingCheek: 2, ratingPec: 3, ratingTriceps: 2, ratingSubscap: 3, ratingMidAx: 2, ratingSuprailiac: 3, ratingUmbilical: 3, ratingKnee: 2, ratingCalve: 2, ratingQuad: 3, ratingHamstring: 3, ratingBiceps: 2
        ),
        Measurement(
            date: "2023-10-01",
            age: "30",
            height: "180",
            weight: "82",
            chin: "6", cheek: "7", pec: "13", triceps: "9", subscap: "11", midAx: "8", suprailiac: "10", umbilical: "12", knee: "7", calve: "8", quad: "13", hamstring: "12", biceps: "10",
            ratingChin: 3, ratingCheek: 3, ratingPec: 4, ratingTriceps: 3, ratingSubscap: 4, ratingMidAx: 3, ratingSuprailiac: 4, ratingUmbilical: 4, ratingKnee: 3, ratingCalve: 3, ratingQuad: 4, ratingHamstring: 4, ratingBiceps: 3
        )
    ],
    title: "Client Measurements",
    subTitle: "2 Measurements",
    categoryIDs: ["category07"],
    clientID: "client01",
    profileID: "profile01",
    accountID: "account01"
)



// MESOCYCLES

let mockMezocycles = [
    Mezocycle(
        id: "mezocycle01",
        title: "Summer Prep Program",
        categoryIDs: ["category06"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: nil,
        clientName: "",
        phases: [mockPhases[0]],
        durationInMonths: "2",
        trainingFocus: "Muscle Definition",
        intensity: "High",
        progressionStrategy: "Linear",
        totalTrainings: "16",
        description: "A program focused on building muscle definition for the summer season."
    ),
    Mezocycle(
        id: "mezocycle02",
        title: "Winter Strength Cycle",
        categoryIDs: ["category06"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: nil,
        clientName: "",
        phases: [mockPhases[1]],
        durationInMonths: "3",
        trainingFocus: "Strength Building",
        intensity: "Moderate",
        progressionStrategy: "Non-linear",
        totalTrainings: "24",
        description: "A program designed to increase overall strength during the winter months."
    )
]



// MESOCYCLES - for clients
let clientsMockMezocycles = [
    Mezocycle(
        id: "mezocycle03",
        title: "Summer Prep Program",
        categoryIDs: ["category06"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "client01",
        clientName: "John Doe",
        phases: [mockPhases[0]],
        durationInMonths: "2",
        trainingFocus: "Muscle Definition",
        intensity: "High",
        progressionStrategy: "Linear",
        totalTrainings: "16",
        description: "A program focused on building muscle definition for the summer season."
    ),
    Mezocycle(
        id: "mezocycle04",
        title: "Winter Strength Cycle",
        categoryIDs: ["category06"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "client02",
        clientName: "Jane Smith",
        phases: [mockPhases[1]],
        durationInMonths: "3",
        trainingFocus: "Strength Building",
        intensity: "Moderate",
        progressionStrategy: "Non-linear",
        totalTrainings: "24",
        description: "A program designed to increase overall strength during the winter months."
    )
]



// PHASE

let mockPhases = [
    Phase(
        id: "phase01",
        categoryIDs: ["category03"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "client01",
        mezocycleID: "mezocycle01",
        phaseName: "Strength Building",
        phaseDurationInWeeks: "4",
        headerClientName: "John Doe",
        headerPhaseInSeason: "Off-Season",
        headerPeriodizationTitle: "Hypertrophy",
        headerIntegrationGoal: "Muscle Gain",
        sheetRows: [
            SheetRow(exerciseID: "exercise01", exerciseName: "Squats", exerciseSettings: ExerciseSettings.getPredefined()),
            SheetRow(exerciseID: "exercise02", exerciseName: "Deadlifts", exerciseSettings: ExerciseSettings.getPredefined())
        ],
        trainingSessions: []
    ),
    Phase(
        id: "phase02",
        categoryIDs: ["category03"],
        dateOfCreation: Date(),
        accountID: "account01",
        profileID: "profile01",
        clientID: "client02",
        mezocycleID: "mezocycle02",
        phaseName: "Endurance Training",
        phaseDurationInWeeks: "6",
        headerClientName: "Jane Smith",
        headerPhaseInSeason: "Pre-Season",
        headerPeriodizationTitle: "Endurance",
        headerIntegrationGoal: "Stamina Improvement",
        sheetRows: [
            SheetRow(exerciseID: "exercise03", exerciseName: "Bench Press", exerciseSettings: ExerciseSettings.getPredefined()),
            SheetRow(exerciseID: "exercise01", exerciseName: "Squats", exerciseSettings: ExerciseSettings.getPredefined())
        ],
        trainingSessions: []
    )
]






// EXERCISES

let mockExercises = [
    Exercise(id: "exercise01", title: "Squats", subTitle: "Leg Workout", categoryIDs: ["category05"], dateOfCreation: Date(), accountID: "account01", profileID: "profile01", bodyPart: "Legs", recovery: false, baseMovement: "Squat", difficulty: "Medium", link: "https://youtu.be/n7rwJiAdlQU", tags: ["strength", "lower-body"]),
    Exercise(id: "exercise02", title: "Deadlifts", subTitle: "Back Strength", categoryIDs: ["category05"], dateOfCreation: Date(), accountID: "account01", profileID: "profile01", bodyPart: "Back", recovery: false, baseMovement: "Hinge", difficulty: "Hard", link: "https://youtu.be/o5CyBtvfi8M", tags: ["power", "upper-body"]),
    Exercise(id: "exercise03", title: "Bench Press", subTitle: "Chest Workout", categoryIDs: ["category05"], dateOfCreation: Date(), accountID: "account01", profileID: "profile01", bodyPart: "Chest", recovery: false, baseMovement: "Push", difficulty: "Medium", link: "https://youtu.be/n7rwJiAdlQU", tags: ["strength", "upper-body"])
]


// CATEGORIES

let mockCategories = [
    // Categories for Clients
    Category(id: "category01", name: "All Clients", dataType: .client, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "clients-all"),
    Category(id: "category02", name: "My Clients", dataType: .client, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "clients-my"),

    // Categories for Training Plans
    Category(id: "category03", name: "All Training Plans", dataType: .trainingPlan, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "training-plans-all"),
    Category(id: "category04", name: "My Training Plans", dataType: .trainingPlan, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "training-plans-my"),

    // Categories for Exercises
    Category(id: "category05", name: "All Exercises", dataType: .exercise, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "exercises-all"),
    Category(id: "category06", name: "My Exercises", dataType: .exercise, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "exercises-my")
]

// Continuing from the previous categories...
let additionalMockCategories = [
    // Categories for Measurements
    Category(id: "category07", name: "All Measurements", dataType: .measurement, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "measurements-all"),
    Category(id: "category08", name: "My Measurements", dataType: .measurement, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "measurements-my"),

    // Categories for Progress Photos
    Category(id: "category09", name: "All Progress Photos", dataType: .progressAlbum, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "progress-photos-all"),
    Category(id: "category10", name: "My Progress Photos", dataType: .progressAlbum, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "progress-photos-my"),

    // Categories for Food Plans
    Category(id: "category11", name: "All Food Plans", dataType: .foodPlan, isGlobal: true, accountID: "account01", dateOfCreation: Date(), profileID: nil, imageName: "food-plans-all"),
    Category(id: "category12", name: "My Food Plans", dataType: .foodPlan, isGlobal: false, accountID: "account01", dateOfCreation: Date(), profileID: "profile01", imageName: "food-plans-my")
]

// Combine all categories into a single array
let allMockCategories = mockCategories + additionalMockCategories
