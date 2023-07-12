//
//  ProgressPhotoDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 11/07/2023.
//

import SwiftUI


struct ProgressPhotoDetailView: View {
    let progressPhotos: [ProgressPhoto]
    @Binding var selectedProgressPhotoIndex: Int
    @ObservedObject var parentViewModel: ProgressAlbumsDetailViewModel

    @State private var currentPhotoIndex: Int

    init(progressPhotos: [ProgressPhoto], selectedProgressPhotoIndex: Binding<Int>, parentViewModel: ProgressAlbumsDetailViewModel) {
        self.progressPhotos = progressPhotos
        self._selectedProgressPhotoIndex = selectedProgressPhotoIndex
        self.parentViewModel = parentViewModel
        self._currentPhotoIndex = State(initialValue: selectedProgressPhotoIndex.wrappedValue)
    }

    var body: some View {
        VStack {
            TabView(selection: $currentPhotoIndex) {
                ForEach(progressPhotos.indices, id: \.self) { index in
                    if let url = URL(string: progressPhotos[index].imageUrl) {
                        VStack {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .tag(index)
//                            Text(progressPhotos[index].dateOfCreation)
//                                .font(.title)
                            Text("\(progressPhotos[index].dateOfCreation.ISO8601Format())")
                                .font(.caption)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // for swipeable view
            .onChange(of: currentPhotoIndex) { newValue in
                selectedProgressPhotoIndex = newValue
            }
            Spacer()
        }
        .padding()
//        .navigationTitle("Photo Detail")
    }
}





struct ProgressPhotoBasicDetailView: View {
    let url: URL
    let date: Date

    var body: some View {
        VStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            Text("\(date.ISO8601Format())")
                .font(.title)
            Spacer()
        }
        .padding()
//        .navigationTitle("Photo Detail")
    }
}
