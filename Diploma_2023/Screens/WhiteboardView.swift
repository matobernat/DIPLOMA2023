//
//  WhiteboardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct WhiteboardView: View {
    @State private var departmentId: Int?
    @State private var employeeId: Int?
    
    var body: some View {
        Text("WhiteBoard")
    }
}


struct WhiteboardView_Previews: PreviewProvider {
    static var previews: some View {
        WhiteboardView()
    }
}
