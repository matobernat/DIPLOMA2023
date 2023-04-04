//
//  GHListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI

struct GeneralHorizontalListView: View {
    let title: String
    let items: [IdentifiableItemMock]
    let titleSize: SizeModel
    let sizeModel: SizeModel
    let dataType: DataType

    var body: some View {
        switch dataType {
        case .client:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     createCardView: {
                item in AnyCardView(MediumCardView(item: item))},
                     createDetailView: {
                item in AnyDetailView(ClientDetailView(item: item))}
                        
            )
            
        case .exercise:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .mezocycle:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(MezocycleDetailView(item: item)) }
            )
        case .phase:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(TrainingPlanDetailView(item: item)) }
            )
        case .foodPlan:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .measurement:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .progressAlbum:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .trainingPlan:
            fatalError("Invalid data type: \(dataType)")
        }
    }
}


struct ListView: View {
    let title: String
    let items: [IdentifiableItemMock]
    let titleSize: SizeModel
    let sizeModel: SizeModel
    let dataType: DataType
    let createCardView: (IdentifiableItemMock) -> AnyCardView
    let createDetailView: (IdentifiableItemMock) -> AnyDetailView
    
    var body: some View{
        VStack(alignment: .leading) {
            GHListViewHeader(
                title: title,
                titleSize: titleSize,
                items: items,
                dataType: dataType,
                sizeModel: sizeModel)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination:
                                        createDetailView(item)) {
                            createCardView(item)
                                .padding(.leading, 16)
                        }
                    }
                }
            }
        }
    }
}


struct GHListViewHeader: View {
    let title: String
    let titleSize: SizeModel
    let items: [IdentifiableItemMock]
    let dataType: DataType
    let sizeModel: SizeModel
//    let destination: ([IdentifiableItem]) -> AnyView
    
    var body: some View {
        Divider()
        
            HStack {
                Text(title)
                    .font(titleSize == SizeModel.large ? .title : .headline)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                Spacer()
                NavigationLink(
                    destination: GeneralGridListView(
                        items: items,
                        title: "All \(title)",
                        dataType: dataType,
                        sizeModel: sizeModel)) {
                    Text("Show all")
                        .font(.subheadline)
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                }
            }
    }
}


struct GeneralHorizontalListView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralHorizontalListView(title: "Title", items: DataModelMock.trainingProtocols, titleSize: .medium, sizeModel: .large, dataType: .phase)
    }
}
