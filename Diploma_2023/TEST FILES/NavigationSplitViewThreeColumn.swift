//
//  NavigationSplitViewThreeColumn.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 14/03/2023.
//

import SwiftUI

struct NavigationSplitViewThreeColumn: View {

    @State private var categoryId: Int?
    @State private var clientId: Int?


    
    var body: some View {
        NavigationSplitView {
                    List(mockClientModel.categories, selection: $categoryId) { category in
                        Text(category.name)
                    }
        } content: {
            if let category = mockClientModel.category(id: categoryId) {
                List(category.clients, selection: $clientId) { client in
                    Text(client.name)
                }
            } else {
                Text("Select a Category")
            }
        } detail: {
            Text("Client \(clientId ?? 999)")
        }
        .onChange(of: categoryId) { _ in
                    clientId = nil
                }
    }
}

struct NavigationSplitViewThreeColumn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitViewThreeColumn()
    }
}










    // LOCAL DATASET


struct NSVTCMockCategory: Decodable, Identifiable{
    let id: Int
    let name: String
    let isGlobalCategory: Bool
    let clients: [NSVTCMockClient]
}

struct NSVTCMockClient: Decodable, Identifiable{
    let id: Int
    let name: String
}


class NSVTCMockClientModel {
    let categories: [NSVTCMockCategory]

    init(){
        let client1 = NSVTCMockClient(id: 1, name: "John")
        let client2 = NSVTCMockClient(id: 2, name: "Mary")
        let client3 = NSVTCMockClient(id: 3, name: "Bob")
        let client4 = NSVTCMockClient(id: 4, name: "Alice")
        let client5 = NSVTCMockClient(id: 5, name: "Tom")
        let client6 = NSVTCMockClient(id: 6, name: "Jane")
        let client7 = NSVTCMockClient(id: 7, name: "Mike")
        let client8 = NSVTCMockClient(id: 8, name: "Lisa")

        let allClientsCategory = NSVTCMockCategory(id: 1, name: "All Clients", isGlobalCategory: true, clients: [client1, client2, client3, client4, client5, client6, client7, client8])
        let globalHockeyCategory = NSVTCMockCategory(id: 2, name: "Global Hockey", isGlobalCategory: true, clients: [client1, client2, client3, client4])
        let localMyClients = NSVTCMockCategory(id: 3, name: "Local My Clients", isGlobalCategory: false, clients: [client3, client4, client5, client6])
        let localHockeyCategory = NSVTCMockCategory(id: 4, name: "Local Hockey", isGlobalCategory: false, clients: [client3, client4])

        self.categories = [allClientsCategory, globalHockeyCategory, localMyClients, localHockeyCategory]
    }

    func category(id: Int?) -> NSVTCMockCategory? {
        if let id = id {
            return categories.first(where: { $0.id == id })
        } else {
            return nil
        }
    }
}

let mockClientModel = NSVTCMockClientModel()

