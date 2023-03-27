//
//  SessionCard.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 17/03/2023.
//

import SwiftUI

struct TrainingPlanCard: View {

    let item: IdentifiableItem

    var body: some View {
        VStack(alignment: .leading){
            ZStack {
                if item.dataType == DataType.mezocycle {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color(.systemGray4))
                        .frame(width: 160, height: 160)
                }else{
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color(.systemGray6))
                        .frame(width: 160, height: 160)
                }

                
                VStack(spacing: 11) {
                    Image(item.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 33)
                    
                    Text( item.dataType == DataType.mezocycle ? "Mezocycle" : "PX - IN SEASON")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(item.dataType == DataType.mezocycle ? "Hypertrophy" : "MAXIMAL STRENGTH & ACCELERATION")
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .foregroundColor(.primary)
                }
            }
            .frame(width: 160, height: 160)
            Text(item.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Text(item.subTitle)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary)
        }

    }
}

//struct SessionCardModel {
//    let thumbnail: String
//    let name: String
//    let description: String
//}



struct SessionCard_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPlanCard(item: DataModelMock.trainingProtocols.first!)
    }
}
