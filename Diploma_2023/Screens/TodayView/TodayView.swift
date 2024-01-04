
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
    @State var isShowingProfile = false

    var body: some View {
            VStack {
                // Header                
                TodayHeaderView(isShowingProfile: $isShowingProfile)

                
                // Content
                TodayContentView(orientation: $orientation)
//                TodayContentTestView()
            }

        
        
        // PRODUCTION CODE  _________  comment/uncomment
        
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        }
}





struct TodayHeaderView: View {
    @Binding var isShowingProfile: Bool
    var body: some View {
        HStack {
            Text("Today")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.leading)
            Spacer()
                .accessibilityIdentifier("TodayViewLabel")
            
            Button(action: {
                isShowingProfile = true
            }, label: {
                Image(systemName: "person")
                    .font(.system(size: 20))
            })
            .padding(.trailing, 10)
            .sheet(isPresented: $isShowingProfile) {
                AccountView(isShowingAccount: $isShowingProfile)
            }
        }
        .padding(.top, 10)
        Divider() // Add a divider here
    }
}


struct TodayContentTestView: View {
    var body: some View {
        ScrollView{
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
        }
    }
}


struct TodayContentView: View {
    
    @Binding var orientation: UIDeviceOrientation
    
    var body: some View {
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
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}








