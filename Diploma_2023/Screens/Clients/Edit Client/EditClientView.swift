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
    
}
        
        
        
// MARK: - EditClient - View

    struct EditClientView: View {
        
        @Environment(\.presentationMode) var presentationMode
        
        @ObservedObject var parentVm: ClientDetailViewModel

        
        init(parentVm: ClientDetailViewModel) {
            self.parentVm = parentVm
        }
        

        
        var body: some View {
            
                
                Form {
                    
                    
                    Section(header: Text("Contact Information")) {
                        TextField("First Name", text: $parentVm.selectedClient.firstName)
                        TextField("Last Name", text: $parentVm.selectedClient.lastName)
                        TextField("Email", text: $parentVm.selectedClient.email)
                            .keyboardType(.emailAddress)
                        TextField("Phone Number", text: $parentVm.selectedClient.phone)
                            .keyboardType(.numberPad)
                            .onReceive(Just(parentVm.selectedClient.phone)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    parentVm.selectedClient.phone = filtered
                                }
                            }
                    }
                    
                    Section(header: Text("Health Information")) {
                        TextField("Age", text: $parentVm.selectedClient.age)
                            .keyboardType(.numberPad)
                        TextField("Weight", text: $parentVm.selectedClient.weight)
                            .keyboardType(.numberPad)
                        TextField("Height", text: $parentVm.selectedClient.height)
                            .keyboardType(.numberPad)
                        TextField("Injury", text: $parentVm.selectedClient.injury)
                        TextField("Health Issues", text: $parentVm.selectedClient.healthIssues)
                    }
                    
                    Section(header: Text("Additional Information")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Active", isOn: $parentVm.selectedClient.active)
                            Text("Active user is the one that will be training in the near future")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Picker("Training Style", selection: $parentVm.selectedClient.trainingStyle) {
                            ForEach(TrainingStyle.allCases, id: \.id) { style in
                                Text(style.rawValue)
                                    .tag(style)
                            }
                        }
                    }
                    
                    Section(header: Text("Other Information")) {
                        Picker("Payment Type", selection: $parentVm.selectedClient.paymentType) {
                            ForEach(PaymentType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                    
                    
                }
                //            .navigationBarTitle("New Client", displayMode: .inline)
                //            .navigationBarItems(leading: Button("Cancel") {
                //                isShowingForm = false
                //            }, trailing: Button("Save") {
                //                // parentVm uploads client to DB and updates allClients list
                //                parentVm.createClient(client: vm.getNewClient())
                //                isShowingForm = false
                //            })
                //        }
                
                
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
                        parentVm.updateClient()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                )
                
            }
    }

