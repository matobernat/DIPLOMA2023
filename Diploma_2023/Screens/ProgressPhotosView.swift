//
//  ProgressPhotosView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct ProgressPhotosView: View {
    let categories: [CategoryMock] = DataModelMock.categories
    let progressAlbums: [ProgressAlbumMock] = DataModelMock.progressPhotos
    let title = "Progress Photos"
    
    @State  var selectedCategory: CategoryMock?
    @State private var selectedItem: ProgressAlbumMock?
    @State private var searchText: String = ""
    
    
    
    var body: some View {
        NavigationSplitView {
            SideBar(
                categories: categories,
                title: "Progress Photos",
                section: DataType.progressAlbum,
                selectedCategory: $selectedCategory)
        } detail: {
            NavigationStack{
                
                SearchBar(searchText: $searchText)
                
                if !searchText.isEmpty {
                    ProgressPhotoViewDetailSearch(
                        categories: categories,
                        progressAlbums: progressAlbums,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText
                    )
                } else {
                    ProgressPhotoViewDetail(
                        categories: categories,
                        progressAlbums: progressAlbums,
                        selectedCategory: $selectedCategory,
                        searchText: $searchText)
                }
            }
            .navigationTitle(selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = categories.firstIndex{$0.section == .progressAlbum}
            if let index = index {
                selectedCategory = categories[index]
            }
            
        }
    }
}

struct ProgressPhotoViewDetail: View{
    
    let categories: [CategoryMock]
    let progressAlbums: [ProgressAlbumMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
        ScrollView{ // might create performance issues
            
            GeneralHorizontalListView(
                title: "Progress Photos",
                items: selectedItemsByCategory(
                    allItems: progressAlbums,
                    selectedCategory: selectedCategory),
                titleSize: .large,
                sizeModel: .medium,
                dataType: .progressAlbum)
        }
        
    }
}
    
struct ProgressPhotoViewDetailSearch: View{
    
    let categories: [CategoryMock]
    let progressAlbums: [ProgressAlbumMock]
    @Binding var selectedCategory: CategoryMock?
    @Binding var searchText: String
    
    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearch(
                allItems: progressAlbums,
                selectedCategory: selectedCategory,
                searchText: searchText),
            title: "Progress Photos",
            dataType: .progressAlbum,
            sizeModel: SizeModel.medium
        )
    }
}
        
struct ProgressPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPhotosView()
    }
}
