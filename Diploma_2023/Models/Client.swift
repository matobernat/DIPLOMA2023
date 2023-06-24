//
//  Client.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import Foundation





struct Client: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable  {

    //<IdentifiableItem properties>
    var id = UUID().uuidString // fireBase UID
    var dataType: DataType { .client }
    var title: String {
        return "\(firstName) \(lastName)"
    }
    var subTitle: String{
        return active ? "Active" : "Inactive"
    }
    var categoryIDs: [String]
    var imageName = "client-photo"
    var dateOfCreation: Date


    var clientID: String? = nil
    var accountID: String
    var profileID: String


    // personal info
    var firstName: String
    var lastName: String
    
    var email: String
    var phone: String
    
    var age: String
    var weight: String
    var height: String
    var active: Bool
    var allSessionsCount: Int = 0
    var doneSessionsCount: Int = 0

    
    // Info list row
    var trainingStyle: TrainingStyle
    var injury: String
    var healthIssues: String
    var paymentType: PaymentType
    

    var phases = [Phase]()
    var mezocycles =  [Mezocycle]()
    var foodPlanIDs: [String]
    var measurementIDs: [String]
    var progressAlbumIDs: [String]
}








// Remaining Tranings
extension Client{
    
    func calculateFinishedPhasesPercentage() -> Double {

        let totalAvailableSessions = self.getTotalAvailableSessions()
        let totalFinishedSessions = self.getTotalFinishedSessions()
        
        if totalAvailableSessions == 0 {
            return 0 // Avoid division by zero
        }
        let finishedPercentage = Double(totalFinishedSessions) / Double(totalAvailableSessions) * 100.0
        print ("PERCENTAGE:\(finishedPercentage)  \(totalFinishedSessions) finished   \(totalAvailableSessions) available ")

        return finishedPercentage
    }
    
    func getTotalAvailableSessions() ->Int{
        let totalAvailableSessions = self.phases.reduce(0) { $0 + $1.getNumberOfAllAvailableSessions() } +
        self.mezocycles.reduce(0) { $0 + $1.getNumberOfAllAvailableSessions() }
        return totalAvailableSessions
    }
    
    func getTotalFinishedSessions() ->Int{
        let totalFinishedSessions = self.phases.reduce(0) { $0 + $1.getNumberOfAllFinishedSessions() } +
        self.mezocycles.reduce(0) { $0 + $1.getNumberOfAllFinishedSessions() }
        return totalFinishedSessions
    }
    
    

}


// Phases + Mezos CRUD functions
extension Client{
    
    //MARK: Client - Mezocycle related func
    /// This function add mezocycle to the client.
    func addMezo(mezo: Mezocycle) -> Client{
        var copy = self
        copy.mezocycles.append(mezo)
//        var newMezo = mezo.duplicate(existingTitles: existingTitles, keepName: true) // get mezo with new ID
//        copy.mezocycles.append(newMezo.AddMezoToClient(clientID: copy.id, clientName: copy.title))
        return copy
    }
    /// This function updates its mezocycle based on ID
    /// - Returns: The client with the updated mezocycle
    func updateMezo(mezo: Mezocycle) -> Client {
        guard let index = self.mezocycles.firstIndex(where: { $0.id == mezo.id }) else {
            // Mezocycle with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.mezocycles[index] = mezo
        
        return copy
    }
    /// This function deletes a mezocycle based on ID
    /// - Returns: The client with the deleted mezocycle
    func deleteMezo(mezoID: String) -> Client {
        var copy = self
        copy.mezocycles.removeAll(where: { $0.id == mezoID })
        
        return copy
    }
    
    
    //MARK: Client - Phase related func
    /// This function add phase to the client.
    /// - Returns: returned client have phase client ID and client name also set
    func addPhase(phase: Phase) -> Client{
        var copy = self
        copy.phases.append(phase)
        return copy
    }
    
    /// This function updates its phase based on ID
    /// - Returns: The client with the updated phase
    func updatePhase(phase: Phase) -> Client {
        guard let index = self.phases.firstIndex(where: { $0.id == phase.id }) else {
            // Mezocycle with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.phases[index] = phase
        
        return copy
    }
    /// This function deletes a phase based on ID
    /// - Returns: The client with the deleted phase
    func deletePhase(phaseID: String) -> Client {
        var copy = self
        copy.phases.removeAll(where: { $0.id == phaseID })
        
        return copy
    }
}

// static factory methods
extension Client{
    
    static func getNewClient( categoryIDs : [String], accountID: String, profileID: String) -> Client{
        return Client(
                categoryIDs: categoryIDs,
                dateOfCreation: .now,
                accountID: accountID,
                profileID: profileID,
                firstName: "",
                lastName: "",
                email: "",
                phone: "",
                age: "",
                weight: "",
                height: "",
                active: true,
                trainingStyle: .inPerson,
                injury: "",
                healthIssues: "",
                paymentType: .perSession,
                phases: [],
                mezocycles: [],
                foodPlanIDs: [],
                measurementIDs: [],
                progressAlbumIDs: [])
    }
    
    
    static func createMockClient(categoryIDs : [String], accountID: String, profileID: String) -> Client {
        let firstNames = ["John", "Jane", "Michael", "Mary", "James", "Emily", "David", "Emma", "Robert", "Olivia"]
        let lastNames = ["Smith", "Johnson", "Brown", "Williams", "Jones", "Miller", "Davis", "Garcia", "Taylor", "Martinez"]

        let randomFirstName = firstNames.randomElement()!
        let randomLastName = lastNames.randomElement()!
        let randomEmail = "\(randomFirstName.lowercased()).\(randomLastName.lowercased())@gmail.com"
        let randomPhoneNumber = String(format: "%03d-%03d-%04d", Int.random(in: 100...999), Int.random(in: 100...999), Int.random(in: 1000...9999))
        let randomAge = Int.random(in: 18...65)
        let randomWeight = Int.random(in: 100...250)
        let randomHeight = Int.random(in: 150...200)

        return Client(
            categoryIDs: categoryIDs,
            dateOfCreation: Date.now,
            accountID: accountID,
            profileID: profileID,

            firstName: randomFirstName,
            lastName: randomLastName,

            email: randomEmail,
            phone: randomPhoneNumber,

            age: String(randomAge),
            weight: String(randomWeight),
            height: String(randomHeight),

            active: Bool.random(),
            trainingStyle: TrainingStyle.allCases.randomElement()!,
            injury: "None",
            healthIssues: "None",
            paymentType: PaymentType.allCases.randomElement()!,

            phases: [],
            mezocycles: [],
            foodPlanIDs: [],
            measurementIDs: [],
            progressAlbumIDs: []
        )
    }
}
