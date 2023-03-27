//
//  FoodPlanCard.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI

struct ItemCard: View {
    let item: IdentifiableItem
    
    
    var body: some View {
        HStack(alignment: .center) {
            Image(item.imageName)
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

struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
        ItemCard(item: DataModelMock.foodPlans.first!)
    }
}
