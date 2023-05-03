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
        }
    detail: {
            NavigationStack{
                ScrollView{ // might create performance issues
                    Divider()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(selectedClients(allClients: vm.clients)) { client in
                            NavigationLink(
                                destination: ClientDetailView(
                                    item: client),
                                tag: client,
                                selection: $vm.selectedClient) {
                                SmallCardView(item: client)
                            }
                        }
                    }
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




//MockClientDetail

//NavigationStack{
//    ScrollView{ // might create performance issues
//        Divider()
//        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
//            ForEach(selectedClients(allClients: clients)) { client in
//                NavigationLink(
//                    destination: ClientDetailView(
//                        item: client),
//                    tag: client,
//                    selection: $selectedClient) {
//                    SmallCardView(item: client)
//                }
//            }
//        }
//        .searchable(text: $searchText)
//        .padding()
//    }
//}
//.navigationTitle(selectedCategory?.name ?? "Select a category")
//.navigationBarItems(trailing: Button(action: {
//    // Add your action here
//    isShowingForm = true
//}, label: {
//    HStack{
//        Image(systemName: "plus")
//        Text("New Client")
//    }
//}))
//.sheet(isPresented: $isShowingForm) {
//    NewClientView(isShowingForm: $isShowingForm, parentVm: vm)
//}







//struct ClientCardView: View {
//    let client: ClientMock
//
//    var body: some View {
//        HStack {
//            ZStack{
//                RoundedRectangle(cornerRadius: 60)
//                    .fill(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
//                    .frame(width: 60, height: 60)
//
//                Image(client.photoName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 60, height: 60)
//                    .clipShape(Circle())
//            }
//
//            VStack(alignment: .leading) {
//                Text(client.title).font(.headline)
//                Text(client.subTitle).font(.subheadline)
//            }
//            Spacer()
//        }
//    }
//}


struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView()
    }
}
