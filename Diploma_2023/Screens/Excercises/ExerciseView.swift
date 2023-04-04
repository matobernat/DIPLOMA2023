//
//  ExerciseView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct ExerciseView: View {
    let items: [ExerciseMock] = DataModelMock.exercises
    let categories: [CategoryMock] = DataModelMock.categories
    let mainTitle: String = "Exercise"
    
    @State private var searchText: String = ""
    @State var selectedCategory: CategoryMock? = nil
    @State var selectedItem: ExerciseMock? = nil
    
    
    var body: some View {
        NavigationSplitView{
//            CategoryList(categories: categories,
//                         selectedCategory: $selectedCategory)
//                .navigationTitle(mainTitle)
            SideBar(categories: categories, title: "Exercises", section: .exercise, selectedCategory: $selectedCategory)
        } content: {
            if let category = selectedCategory{
            
                ItemsList(
                    selectedItems: selectedItemsByCategory(
                        allItems: items,
                        selectedCategory: category),
                    selectedCategory: selectedCategory,
                    selectedItem: $selectedItem,
                    searchText: $searchText)
                    .navigationTitle(selectedCategory?.name ?? "")
                    .searchable(text: $searchText)  
            } else {
                Text("Select a category")
            }

                
        } detail: {
            if let item = selectedItem {
                    ExerciseDetailView()
                    .navigationTitle(item.title)
            } else {
                Text("No item selected")
            }
        }

        .onAppear {
            let index = categories.firstIndex{$0.section == .exercise}
            if let index = index {
                selectedCategory = categories[index]
            }
            if selectedItem == nil {
                selectedItem = items.filter { selectedCategory?.itemIDs.contains($0.id) ?? false }.first
            }
        }

    }
    
    
    
//    func selectedItems(allItems:[ExerciseMock]) -> [ExerciseMock] {
//        if let selectedCategory = selectedCategory {
//            if searchText.isEmpty {
//                return allItems.filter {selectedCategory.itemIDs.contains($0.id)}
//            } else {
//                let filteredClients = allItems
//                    .filter { selectedCategory.itemIDs.contains($0.id) }
//                    .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
//                return filteredClients
//            }
//        } else {
//            return []
//        }
//    }
    
}





struct ItemsList: View {
    let selectedItems: [ExerciseMock]
    let selectedCategory: CategoryMock?
    @Binding var selectedItem: ExerciseMock?
    @Binding var searchText: String


    var body: some View {
            List(selectedItems, id: \.id, selection: $selectedItem) { item in
                NavigationLink(value: item) {
                    itemRow(item: item)
                }
            }
//            ScrollView(.horizontal) {
//                HStack{
//                    ForEach(items, id: \.id) { item in
//                        NavigationLink(destination: ItemDetailView(item: item)) {
//                            ItemCard(item: item)
//                        }
//                    }
//                }
//            }.padding(.leading, 16)
        }
    
    private func itemRow(item: IdentifiableItemMock) -> some View {
        HStack {
            Text(verbatim: item.title)
        }
    }
    
}



struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
