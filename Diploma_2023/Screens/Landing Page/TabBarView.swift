//
//  TabBarView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI
import Combine




struct TabBarView: View {

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Today")
                }
            ClientsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Clients")
                }
//            WhiteboardView()
//                .tabItem {
//                    Image(systemName: "pencil")
//                    Text("Whiteboard")
//                }
            TrainingPlansView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Training Plans")
                }
            ExerciseView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Exercise")
                }
            AccountTabView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Account")
                }
            
//            FoodPlansView()
//                .tabItem {
//                    Image(systemName: "leaf")
//                    Text("Food Plans")
//                }
//            MeasurementsView()
//                .tabItem {
//                    Image(systemName: "chart.bar")
//                    Text("Measurements")
//                }
//            ProgressPhotosView()
//                .tabItem {
//                    Image(systemName: "camera.fill")
//                    Text("Progress Photos")
//                }
        }
    }
}






struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
