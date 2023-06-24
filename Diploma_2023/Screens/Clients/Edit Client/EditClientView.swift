//
//  EditClientView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import SwiftUI
import Combine

// MARK: - EditClient - ViewModel
class EditClientViewModel: ObservableObject {
    
    
    @Published var editClient: Client

    init(selectedClient: Client){
        // duplicate selectedClient
        self.editClient = selectedClient
    }
    
    
}
        
        
        
// MARK: - EditClient - View

    struct EditClientView: View {
        
        @Environment(\.presentationMode) var presentationMode
        
        @ObservedObject var parentVm: ClientDetailViewModel
        @ObservedObject var vm: EditClientViewModel

        
        init(parentVm: ClientDetailViewModel) {
            self.parentVm = parentVm
            self.vm = EditClientViewModel(selectedClient: parentVm.selectedClient)
        }
        
        
        var body: some View {
            
                
                Form {
                    
                    
                    Section(header: Text("Contact Information")) {
                        TextField("First Name", text: $vm.editClient.firstName)
                        TextField("Last Name", text: $vm.editClient.lastName)
                        TextField("Email", text: $vm.editClient.email)
                            .keyboardType(.emailAddress)
                        TextField("Phone Number", text: $vm.editClient.phone)
                            .keyboardType(.numberPad)
                            .onReceive(Just(vm.editClient.phone)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    vm.editClient.phone = filtered
                                }
                            }
                    }
                    
                    Section(header: Text("Health Information")) {
                        TextField("Age", text: $vm.editClient.age)
                            .keyboardType(.numberPad)
                        TextField("Weight", text: $vm.editClient.weight)
                            .keyboardType(.numberPad)
                        TextField("Height", text: $vm.editClient.height)
                            .keyboardType(.numberPad)
                        TextField("Injury", text: $vm.editClient.injury)
                        TextField("Health Issues", text: $vm.editClient.healthIssues)
                    }
                    
                    Section(header: Text("Additional Information")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Active", isOn: $vm.editClient.active)
                            Text("Active user is the one that will be training in the near future")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Picker("Training Style", selection: $vm.editClient.trainingStyle) {
                            ForEach(TrainingStyle.allCases, id: \.id) { style in
                                Text(style.rawValue)
                                    .tag(style)
                            }
                        }
                    }
                    
                    Section(header: Text("Other Information")) {
                        Picker("Payment Type", selection: $vm.editClient.paymentType) {
                            ForEach(PaymentType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                    
                    
                }

                .navigationBarTitle(Text("Edit Client"))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        print("cancel")
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        // Save the changes and dismiss the view
                        parentVm.updateClient(editClient: vm.editClient)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                )
                
            }
    }

