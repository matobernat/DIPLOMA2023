//
//  SideBarCategoryList.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI

struct MockSideBar: View {
    let categories: [CategoryMock]
    let title: String
    let section: DataType
    @Binding var selectedCategory: CategoryMock?

    
    
    let symbols = ["folder.fill", "book.fill", "photo.fill", "film.fill"]
    var sectionCategories: [CategoryMock] {
        categories.filter { $0.section == section }
    }

    
    var body: some View {
            List(selection: $selectedCategory){
            ForEach(sectionCategories.filter { $0.isGlobal }) { category in
                NavigationLink(value: category) {
                    HStack {
                        Image(systemName: category.iconName )
                            .foregroundColor(category == selectedCategory ? .white : .accentColor) // Use the accent color
                        Text(verbatim: category.name)
                    }
                }
            }
                Section(header: Text("My Library")){
                    ForEach(sectionCategories.filter { !$0.isGlobal }) { category in
                        NavigationLink(value: category) {
                            HStack {
                                Image(systemName: category.iconName )
                                    .foregroundColor(category == selectedCategory ? .white : .accentColor) // Use the accent color
                                Text(verbatim: category.name)
                            }
                        }
                    }
                }
        }
                .navigationTitle(title)
    }
}

struct SideBarCategoryList_Previews: PreviewProvider {
    static var previews: some View {
        MockSideBar(categories: DataModelMock.categories, title: "Clients", section: DataType.client, selectedCategory: Binding.constant(DataModelMock.categories.first!))
    }
}






//struct CategoryList: View {
//    let categories: [Category]
//    @Binding var selectedCategory: Category?
//
//    // Add a variable for the SF Symbols
//    let symbols = ["folder.fill", "book.fill", "photo.fill", "film.fill"]
//
//    var body: some View {
//        List(selection: $selectedCategory) {
//            ForEach(categories.filter { $0.isGlobalCategory }) { category in
//                NavigationLink(value: category) {
//                    categoryRow(category: category)
//                }
//
//            }
//
//            Section(header: Text("My Library")) {
//                ForEach(categories.filter { !$0.isGlobalCategory }) { category in
//                    NavigationLink(value: category) {
//                        categoryRow(category: category)
//                    }
//                }
//            }
//        }
////        .listStyle(SidebarListStyle())
//
//    }
//
//
//    private func categoryRow(category: Category) -> some View {
//        HStack {
//            Image(systemName: symbols[categories.firstIndex(where: { $0.id == category.id }) ?? 0])
//                .foregroundColor(category == selectedCategory ? .white : .accentColor) // Use the accent color
//            Text(verbatim: category.name)
//        }
//    }
//}
