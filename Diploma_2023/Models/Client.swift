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


