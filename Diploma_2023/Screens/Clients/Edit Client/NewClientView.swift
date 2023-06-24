//
//  NewClientView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/04/2023.
//

import SwiftUI
import Combine

// MARK: - NewClient - ViewModel
class NewClientViewModel: ObservableObject {
    
    // passed data from parent VM to set new Client
    var selectedCategory: Category
    var loggedAccount: Account
    let categoryDataStore: CategoryDataStore
    
    @Published var newClient: Client

    
    init(selectedCategory: Category, loggedAccount: Account){
        self.loggedAccount = loggedAccount
        self.selectedCategory = selectedCategory
        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        
        // Create Empty Client
        let categories = categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory)
        self.newClient = Client.getNewClient(categoryIDs: categories, accountID: loggedAccount.id, profileID: loggedAccount.loggedProfile?.id ?? "")
    }
    
    
    
    // This function updates necessary properties before uploading to ClientDataStore
    func getNewClient() -> Client {
        self.newClient.injury = self.newClient.injury == "" ? "None" : self.newClient.injury
        self.newClient.healthIssues = self.newClient.healthIssues == "" ? "None" : self.newClient.healthIssues
        return self.newClient
    }
    
    
    
    func createMockClient() -> Client {
        let categories = categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory)
        return Client.createMockClient(categoryIDs: categories, accountID: loggedAccount.id, profileID: loggedAccount.loggedProfile?.id ?? "")
    }
    

}


// MARK: - NewClient - View
struct NewClientView: View {
    @ObservedObject private var parentVm: ClientsViewModel
    @ObservedObject private var vm: NewClientViewModel

    
    init( parentVm: ClientsViewModel) {
        self.parentVm = parentVm
        self.vm = NewClientViewModel(selectedCategory: parentVm.selectedCategory!,
                                     loggedAccount: parentVm.loggedAccount!)
        
    }


    var body: some View {
        NavigationView {
            
            Form {
                
                Button("Create mocked Client") {

                    // parentVm uploads client to DB and updates allClients list
                    parentVm.createClient(client: vm.createMockClient())
                    parentVm.isShowingForm = false
                    
                }
                
                
                Section(header: Text("Contact Information")) {
                    TextField("First Name", text: $vm.newClient.firstName)
                    TextField("Last Name", text: $vm.newClient.lastName)
                    TextField("Email", text: $vm.newClient.email)
                        .keyboardType(.emailAddress)
                    TextField("Phone Number", text: $vm.newClient.phone)
                        .keyboardType(.numberPad)
                        .onReceive(Just(vm.newClient.phone)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                vm.newClient.phone = filtered
                            }
                        }
                }
                
                Section(header: Text("Health Information")) {
                    TextField("Age", text: $vm.newClient.age)
                        .keyboardType(.numberPad)
                    TextField("Weight", text: $vm.newClient.weight)
                        .keyboardType(.numberPad)
                    TextField("Height", text: $vm.newClient.height)
                        .keyboardType(.numberPad)
                    TextField("Injury", text: $vm.newClient.injury)
                    TextField("Health Issues", text: $vm.newClient.healthIssues)
                }
                
                Section(header: Text("Additional Information")) {
                    // Toggle Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Active", isOn: $vm.newClient.active)
                        Text("Active user is the one that will be training in the near future")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Picker("Training Style", selection: $vm.newClient.trainingStyle) {
                        ForEach(TrainingStyle.allCases, id: \.id) { style in
                            Text(style.rawValue)
                                .tag(style)
                        }
                    }
                }

                Section(header: Text("Other Information")) {
                    Picker("Payment Type", selection: $vm.newClient.paymentType) {
                        ForEach(PaymentType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                
            }
            .navigationBarTitle("New Client", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                parentVm.isShowingForm = false
            }, trailing: Button("Save") {
                // parentVm uploads client to DB and updates allClients list
                parentVm.createClient(client: vm.getNewClient())
                parentVm.isShowingForm = false
            })
        }
    }
}

struct NewClientView_Previews: PreviewProvider {
    static var previews: some View {
        NewClientView(parentVm: ClientsViewModel())
    }
}
