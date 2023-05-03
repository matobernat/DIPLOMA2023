//
//  ClientsViewModel.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 10/03/2023.
//

import Combine
import SwiftUI



// MARK: - Clients - ViewModel

class ClientsViewModel: ObservableObject {
    
    let title = "Clients"
    
    
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published  var selectedCategory: Category?
    
    
    private let clientsDataStore: ClientsDataStore
    @Published private(set) var clients: [Client] = []
    @Published  var selectedClient: Client?
    
    
    private let accountDataStore: AccountDataStore
    @Published  var loggedAccount: Account?
    
    @Published  var searchText: String = ""
    @Published  var isShowingForm = false
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        
        self.clientsDataStore = AppDependencyContainer.shared.clientsDataStore
        self.clients = clientsDataStore.allClients
        

        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        self.categories = categoryDataStore.categoriesClients
        
        self.accountDataStore = AppDependencyContainer.shared.accountDataStore
        self.loggedAccount = accountDataStore.loggedAccount
        
        
        // Subscribe to changes in allClients
        clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
        }
        .store(in: &cancellables)

        
        // Subscribe to changes in categories
        categoryDataStore.$categoriesClients.sink { [weak self] newCategories in
            self?.categories = newCategories
        }
        .store(in: &cancellables)
        
        // Subscribe to changes in Account
        accountDataStore.$loggedAccount.sink { [weak self] newAccount in
            self?.loggedAccount = newAccount
        }
        .store(in: &cancellables)
    }
    
    
    func createClient(client: Client){
        clientsDataStore.createClient(client) { result in
            // handle error
        }
    }
    
    //TODO: in the future..
    func addCategory(){
        
    }
        
    // ... other methods
}

