//
//  SearchBar.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
    
        
        HStack {
            // Search bar
            TextField("Search", text: $searchText)
                .accentColor(Color(.systemGray3))
                .padding(.vertical, 9)
                .padding(.horizontal, 28)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.systemGray3))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }
                )
//            Spacer()
        }
    }
}


func selectedItemsSearch<T: IdentifiableItem>(allItems: [T], selectedCategory: CategoryMock?, searchText: String, filterCondition: ((T) -> Bool)? = nil) -> [T] {
    if let selectedCategory = selectedCategory {
        if searchText.isEmpty {
            return []
        } else {
            let filteredItems = allItems
                .filter { selectedCategory.itemIDs.contains($0.id) }
                .filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.subTitle.localizedCaseInsensitiveContains(searchText) }

            if let filterCondition = filterCondition {
                return filteredItems.filter { filterCondition($0) }
            } else {
                return filteredItems
            }
        }
    } else {
        return []
    }
}

func selectedItemsByCategoryMock<T: IdentifiableItem>(allItems: [T], selectedCategory: CategoryMock?) -> [T] {
    if let selectedCategory = selectedCategory {
        let filteredItems = allItems
            .filter { selectedCategory.itemIDs.contains($0.id) }
        return filteredItems
    }
    
    return []
}
func selectedItemsByCategory<T: IdentifiableItem>(allItems: [T], selectedCategory: Category?) -> [T] {
    if let selectedCategory = selectedCategory {
        let filteredItems = allItems
            .filter { $0.categoryIDs.contains(selectedCategory.id) }
        return filteredItems
    }
    
    return []
}

func selectedItemsByClient<T: IdentifiableItem>(allItems: [T], selectedClient: ClientMock?, dataType: DataType) -> [T] {
    switch dataType {
        
    case .foodPlan:
        let filteredItems = allItems.filter { selectedClient?.foodPlanIDs.contains($0.id) ?? false }
        return filteredItems
        
    case .trainingPlan:
        let filteredItems = allItems.filter { selectedClient?.phaseIDs.contains($0.id) ?? false || selectedClient?.mezocycleIDs.contains($0.id) ?? false }
        return filteredItems
        
    case .mezocycle:
        let filteredItems = allItems.filter { selectedClient?.mezocycleIDs.contains($0.id) ?? false }
        return filteredItems
        
    case .phase:
        let filteredItems = allItems.filter { selectedClient?.phaseIDs.contains($0.id) ?? false }
        return filteredItems
        
    case .measurement:
        let filteredItems = allItems.filter { selectedClient?.measurementIDs.contains($0.id) ?? false }
        return filteredItems
        
    case .progressAlbum:
        let filteredItems = allItems.filter { selectedClient?.progressAlbumIDs.contains($0.id) ?? false }
        return filteredItems
        
    default:
        fatalError("Invalid data type: \(dataType)")
    }
}


//let filteredItems = selectedItems(allItems: allItems, selectedCategory: selectedCategory, searchText: searchText) { item in
//    item.name.localizedCaseInsensitiveContains(searchText) || item.description.localizedCaseInsensitiveContains(searchText)
//}
//
//let filteredItems2 = selectedItems(allItems: allItems2, selectedCategory: selectedCategory2, searchText: searchText) { item in
//    item.title.localizedCaseInsensitiveContains(searchText) || item.subtitle.localizedCaseInsensitiveContains(searchText)
//}



struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: Binding.constant(""))
    }
}
