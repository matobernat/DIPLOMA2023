//
//  SelectableListSheet.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 07/07/2023.
//

import SwiftUI

// Filter function for Selectable List View
func selectSheetItems<Item: IdentifiableItem>(allItems: [(Item, title: String, imageUrl: String?, placeholderName: String?)], searchText: String) -> [(Item, title: String, imageUrl: String?, placeholderName: String?)] {
    if searchText.isEmpty {
        return allItems
    } else {
        return allItems.filter { $0.1.localizedCaseInsensitiveContains(searchText) }
    }
}


// Selectable List Item
struct SelectableListItem: View {
    @Binding var isChecked: Bool
    let item: IdentifiableItem
    let title: String
    let imageUrl: String?
    let placeholderName: String?
    let selectSfSymbolName: String
    let unselectSfSymbolName: String

    var body: some View {
        HStack {
            // Thumbnail Image
            if let placeholderName = placeholderName {
                if let url = imageUrl, let validUrl = URL(string: url) {
                    AsyncImage(url: validUrl) { image in
                        image.resizable()
                    } placeholder: {
                        Image(placeholderName)
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                } else {
                    Image(placeholderName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                }
            }

            // Title
            Text(title)

            Spacer()

            // SF Symbol Image
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ?  unselectSfSymbolName : selectSfSymbolName)
            }
        }
    }
}



// Selectable List View
struct SelectableListView<Item: IdentifiableItem>: View {
    
    let items: [(Item, title: String, imageUrl: String?, placeholderName: String? )]
    let multipleSelection: Bool
    let selectSfSymbolName: String
    let unselectSfSymbolName: String
    let sheetTitle: String = "Select Items"

    let onDone: ([Item]) -> Void
    let onCancel: () -> Void
    
    @State private var selectedItems: [Item]
    @State private var searchText = ""
    
    @Environment(\.presentationMode) var presentationMode

    init(items: [(Item, title: String, imageUrl: String?, placeholderName: String? )],
         multipleSelection: Bool,
         selectSfSymbolName: String,
         unselectSfSymbolName: String,
         selectedItems: [Item] = [],
         onDone: @escaping ([Item]) -> Void,
         onCancel: @escaping () -> Void) {
        self.items = items
        self.multipleSelection = multipleSelection
        self.selectSfSymbolName = selectSfSymbolName
        self.unselectSfSymbolName = unselectSfSymbolName
        self.onDone = onDone
        self.onCancel = onCancel
        _selectedItems = State(initialValue: selectedItems)
    }
    
    

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                 SearchBar(searchText: $searchText)
                     .padding(.horizontal)
                
                // Filter items by searchText before passing to List
                let filteredItems = selectSheetItems(allItems: items, searchText: searchText)
                
                List(filteredItems, id: \.0.id) { item, title, imageUrl, placeholderName in
                    SelectableListItem(isChecked: isItemSelected(item),
                                       item: item,
                                       title: title,
                                       imageUrl: imageUrl,
                                       placeholderName: placeholderName,
                                       selectSfSymbolName: selectSfSymbolName,
                                       unselectSfSymbolName: unselectSfSymbolName)
                }
            }
            .navigationBarTitle(sheetTitle, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedItems.removeAll()
                        onCancel()
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onDone(selectedItems)
                        selectedItems.removeAll()
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
    
    
    private func isItemSelected(_ item: Item) -> Binding<Bool> {
        .init(
            get: { selectedItems.contains(where: { $0.id == item.id }) },
            set: { if $0 { addSelectedItem(item) } else { removeSelectedItem(item) } }
        )
    }


    private func addSelectedItem(_ item: Item) {
        if multipleSelection || selectedItems.isEmpty {
            selectedItems.append(item)
        } else {
            selectedItems[0] = item
        }
    }

    private func removeSelectedItem(_ item: Item) {
        selectedItems.removeAll(where: { $0.id == item.id })
    }
}
