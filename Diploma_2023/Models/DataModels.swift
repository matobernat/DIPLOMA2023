//
//  DataModels.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 04/04/2023.
//

import SwiftUI


// MARK: - Supportive Structure functions



// MARK: - Supportive Structures

struct InfoRowItem: Identifiable{
    var id = UUID()
    var title: String
    var value: String
    var description: String
    
}




// MARK: - Main Data Models

struct Account: Identifiable, Hashable, Codable, Equatable {
    
    var id: String // fireBase UID
    var name: String?
    var email: String
    var address: String
    var loggedProfile: Profile?
    var profiles: [Profile]
    var dateOfCreation: Date

    // ... other properties
}


struct Profile: Codable, Equatable, Hashable {
    var id: String // fireBase UID
    var name: String
    var email: String?
    var dateOfCreation: Date

    // ... other properties
}


enum SizeModel: String {
    case large = "Large"
    case medium = "Medium"
    case small = "Small"
}


protocol DetailView: View {
    init(item: IdentifiableItem)
}

protocol CardView: View {
    init(item: IdentifiableItem)
}

protocol IdentifiableItem {
    var id: String { get }
    var dataType: DataType { get }
    var title: String { get }
    var subTitle: String { get }
    var categoryIDs: [String] { get }
    var placeholderName: String { get }
    var dateOfCreation: Date { get }
    var accountID: String { get }
    var clientID: String? { get }

}


enum DataType: String, Codable, CaseIterable {
    case client = "client"
    case exercise = "exercise"
    case trainingPlan = "trainingPlan" // this is section type (for category), not data type
    case mezocycle = "mezocycle"
    case phase = "phase"
    case foodPlan = "foodPlan"
    case measurement = "measurement"
    case progressAlbum = "progressAlbum"
}

enum VersionEnum: String, CaseIterable, Codable {
    case version1_0 = "1.0"
    case version1_1 = "1.1"
    case version1_2 = "1.2"
    case version1_3 = "1.3"
    case version2_0 = "2.0"
    case version2_1 = "2.1"
    case version2_2 = "2.2"
    case version2_3 = "2.3"
    case version3_0 = "3.0"
    case version3_1 = "3.1"
    case version3_2 = "3.2"
    case version3_3 = "3.3"
}


extension PaymentType: Identifiable {
  var id: Self { self }
}
enum PaymentType: String, Codable, CaseIterable, Equatable {
    case perSession = "Per session"
    case monthly = "Monthly"
    case oneTime = "One time purchase"
    case weekly = "Weekly"
}


extension TrainingStyle: Identifiable {
  var id: Self { self }
}
enum TrainingStyle: String, Codable, CaseIterable, Equatable  {
    case distant = "Distant"
    case inPerson = "In person"

}



struct Category: Identifiable, Hashable, Encodable, Decodable  {
    var id: String // fireBase UID
    var name: String
    var dataType: DataType // enum, clients, tranining plans, exercises
    var isGlobal: Bool // The type of the category (account level or profile level)
    var accountID: String // The associated account ID
    var dateOfCreation: Date
    var profileID: String? // The associated profile ID, if applicable
    var imageName: String
}

