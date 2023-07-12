//
//  GridListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/03/2023.
//

import SwiftUI


struct GeneralGridListView: View {
    let items: [IdentifiableItem]
    let title: String?
    let dataType: DataType
    let sizeModel: SizeModelMock

    var body: some View {
        switch dataType {
        case .client:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .exercise:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .mezocycle:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(MezocycleView(item: item)) }
            )
        case .phase:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(TrainingPlanDetailView(item: item)) }
            )
        case .foodPlan:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .measurement:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(MediumCardView(item: item)) },
                         createDetailView: { item in AnyDetailView(ItemDetailView(item: item)) }
            )
        case .progressAlbum:
            GridListView(items: items,
                         title: title,
                         sizeModel: sizeModel,
                         createCardView: { item in AnyCardView(ProgressAlbumCard(item: item)) },
                         createDetailView: { item in AnyDetailView(ProgressAlbumsDetail(item: item)) }
            )
        case .trainingPlan:
            fatalError("Invalid data type: \(dataType)")
        }
    }
}


struct GridListView: View {
    let items: [IdentifiableItem]
    let title: String?
    let sizeModel: SizeModelMock
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView

    
    
    var body: some View {
            if let title = title{
                ScrollView{ // might create performance issues
                    Grid(items: items, createCardView: createCardView, createDetailView: createDetailView, sizeModel: sizeModel)
                }
                .navigationTitle(title)
            }else{
                ScrollView{ // might create performance issues
                    Grid(items: items, createCardView: createCardView, createDetailView: createDetailView, sizeModel: sizeModel)
                }
            }

    }
}

struct Grid: View{
    let items: [IdentifiableItem]
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView
    let sizeModel: SizeModelMock
    

    var body: some View{
        if items.isEmpty {
            VStack {
                Text("No items found")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                Spacer()
            }
        }
        else{
            NavigationStack{
//                LazyVGrid(columns: columns, spacing: 16) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: columnSize(sizeModel: sizeModel)))], spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: createDetailView(item)) {
                            createCardView(item)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
    
    func columnSize(sizeModel: SizeModelMock) -> CGFloat {
        switch sizeModel{
            
        case .large:
            return 160
        case .medium:
            return 220
        case .small:
            return 160
        }
    }
}



//struct GridListView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridListView(items: DataModelMock.trainingProtocols, dataType: DataType.phase, title: nil, c)
//    }
//}
