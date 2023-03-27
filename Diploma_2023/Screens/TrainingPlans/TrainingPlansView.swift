//
//  TrainingPlansView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
import SwiftUI


struct TrainingPlansView: View {
    let categories: [CategoryMock] = DataModelMock.categories
    let trainingPlans: [PhaseMock] = DataModelMock.trainingProtocols
    let mezocycles: [MezocycleMock] = DataModelMock.mezocycles
    let title = "Training Plans"
    
    @State  var  selectedType: DataType = DataType.mezocycle
    @State  var selectedCategory: CategoryMock?
    @State private var selectedItem: PhaseMock?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            SideBar(categories: categories, title: "Training Plans", section: DataType.trainingPlan, selectedCategory: $selectedCategory)
        } detail: {
            NavigationStack{
                SearchBar(searchText: $searchText)
                
                if !searchText.isEmpty {
                    TrainingPlansViewDetailSearch(
                        categories: categories,
                        trainingPlans: trainingPlans,
                        mezocycles: mezocycles,
                        selectedType: $selectedType,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText
                    )
                } else {
                    TrainingPlansViewDetail(
                        categories: categories,
                        trainingProtocols: trainingPlans,
                        mezocycles: mezocycles,
                        selectedItem: $selectedItem,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText,
                        selectedType: $selectedType
                        
                    )
                }
                
            }
            .navigationTitle(selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = categories.firstIndex{$0.section == .trainingPlan}
            if let index = index {
                selectedCategory = categories[index]
            }
            
        }

    }
}



struct TrainingPlansViewDetailSearch: View{
    
    let categories: [CategoryMock]
    let trainingPlans: [PhaseMock]
    let mezocycles: [MezocycleMock]
    @Binding var selectedType: DataType
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
            ScrollView{ // might create performance issues
                                    
                LeftTitleHeader(title: selectedType == DataType.mezocycle ? "Mezocycles":"Phases")
                
                if selectedType == DataType.mezocycle{
                    GridListView(items: selectedItemsSearch(allItems: mezocycles,
                                                            selectedCategory: selectedCategory,
                                                            searchText: searchText),
                                 dataType: DataType.phase,
                                 title: "Phases")
                }else{
                    GridListView(items: selectedItemsSearch(allItems: trainingPlans,
                                                            selectedCategory: selectedCategory,
                                                            searchText: searchText),
                                 dataType: DataType.mezocycle,
                                 title: "Mezocycles")
                }

                
            }
        
    }
    
    func selectedItems(allItems:[PhaseMock]) -> [PhaseMock] {
        if let selectedCategory = selectedCategory {
            if searchText.isEmpty {
                return []
            } else {

                let filteredItems = allItems
                    .filter { selectedCategory.itemIDs.contains($0.id) }
                    .filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.subTitle.localizedCaseInsensitiveContains(searchText) }

                return filteredItems
            }
        } else {
            return []
        }
    }
    
}



struct TrainingPlansViewDetail: View{
    
    let categories: [CategoryMock]
    let trainingProtocols: [PhaseMock]
    let mezocycles: [MezocycleMock]
    @Binding var selectedItem: PhaseMock?
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    @Binding var selectedType: DataType
    
    var body: some View{
            ScrollView{ // might create performance issues
                SegmentPicker(selectedType: $selectedType)
                if selectedType == DataType.mezocycle{
                    TrainingPlanListView(title: "Mezocycles", titleSize: SizeModel.large, items: selectedItemsByCategory(allItems: mezocycles, selectedCategory: selectedCategory))
                }else{
                    TrainingPlanListView(title: "Phases",titleSize: SizeModel.large, items: selectedItemsByCategory(allItems: trainingProtocols, selectedCategory: selectedCategory))

                }
                
            }
        
    }
    
}



struct SegmentPicker: View{
    @Binding var selectedType: DataType
    
    var body: some View{
        VStack {
            Picker("What is your favorite color?", selection: $selectedType) {
                Text("Short Period").tag(DataType.phase)
                Text("Long Period").tag(DataType.mezocycle)
            }
            .pickerStyle(.segmented)
        }
    }
}


struct LeftTitleHeader: View {

    var title: String
    var body: some View {
        
        HStack{
            Text(title)
                .font(.title)
//                .fontWeight(.bold)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Spacer()
        }

        
    }
}


struct TrainingPlansView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPlansView()
    }
}
