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
//            .onReceive(Just(textBinding)) { newValue in
//                let lastCharIndex = newValue.index(before: newValue.endIndex)
//                let lastChar = newValue[lastCharIndex]
//
//                if lastChar == "\n" {
//                    // Split the text into individual lines
//                    let lines = newValue.split(separator: "\n", omittingEmptySubsequences: false)
//
//                    // Create a new string with numbered lines
//                    var numberedText = ""
//                    for (index, line) in lines.enumerated() {
//                        numberedText += "\(index+1): \(line)\n"
//                    }
//
//                    // Update the text binding with the numbered text
//                    textBinding = numberedText
//                }
//            }
//            .onSubmit {
//                // Add a newline character to the text when the user hits the return key
//                textBinding += "\n"
//            }
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
