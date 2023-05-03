//
//  InfoRowView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 17/03/2023.
//

import SwiftUI

///  NOTE  in  order to have right format of the dividers, you have to wrap it in scroll view
struct InfoRowView: View {
    
    let cardTitles: [String]
    let cardValues: [String]
    let cardDescriptions: [String]?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<cardTitles.count) { i in
                InfoRowCard(cardTitle: cardTitles[i], cardValue: cardValues[i], cardDescription: cardDescriptions?[i] ?? "")
                Divider()
            }
        }
        .padding(.vertical, 20)
    }
}

struct InfoRowCard: View {
    
    let cardTitle: String
    let cardValue: String
    let cardDescription: String
    
    var body: some View {
        Spacer()
        VStack(alignment: .center, spacing: 5) {
            Text(cardTitle)
                .font(.headline)
                .foregroundColor(.gray)
            Text(cardValue)
                .font(.headline)
                .foregroundColor(.primary)
            Text(cardDescription)
                .font(.headline)
                .foregroundColor(.gray)
        }
        Spacer()
    }
}


struct InfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        InfoRowView(cardTitles: MockInfoRowData.cardTitles, cardValues: MockInfoRowData.cardValues, cardDescriptions: MockInfoRowData.cardDescriptions)
    }
}
