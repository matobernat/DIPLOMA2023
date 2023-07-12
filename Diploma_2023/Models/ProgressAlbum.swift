//
//  ProgressAlbum.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 03/07/2023.
//

import Foundation


struct ProgressAlbum: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable   {
    
    
    var title: String
    var dataType = DataType.progressAlbum
    var subTitle: String
    var categoryIDs: [String]
    var placeholderName = ProgressAlbum.Constants.placeholderImageName

    
    var id = UUID().uuidString
    var accountID: String
    var clientID: String?
    var profileID: String
    var dateOfCreation: Date
    var dateLastModification: Date
    var progressPhotos: [ProgressPhoto]
    
    var thumbnailUrl: String {
        progressPhotos.first?.imageUrl ?? ProgressAlbum.Constants.placeholderImageName
    }
    
    // static constants
    struct Constants {
        static let placeholderImageName = "ProgressAlbumPlaceholder"
    }
}


struct ProgressPhoto: Identifiable, Hashable, Encodable, Decodable   {
    var id = UUID().uuidString
    var imageUrl: String
    var dateOfCreation: Date = .now
}




// static factory methods
extension ProgressAlbum{
    
    
    static func getNewAlbum(accountID: String,
                            profileID: String,
                            clientID: String,
                            title: String = "New Client's album",
                            subtitle: String = "New Progress Album") -> ProgressAlbum {
        return ProgressAlbum(
            title: title,
            subTitle: subtitle,
            categoryIDs: [],
            accountID: accountID,
            clientID: clientID,
            profileID: profileID,
            dateOfCreation: .now,
            dateLastModification: .now,
            progressPhotos: []
            
        )
    }
    
    static func getNewAlbum(selectedClient: Client, categoryIDs: [String]) -> ProgressAlbum {
        return ProgressAlbum(
            title: "\(selectedClient.title)'s album",
            subTitle: "New Progress Album",
            categoryIDs: categoryIDs,
            accountID: selectedClient.accountID,
            clientID: selectedClient.id,
            profileID: selectedClient.profileID,
            dateOfCreation: .now,
            dateLastModification: .now,
            progressPhotos: []
            
        )
    }
    

    static func createMockAlbum() -> ProgressAlbum {
        let firstNames = ["John", "Jane", "Michael", "Mary", "James", "Emily", "David", "Emma", "Robert", "Olivia"]
        let lastNames = ["Smith", "Johnson", "Brown", "Williams", "Jones", "Miller", "Davis", "Garcia", "Taylor", "Martinez"]
        
        let randomFirstName = firstNames.randomElement()!
        let randomLastName = lastNames.randomElement()!
        let clientName = "\(randomFirstName) \(randomLastName)"

        return ProgressAlbum(
            title: clientName,
            subTitle: "Mock Progress Album",
            categoryIDs: [],
            id: UUID().uuidString,
            accountID: "mockaccountID",
            clientID: "mockclientId",
            profileID: "mockprofileID",

            dateOfCreation: .now,
            dateLastModification: .now,
            progressPhotos: []
        )
    }

}
