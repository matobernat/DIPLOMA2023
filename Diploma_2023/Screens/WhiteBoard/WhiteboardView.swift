//
//  WhiteboardView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI

struct WhiteboardView: View {
    
    var phases: [PhaseMock] = DataModelMock.trainingProtocols

    
    
    
    var body: some View {
        Text("whiteboard")
    }
}


struct WhiteboardView_Previews: PreviewProvider {
    static var previews: some View {
        WhiteboardView()
    }
}
