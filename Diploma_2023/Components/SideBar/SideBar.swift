//
//  SideBar.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 26/04/2023.
//

import SwiftUI

struct SideBar: View {
    let categories: [Category]
    let title: String
    @Binding var selectedCategory: Category?

    
    var globalCategories: [Category] {
        categories.filter { $0.isGlobal }
    }

    var localCategories: [Category] {
        categories.filter { !$0.isGlobal }
    }
    
    
    var body: some View {
        
            List(selection: $selectedCategory){
                ForEach(globalCategories) { category in
                    NavigationLink(value: category) {
                        HStack {
                            Image(systemName: category.imageName ?? "folder.fill" )
                                .foregroundColor(category == selectedCategory ? .white : .accentColor)
                            // Use the accent color
                            Text(verbatim: category.name)
                        }
                    }
                }
                Section(header: Text("My Library")){
                    ForEach(localCategories) { category in
                        NavigationLink(value: category) {
                            HStack {
                                Image(systemName: category.imageName ?? "folder"  )
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

//struct SideBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBar()
//    }
//}
