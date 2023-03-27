//
//  SideBarCategoryList.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI

struct SideBar: View {
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
        SideBar(categories: DataModelMock.categories, title: "Clients", section: DataType.client, selectedCategory: Binding.constant(DataModelMock.categories.first!))
    }
}
