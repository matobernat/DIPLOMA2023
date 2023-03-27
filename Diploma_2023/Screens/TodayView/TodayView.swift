//
//  TodayView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var orientation = UIDeviceOrientation.unknown

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)
                Spacer()
            }
            Divider() // Add a divider here
            // Content
            ScrollView {
                if orientation.isPortrait{
                    VStack {
//                        Rectangle()
                        Image("calendar-widget")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .fill(Color.secondary)
                            .frame(width: 600, height: 400)
                            .cornerRadius(10)
                            .padding(50)

//                        Rectangle()
                        Image("suggested-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .fill(Color.secondary)
                            .frame(width: 600, height: 300)
                            .cornerRadius(10)
                            .padding(50)

                    }
                } else{
                    HStack {
//                        Rectangle()
                        Image("calendar-widget")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .fill(Color.secondary)
                            .frame(width: 600, height: 400)
                            .cornerRadius(10)
                            .padding(50)

//                        Rectangle()
                        Image("suggested-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .fill(Color.secondary)
                            .frame(width: 300, height: 400)
                            .cornerRadius(10)
                            .padding(50)
                    }
                }
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
