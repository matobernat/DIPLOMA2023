//
//  CustomTextEditorCell.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 02/04/2023.
//

import SwiftUI
import Combine

struct CustomTextEditorCell: View {
    @Binding var textBinding: String
    var width: CGFloat
    var height: CGFloat
    var color: Color
    
    var body: some View {
        TextEditor(text: $textBinding)
            .frame(width: width, height: height)
            .background(color)
            .border(Color.gray, width: 1)
            .opacity(0.8)
    }
}


struct CustomTextEditorCell_Previews: PreviewProvider {
    
    @State static var textText1: String = "Lorem"
    
    @State static var testText2: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

    @State static var previewTestText: String = textText1
    
    
    
    
    static var previews: some View {
        VStack{
            CustomTextEditorCell(textBinding: $previewTestText,
                                 width: 200,
                                 height: 100,
                                 color: .white)
            Spacer()
        }
    }
}
