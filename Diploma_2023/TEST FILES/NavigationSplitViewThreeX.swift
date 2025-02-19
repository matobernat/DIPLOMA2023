//
//  NavigationSplitViewThreeX.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/03/2023.
//

import SwiftUI

struct NavigationSplitViewThreeX: View {
        
    @State private var selectedFolder: String?
    @State private var selectedItem: String?
    
    @State private var folders = [
        "All": [
            "Item1",
            "Item2"
        ],
        "Favorites": [
            "Item2"
        ]
    ]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedFolder) {
                ForEach(Array(folders.keys.sorted()), id: \.self) { folder in
                    NavigationLink(value: folder) {
                        Text(verbatim: folder)
                    }
                }
            }
            .navigationTitle("Sidebar")
        } content: {
            if let selectedFolder {
                List(selection: $selectedItem) {
                    ForEach(folders[selectedFolder, default: []], id: \.self) { item in
                        NavigationLink(value: item) {
                            Text(verbatim: item)
                        }
                    }
                }
                .navigationTitle(selectedFolder)
            } else {
                Text("Choose a folder from the sidebar")
            }
        } detail: {
            NavigationStack {
                ZStack {
                    if let selectedItem {
                        NavigationLink(value: selectedItem) {
                            Text(verbatim: selectedItem)
                                .navigationTitle(selectedItem)
                        }
                    } else {
                        Text("Choose an item from the content")
                    }
                }
                .navigationDestination(for: String.self) { text in
                    Text(verbatim: text)
                }
            }
        }
    }
}




struct NavigationSplitViewThreeX_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitViewThreeX()
    }
}
