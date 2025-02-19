//
//  LargeCardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI



struct LargeCardView: View, CardView {

    let item: IdentifiableItem
    
    init(item: IdentifiableItem) {
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
    
    let item: IdentifiableItem
    
    let cornerRadius: CGFloat = 9
    let imageSize: CGFloat = 160
    let LabelHeight: CGFloat = 50
    
    var body: some View{
        ZStack {
            
            
            // PHASE
            if let phaseItem = item as? Phase {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(.systemGray6))
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 11) {
                    Image(item.placeholderName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 33)
                    
                    Text(phaseItem.headerPhaseInSeason)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(phaseItem.headerIntegrationGoal)
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .foregroundColor(.primary)
                }
                
            // MEZOCYCLE
            } else if let mezoItem = item as? Mezocycle {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(.systemGray4))
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 11) {
                    Image(mezoItem.placeholderName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 33)
                    
                    Text("Mezocycle")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(mezoItem.trainingFocus)
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .foregroundColor(.primary)
                }
            }else{
                
                VStack(alignment: .leading) {
                    
                    // Placeholder Image
                    Image(item.placeholderName)
                        .resizable()
                        .scaledToFit()
                    
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .background(.blue)
                    .cornerRadius(cornerRadius)
                    
//                    Text(album.title) // If title is nil, use typeToTitle
//                        .font(.system(size: 10, weight: .medium))
//                        .foregroundColor(.primary)
//                    Text(album.subTitle)
//                        .font(.system(size: 10, weight: .regular))
//                        .foregroundColor(.secondary)
                }
            }
            
        }
        .frame(width: 160, height: 160)
    }
}


// ADD BUTTON
struct LargeCardButtonLabel: View {

    var type: DataType
    var title: String?
    let cornerRadius: CGFloat = 9
    let size: CGFloat = 160
    
    var typeToTitle: String {
        switch type {
        case .phase:
            return "New Phase"
        case .mezocycle:
            return "New Mezocycle"
        case .progressAlbum:
            return "New Album"
        case .measurement:
            return "New Measuremets"
        default:
            return "New..."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(type == .mezocycle ? Color(.systemGray4) : Color(.systemGray5))
                    .frame(width: size, height: size)
                
                VStack(spacing: 11) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(.systemGray2))
                        .font(.system(size: 10, weight: .thin))
                }
            }
            .frame(width: size, height: size)
            Text(title ?? typeToTitle) // If title is nil, use typeToTitle
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Text("Add..")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary)
        }
    }
}



struct LargeCardView_Previews: PreviewProvider {
    static var previews: some View {
        LargeCardView(item: DataModelMock.trainingProtocols.first!)
    }
}


struct TrainingPlanDetailView: View, DetailView {

    var item: IdentifiableItem

    init(item: IdentifiableItem) {
        self.item = item
    }


    var body: some View {
        if item.dataType == .phase{
            PhaseSheetView(item: item )
        }
        else{
            StaticPhaseSheetView()
        }

    }
}


struct GeneralMockDetailView: View, DetailView {
    
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
