//
//  ClientsView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct ClientsView: View {

    let categories: [CategoryMock] = DataModelMock.categories
    let clients: [ClientMock] = DataModelMock.clients
    let title = "Clients"

    @State  var selectedCategory: CategoryMock?
    @State private var selectedClient: ClientMock?
    @State private var searchText: String = ""


    
    var body: some View {
        NavigationSplitView {
            SideBar(categories: categories, title: title, section: DataType.client, selectedCategory: $selectedCategory)
        }
    detail: {
            NavigationStack{
                ScrollView{ // might create performance issues
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(selectedClients(allClients: clients)) { client in
                            NavigationLink(destination: ClientDetailView(client: client), tag: client, selection: $selectedClient) {
                                ClientCardView(client: client)
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .padding()
                }
            }
            .navigationTitle(selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            selectedCategory = categories.first
        }
    }
    
    func selectedClients(allClients:[ClientMock]) -> [ClientMock] {
        if let selectedCategory = selectedCategory {
            if searchText.isEmpty {
                return allClients.filter {selectedCategory.itemIDs.contains($0.id)}
            } else {

                let filteredClients = allClients
                    .filter { selectedCategory.itemIDs.contains($0.id) }
                    .filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                return filteredClients
            }
        } else {
            return []
        }
    }
    
}

struct ClientCardView: View {
    let client: ClientMock
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                    .frame(width: 60, height: 60)
                
                Image(client.photoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(client.title).font(.headline)
                Text(client.subTitle).font(.subheadline)
            }
            Spacer()
        }
    }
}



struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView()
    }
}
