//
//  ProgressPhotosView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct ProgressPhotosView: View {
        var body: some View {
            NavigationSplitView {
                Text("Sidebar")
            } content: {
                Text("Primary View")
            } detail: {
                Text("Detail View")
            }
        }
    }


struct ProgressPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPhotosView()
    }
}
