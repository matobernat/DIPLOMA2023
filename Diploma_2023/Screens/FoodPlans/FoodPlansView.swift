//
//  FoodPlansView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct FoodPlansView: View {
    let categories: [CategoryMock] = DataModelMock.categories
    let foodProtocols: [FoodPlanMock] = DataModelMock.foodPlans
    let title = "Food Protocols"
    
    @State  var selectedCategory: CategoryMock?
    @State private var selectedItem: FoodPlanMock?
    @State private var searchText: String = ""
    
    
    var body: some View {
        NavigationSplitView {
            MockSideBar(categories: categories, title: "Food Protocols", section: DataType.foodPlan, selectedCategory: $selectedCategory)
        } detail: {
            NavigationStack{
                
                SearchBar(searchText: $searchText)
                
                if !searchText.isEmpty {
                    FoodPlansViewDetailSearch(
                        categories: categories,
                        foodProtocols: foodProtocols,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText
                    )
                } else {
                    FoodPlansViewDetail(
                        categories: categories,
                        foodProtocols: foodProtocols,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText)
                }
            }
            .navigationTitle(selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = categories.firstIndex{$0.section == .foodPlan}
            if let index = index {
                selectedCategory = categories[index]
            }
            
        }
    }
}


struct FoodPlansViewDetail: View{
    
    let categories: [CategoryMock]
    let foodProtocols: [FoodPlanMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
            ScrollView{ // might create performance issues

                GeneralHorizontalListView(
                    title: "Food Protocols",
                    items: selectedItemsByCategoryMock(
                        allItems: foodProtocols,
                        selectedCategory: selectedCategory),
                    titleSize: .medium,
                    sizeModel: .medium,
                    dataType: .foodPlan)

            }
        
    }
    
}



struct FoodPlansViewDetailSearch: View{
    
    let categories: [CategoryMock]
    let foodProtocols: [FoodPlanMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearchMock(
                allItems: foodProtocols,
                selectedCategory: selectedCategory,
                searchText: searchText),
            title: nil,
            dataType: .foodPlan,
            sizeModel: SizeModelMock.medium
        )
        
    }
    
//    func selectedItems(allItems:[PhaseMock]) -> [PhaseMock] {
//        if let selectedCategory = selectedCategory {
//            if searchText.isEmpty {
//                return []
//            } else {
//
//                let filteredItems = allItems
//                    .filter { selectedCategory.itemIDs.contains($0.id) }
//                    .filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.subTitle.localizedCaseInsensitiveContains(searchText) }
//
//                return filteredItems
//            }
//        } else {
//            return []
//        }
//    }
    
}





struct FoodPlansView_Previews: PreviewProvider {
    static var previews: some View {
        FoodPlansView()
    }
}
