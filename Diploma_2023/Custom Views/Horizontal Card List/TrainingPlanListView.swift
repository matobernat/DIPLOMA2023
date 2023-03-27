//
//  SessionListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 17/03/2023.
//

import SwiftUI

struct TrainingPlanListView: View {
    let title: String
    let titleSize: SizeModel
    let items: [IdentifiableItem]
    
    
    var body: some View {
        VStack(alignment: .leading) {
 
            HorizontalTrainingPlanListHeader(title: title, titleSize: titleSize, items: items)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: TrainingPlanDetailView(item: item)) {
                            TrainingPlanCard(item: item)
                                .padding(.leading, 16)
                        }
                    }
                }
            }
        }
    }
}

struct HorizontalTrainingPlanListHeader: View {
    let title: String
    let titleSize: SizeModel
    let items: [IdentifiableItem]
    var body: some View {
        Divider()
        HStack {
            Text(title)
                .font(titleSize == SizeModel.large ? .title : .headline)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Spacer()
            NavigationLink(destination: TrainingPlanGridView(items: items)) {
                Text("Show all")
                    .font(.subheadline)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct TrainingPlanGridView: View {
    
    let items: [IdentifiableItem]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.id) { item in
                            NavigationLink(
                                destination: TrainingPlanDetailView(item: item)) {
                                TrainingPlanCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
}

struct TrainingPlanDetailView: View {
    
    let item: IdentifiableItem
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(9)
                .padding(.bottom, 8)
            Text(item.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            Text(item.subTitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(item.title)
    }
}


//struct TrainingPlanGrid: View{
//    @Environment(\.presentationMode) var presentationMode
//
//    let items: [MockItemCard]
//
//    var body: some View{
//        TrainingPlanGridView(items: sessions)
//            .navigationBarItems(leading: Button("Back") {
//                presentationMode.wrappedValue.dismiss()
//            })
//            .navigationTitle("All Sessions")
//    }
//}



struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPlanListView(title: "TrainingPlans", titleSize: SizeModel.medium, items: DataModelMock.trainingProtocols )
    }
}
