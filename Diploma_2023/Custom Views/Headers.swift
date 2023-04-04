//
//  Headers.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//

import SwiftUI

struct LeftSideHeader: View {

    var title: String
    var body: some View {
        
        HStack{
            Text(title)
                .font(.title)
//                .fontWeight(.bold)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Spacer()
        }

        
    }
}
struct Headers_Previews: PreviewProvider {
    static var previews: some View {
        LeftSideHeader(title: "LeftTitleHeader")
    }
}
