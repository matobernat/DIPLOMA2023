//
//  MeasurementsView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI


struct MeasurementsView: View {
    
    let categories: [CategoryMock] = DataModelMock.categories
    let measurements: [MeasurementMock] = DataModelMock.measurements
    let title = "Measurements"
    
    @State  var selectedCategory: CategoryMock?
    @State private var selectedItem: MeasurementMock?
    @State private var searchText: String = ""
    
    
    
    var body: some View {
        NavigationSplitView {
            SideBar(categories: categories, title: "Measurements", section: DataType.measurement, selectedCategory: $selectedCategory)
        } detail: {
            NavigationStack{
                
                SearchBar(searchText: $searchText)
                
                if !searchText.isEmpty {
                    MeasurementsViewDetailSearch(
                        categories: categories,
                        measurements: measurements,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText
                    )
                } else {
                    MeasurementsViewDetail(
                        categories: categories,
                        measurements: measurements,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText)
                }
            }
            .navigationTitle(selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = categories.firstIndex{$0.section == .measurement}
            if let index = index {
                selectedCategory = categories[index]
            }
            
        }
    }
}

struct MeasurementsViewDetail: View{
    
    let categories: [CategoryMock]
    let measurements: [MeasurementMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
        ScrollView{ // might create performance issues
            
            GeneralHorizontalListView(
                title: "Measurements",
                items: selectedItemsByCategory(
                    allItems: measurements,
                    selectedCategory: selectedCategory),
                titleSize: .medium,
                sizeModel: .medium,
                dataType: .measurement)
        }
        
    }
}
    
struct MeasurementsViewDetailSearch: View{
    
    let categories: [CategoryMock]
    let measurements: [MeasurementMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearch(
                allItems: measurements,
                selectedCategory: selectedCategory,
                searchText: searchText),
            title: "Measurements",
            dataType: .measurement,
            sizeModel: SizeModel.medium
        )        
    }
}
        
struct MeasurementsView_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementsView()
    }
}
