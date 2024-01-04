//
//  GHListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI

struct GeneralHorizontalListView: View {
    let title: String
    let items: [IdentifiableItem]
    let titleSize: SizeModel
    let sizeModel: SizeModel
    let dataType: DataType
    var hideDivider: Bool?
    
    var addFunc: (() -> Void)? // for now implemented in Training protocols

    var body: some View {
        switch dataType {
        case .client:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
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
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .mezocycle:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(MezocycleView(item: item)) },
                     addFunc: addFunc

            )
        case .phase:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(TrainingPlanDetailView(item: item)) },
                     addFunc: addFunc

            )
        case .foodPlan:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(FoodPlanDetailView(item: item)) },
                     addFunc: addFunc
            )
        case .progressAlbum:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(ProgressAlbumCard(item: item)) },
                         createDetailView: { item in AnyDetailView(ProgressAlbumsDetail(item: item)) },
                     addFunc: addFunc
            )
        case .measurement:
            ListView(title: title,
                     items: items,
                     titleSize: titleSize,
                     sizeModel: sizeModel,
                     dataType: dataType,
                     hideDivider: hideDivider,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(MeasurementsDetailView(item: item)) },
                     addFunc: addFunc
            )
        case .trainingPlan:
            fatalError("Invalid data type: \(dataType)")
        }
    }
}


struct ListView: View {
    let title: String
    let items: [IdentifiableItem]
    let titleSize: SizeModel
    let sizeModel: SizeModel
    let dataType: DataType
    var hideDivider: Bool?
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView
    
    var addFunc: (() -> Void)?     // If function not provided, no button needed
    
    var body: some View{
        VStack(alignment: .leading) {
            
            // HEADER
            GHListViewHeader(
                title: title,
                titleSize: titleSize,
                items: items,
                dataType: dataType,
                sizeModel: sizeModel,
                hideDivider: hideDivider)
                        
            // ADD BUTTON + LIST OF ITEMS
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    // ADD BUTTON
                    if let addFunc = addFunc {
                        Button(action: {
                            addFunc()
                        }) {
                            if sizeModel == .large{
                                LargeCardButtonLabel(type: dataType)
                                    .padding(.leading, 16)
                            }
                            else{
                                Text("TODO CardButtonLabel")
                            }
                        }
                    }

                    // LIST OF ITEMS
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
    let items: [IdentifiableItem]
    let dataType: DataType
    let sizeModel: SizeModel
    let hideDivider: Bool?
//    let destination: ([IdentifiableItem]) -> AnyView
    
    var body: some View {
        
        if hideDivider != true {
            Divider()
        }
        
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
