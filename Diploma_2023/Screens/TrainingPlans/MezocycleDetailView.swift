//
//  MezocycleDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI

struct MezocycleDetailView: View, DetailView {
    init(item: IdentifiableItem) {
        mezocycle = item as! MezocycleMock
    }
    
    
    var mezocycle: MezocycleMock
    var allPhases: [PhaseMock] = DataModelMock.trainingProtocols
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                MezocycleDetailViewHeader(mezocycle: mezocycle)
                GeneralHorizontalListView(
                    title: "Phases",
                    items: selectedItems(allItems: allPhases),
                    titleSize: .large,
                    sizeModel: .large,
                    dataType: .phase)
            }
        }
        .navigationTitle(mezocycle.title)
        
    }
    
    
    func selectedItems(allItems:[PhaseMock]) -> [PhaseMock] {
        if allItems.isEmpty{
            return []
        }
        let filteredItems = allItems
            .filter { mezocycle.phasesIDs.contains($0.id) }
                    
        return filteredItems
    }
}



struct MezocycleDetailViewHeader: View{
    
    var mezocycle : IdentifiableItem
    
    var body: some View{
        VStack(alignment: .leading){
            
            HStack{
                LargeCardImage(item: mezocycle)
                    .padding(.leading, 20)
                VStack{
                    Text(mezocycle.subTitle)
                        .font(.headline)
                        .bold()
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                }
            }
            
            Divider()
            
            InfoRowView(items: getMockInfoRowItems())
            
        }
    }
}

struct MezocycleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MezocycleDetailView(item: DataModelMock.mezocycles.first!)
    }
}
