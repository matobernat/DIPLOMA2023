//
//  ProgressAlbumCard.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 03/07/2023.
//

import SwiftUI

struct ProgressAlbumCard: View, CardView {
    
    
    let album: ProgressAlbum
    
    init(item: IdentifiableItem) {
        self.album = item as! ProgressAlbum
    }
    
    let cornerRadius: CGFloat = 9
    let imageSize: CGFloat = 160
    let LabelHeight: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: album.thumbnailUrl)) { image in
                image.resizable()
            } placeholder: {
                // Placeholder Image
                Image("ProgressAlbumPlaceholder")
                    .resizable()
                    .scaledToFit()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: imageSize, height: imageSize)
            .background(.blue)
            .cornerRadius(cornerRadius)
            
            Text(album.title) // If title is nil, use typeToTitle
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Text(album.subTitle)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary)
            
//            VStack(alignment: .leading, spacing: 0) {
//                Text(album.title)
//                    .font(.body)
//                Text(album.subTitle)
//                    .foregroundColor(Color(UIColor.systemGray2))
//            }
//            .padding(.leading, 10)
//            Spacer()
        }
//        .frame(width: imageSize, height: imageSize + LabelHeight)
    }
}



struct ProgressAlbumCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressAlbumCard(item: ProgressAlbum.createMockAlbum())
    }
}
