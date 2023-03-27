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
