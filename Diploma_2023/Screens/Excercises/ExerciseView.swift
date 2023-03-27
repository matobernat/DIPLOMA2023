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
            if selectedCategory == nil {
                selectedCategory = categories.first
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




struct CategoryList: View {
    let categories: [Category]
    @Binding var selectedCategory: Category?

    // Add a variable for the SF Symbols
    let symbols = ["folder.fill", "book.fill", "photo.fill", "film.fill"]

    var body: some View {
        List(selection: $selectedCategory) {
            ForEach(categories.filter { $0.isGlobalCategory }) { category in
                NavigationLink(value: category) {
                    categoryRow(category: category)
                }

            }

            Section(header: Text("My Library")) {
                ForEach(categories.filter { !$0.isGlobalCategory }) { category in
                    NavigationLink(value: category) {
                        categoryRow(category: category)
                    }
                }
            }
        }
//        .listStyle(SidebarListStyle())

    }

    
    private func categoryRow(category: Category) -> some View {
        HStack {
            Image(systemName: symbols[categories.firstIndex(where: { $0.id == category.id }) ?? 0])
                .foregroundColor(category == selectedCategory ? .white : .accentColor) // Use the accent color
            Text(verbatim: category.name)
        }
    }
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
    
    private func itemRow(item: IdentifiableItem) -> some View {
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
