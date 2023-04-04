//
//  LargeCardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI


struct LargeCardView: View, CardViewMock {

    let item: IdentifiableItemMock
    
    init(item: IdentifiableItemMock) {
        self.item = item
    }

    var body: some View {
        VStack(alignment: .leading){
            
            LargeCardImage(item: item)
            
            Text(item.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Text(item.subTitle)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary)
        }

    }
}

struct LargeCardImage: View{
    
    let item: IdentifiableItemMock
    
    var body: some View{
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
    }
}

struct LargeCardView_Previews: PreviewProvider {
    static var previews: some View {
        LargeCardView(item: DataModelMock.trainingProtocols.first!)
    }
}


struct TrainingPlanDetailView: View, DetailViewMock {
    
    let item: IdentifiableItemMock
    
    var body: some View {
        PhaseSheet()
    }
}


struct GeneralMockDetailView: View, DetailViewMock {
    
    let item: IdentifiableItemMock
    
    var body: some View {
        VStack {
            Image(item.imageName)
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
