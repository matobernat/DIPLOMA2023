//
//  ClientsView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI
import Combine

// MARK: - Clients - View
struct ClientsView: View {
    

    let title = "Clients"
    
    @StateObject private var vm = ClientsViewModel()


    
    var body: some View {
        NavigationSplitView {
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
                .accessibilityIdentifier("SideBar")

        }
    detail: {
            NavigationStack{
                ScrollView{ // might create performance issues
                    Divider()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(selectedClients(allClients: vm.clients)) { client in
                            NavigationLink(
                                destination: ClientDetailView(
                                    item: client).environmentObject(self.vm),
                                tag: client,
                                selection: $vm.selectedClient) {
                                ClientSmallCardView(client: client)
                                        

                            }
                        }
                    }
                    .accessibilityIdentifier("LazyVGrid")
                    .searchable(text: $vm.searchText)
                    .padding()
                }
            }
            .navigationTitle(vm.selectedCategory?.name ?? "Select a Category")
            

            .navigationBarItems(trailing: Button(action: {
                // Add your action here
                vm.isShowingForm = true
            }, label: {
                HStack{
                    Image(systemName: "plus")
                    Text("New Client")
                }
            }))
            .accessibilityIdentifier("NewClientButton")
            .sheet(isPresented: $vm.isShowingForm) {
                NewClientView(parentVm: vm)
            }
        
        
        
        }
        .onAppear {
            vm.selectedCategory = vm.categories.first
        }
    }
    
    func selectedClients(allClients:[Client]) -> [Client] {
        if let selectedCategory = vm.selectedCategory {
            if vm.searchText.isEmpty {
                return allClients.filter { $0.categoryIDs.contains(selectedCategory.id) }
            } else {

                let filteredClients = allClients
                    .filter { $0.categoryIDs.contains(selectedCategory.id) }
                    .filter { $0.title.localizedCaseInsensitiveContains(vm.searchText) }

                return filteredClients
            }
        } else {
            return []
        }
    }
    
}


struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView()
    }
}
