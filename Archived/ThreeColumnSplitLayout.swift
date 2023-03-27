//
//  ThreeColumnSplitLayout.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 14/03/2023.
//

import SwiftUI


struct ThreeColumnSplitLayout: View {
    let items: [Item]
    let categories: [Category]
    let mainTitle: String
    @State private var searchText: String = ""

    
    @State var selectedCategory: Category? = nil
    @State var selectedItem: Item? = nil
    
    
    var body: some View {
        NavigationView {
            CategoryList(categories: categories, selectedCategory: $selectedCategory, selectedTrainee: $selectedItem)
                .navigationTitle(mainTitle)

            
            ItemsList(items: items, selectedCategory: selectedCategory, selectedItem: $selectedItem, searchText: $searchText)
                .navigationTitle(selectedCategory?.name ?? "")

            
            if let item = selectedItem {
//                Text(item.name)
                    ClientDetailView()
                    .navigationTitle(item.name)
            } else {
                Text("No item selected")
            }
        }
        .toolbar(.visible) // Show the navigation bar by default
        .navigationBarHidden(false) // Show the navigation bar by default

        .onAppear {
            selectedCategory = categories.first
            selectedItem = items.filter { selectedCategory?.itemIds.contains($0.id) ?? false }.first
        }

    }
}





struct CategoryList: View {
    let categories: [Category]
    @Binding var selectedCategory: Category?
    @Binding var selectedTrainee: Item?
    
    // Add a variable for the SF Symbols
    let symbols = ["folder.fill", "book.fill", "photo.fill", "film.fill"]
    
    var body: some View {
        List(selection: $selectedCategory) {
            ForEach(categories.filter { $0.isGlobalCategory }) { category in
                categoryRow(category: category)

            }
            
            Section(header: Text("My Library")) {
                ForEach(categories.filter { !$0.isGlobalCategory }) { category in
                    categoryRow(category: category)
                }
            }
        }
        .listStyle(SidebarListStyle())

    }
    
    
    private func categoryRow(category: Category) -> some View {
        Button(action: {
            selectedCategory = category
            selectedTrainee = nil
        }) {
            HStack {
                Image(systemName: symbols[categories.firstIndex(where: { $0.id == category.id }) ?? 0])
                    .foregroundColor(category == selectedCategory ? .white : .accentColor) // Use the accent color
                Text(category.name)
                    .foregroundColor(category == selectedCategory ? .white : .primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Align the text to the left
                    .contentShape(Rectangle()) // Set the content shape
                Spacer()
            }
            .padding(.leading, 8)
            .background(category == selectedCategory ? Color.blue : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ItemsList: View {
    let items: [Item]
    let selectedCategory: Category?
    @Binding var selectedItem: Item?
    @Binding var searchText: String

    
    var itemsForSelectedCategory: [Item] {
        guard let category = selectedCategory else { return [] }
        return items.filter { category.itemIds.contains($0.id) }
    }
    
    var body: some View {
            List(itemsForSelectedCategory, id: \.id, selection: $selectedItem) { item in
                itemRow(item: item)
            }
        }
    
    private func itemRow(item: Item) -> some View {
        Button(action: {
            selectedItem = item
        }) {
            HStack {
                Text(item.name)
                    .foregroundColor(item == selectedItem ? .white : .primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Align the text to the left
                    .contentShape(Rectangle()) // Set the content shape
                Spacer()
            }
            .padding(.leading, 8)
            .background(item == selectedItem ? Color.blue : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}




struct ThreeColumnSplitLayout_Previews: PreviewProvider {
    static var previews: some View {
        ThreeColumnSplitLayout(items: MockCategoryItemData.items, categories: MockCategoryItemData.categories, mainTitle: "Main Title")
    }
}
