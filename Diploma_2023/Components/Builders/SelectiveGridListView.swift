//
//  SelectiveGridListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 26/05/2023.
//

import SwiftUI

struct SelectiveGridListViewAdd: View {
    let items: [Phase]
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView
    let sizeModel: SizeModel = .large
    @Binding var selectedItems: [Phase]
    @Binding var parentItem: Mezocycle
    @State var isSelected: [String: Bool] = [:]
    @State var searchText = ""
    
    var body: some View {
        if items.isEmpty {
            VStack {
                Text("No items found")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                Spacer()
            }
        } else {
            NavigationStack{
                SearchBar(searchText: $searchText)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: columnSize(sizeModel: sizeModel)))], spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        ZStack(alignment: .topLeading) {
                            NavigationLink(destination: createDetailView(item)) {
                                createCardView(item)
                            }
                            Button(action: {
                                if isSelected[item.id] == true {
                                                                    isSelected[item.id] = true
                                                                    selectedItems.removeAll(where: { $0.id == item.id })
                                                                } else {
                                                                    isSelected[item.id] = true
                                                                    selectedItems.append(item.duplicate().setMezoID(mezoID: parentItem.id))
                                                                }
                            }) {
                                Image(systemName: isSelected[item.id] == true ? "plus.circle" : "plus.circle")
                                                                    .foregroundColor(isSelected[item.id] == true ? .gray : .green)
                                                                    .padding(8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
            Spacer()
            }
        }
    }
    
    func columnSize(sizeModel: SizeModel) -> CGFloat {
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


struct SelectiveGridListViewEdit: View {
    let items: [Phase]
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView
    let sizeModel: SizeModel = .large
    @Binding var selectedItems: [Phase]
    @Binding var parentItem: Mezocycle
    @State var isSelected: [String: Bool] = [:]
    @State var searchText = ""

    var body: some View {
        if items.isEmpty {
            VStack {
                Text("No items found")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                Spacer()
            }
        } else {
            NavigationStack{
                SearchBar(searchText: $searchText)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: columnSize(sizeModel: sizeModel)))], spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        ZStack(alignment: .topLeading) {
                            NavigationLink(destination: createDetailView(item)) {
                                createCardView(item)
                            }
                            Button(action: {
                                selectedItems.removeAll(where: { $0.id == item.id })
                            }) {
                                Image(systemName: "minus.circle" )
                                    .foregroundColor( .red)
                                    .padding(8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            Spacer()
            }
        }
    }

    func columnSize(sizeModel: SizeModel) -> CGFloat {
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
