//
//  MediumCardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI

struct MediumCardView: View, CardView {
    let item: IdentifiableItem
    
    init(item: IdentifiableItem) {
        self.item = item
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(item.placeholderName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(9)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(item.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(UIColor.systemGray2))
                
                Text(item.subTitle)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(item.subTitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(UIColor.systemGray2))
                Text(item.subTitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(UIColor.systemGray2))
            }
            .padding(.leading, 10)
            Spacer()
        }
        .frame(width: 220, height: 100)
    }
}
struct MediumCardView_Previews: PreviewProvider {
    static var previews: some View {
        MediumCardView(item: DataModelMock.foodPlans.first!)
    }
}


struct ItemDetailView: View, DetailView{

    
    var item: IdentifiableItem
    
    init(item: IdentifiableItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Image(item.placeholderName)
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
