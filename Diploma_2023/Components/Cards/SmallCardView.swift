//
//  SmallCardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 23/04/2023.
//

import SwiftUI

struct SmallCardView: View {
    let item: IdentifiableItem
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                    .frame(width: 60, height: 60)
                
                Image(item.placeholderName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(item.title).font(.headline)
                Text(item.subTitle).font(.subheadline)
            }
            Spacer()
        }
    }
}


struct ClientSmallCardView: View {
    let size: CGFloat = 60
    let client: Client
    
    var body: some View {
        HStack {
            ClientAsyncImage(placeholderImageName: client.placeholderName, imageUrl: client.imageUrl, size: size)
            VStack(alignment: .leading) {
                Text(client.title).font(.headline)
                Text(client.subTitle).font(.subheadline)
            }
            Spacer()
        }
    }
}


struct SmallCardView_Previews: PreviewProvider {
    static var previews: some View {
        SmallCardView(item: DataModelMock.clients.first!)
    }
}
