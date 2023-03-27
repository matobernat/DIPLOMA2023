//
//  ItemListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI

struct ItemListView: View {
    let title: String
    let items: [IdentifiableItem]
    let titleSize: SizeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HorizontalItemListHeader(title: title, items: items, titleSize: titleSize)
            ScrollView(.horizontal) {
                HStack{
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemCard(item: item)
                        }
                    }
                }
            }.padding(.leading, 16)
        }
    }
}

struct HorizontalItemListHeader: View {
    let title: String
    let items: [IdentifiableItem]
    let titleSize: SizeModel
    var body: some View {
        Divider()
        HStack {
            Text(title)
                .font(titleSize == SizeModel.large ? .title : .headline)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Spacer()
            NavigationLink(destination: ItemGridView(items: items, title: title)) {
                Text("Show all")
                    .font(.subheadline)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct ItemGridView: View {
//    @Environment(\.presentationMode) var presentationMode
    
    let items: [IdentifiableItem]
    let title: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.id) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
//                .navigationBarItems(leading: Button("Back") {
//                    presentationMode.wrappedValue.dismiss()
//                })
                .navigationTitle("All \(title)")
            }
    
}

struct ItemDetailView: View {
    
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



struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(title: "Metrics", items: DataModelMock.measurements, titleSize: .large)
    }
}
