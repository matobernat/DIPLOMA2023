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
    var categories: [Category]
    var selectedCategory: Category
    var loggedAccount: Account
    
    @Published var newClient: Client

    
    init(categories: [Category], selectedCategory: Category, loggedAccount: Account){
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.loggedAccount = loggedAccount
        
        self.newClient = Client(
            categoryIDs: [],
            dateOfCreation: .now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.loggedProfile?.id ?? "",
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
    
    // This function updates necessary properties before uploading to ClientDataStore
    func getNewClient() -> Client {
        self.newClient.categoryIDs = self.getCategoryIDs()
        self.newClient.injury = self.newClient.injury == "" ? "None" : self.newClient.injury
        self.newClient.healthIssues = self.newClient.healthIssues == "" ? "None" : self.newClient.healthIssues
        self.newClient.dateOfCreation = Date.now
        
        return self.newClient
    }
    
    func getCategoryIDs() -> [String]{
        var IDs=[String]()
//        self.selectedCategory.id
        
        for category in self.categories {
            
            // if archived, add only to archived
            if self.selectedCategory.name.contains("Archived"){
                if category.name.contains("Archived"){
                    IDs.append(category.id)
                }
                continue
            }
                
                
            // This is the default rule
            if category.name.contains("All") ||
                category.name.contains("Recent") ||
                category.name.contains("My") {
                
                IDs.append(category.id)
            }
            
            // Favorites is optional
            if self.selectedCategory.name.contains("Favorite"){
                if category.name.contains("Favorite"){
                    IDs.append(category.id)
                }
            }
            
        }
        return IDs
    }


    func createMockClient() -> Client {
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
            categoryIDs: self.getCategoryIDs(),
            dateOfCreation: Date.now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.loggedProfile?.id ?? "",

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


// MARK: - NewClient - View
struct NewClientView: View {
    @ObservedObject private var parentVm: ClientsViewModel
    @ObservedObject private var vm: NewClientViewModel

    
    init( parentVm: ClientsViewModel) {
        self.parentVm = parentVm
        self.vm = NewClientViewModel(categories: parentVm.categories,
                                     selectedCategory: parentVm.selectedCategory!,
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
