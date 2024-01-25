//
//  CellBuilders.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 10/10/2023.
//

import SwiftUI

<<<<<<< HEAD
// CELL BUILDER - STATIC BINDIND
struct StaticBindingCellBuilder: View {
    var textBinding: Binding<String>

    var width: CGFloat
    var height: CGFloat
    var color: Color
    var textColor: Color?
    var borderWidth: Double?
    var borderColor: Color?

    var body: some View {
        Text(textBinding.wrappedValue)
            .frame(width: width, height: height)
            .background(color)
            .border(borderColor ?? Color.gray, width: borderWidth ?? 0.5)
            .foregroundColor(textColor ?? .primary)  // Use provided textColor or fall back to the primary color

    }
}



// CELL BUILDER - STATIC TEXT
struct StaticTextCellBuilder: View {
    var text: String?
    
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var textColor: Color?
    var opacity: Double?
    var borderWidth: Double?
    var borderColor: Color?
    

    var body: some View {
        Text(text ?? "") // display "N/A" if text is nil
            .frame(width: width, height: height)
            .background(color)
            .opacity(opacity ?? 1)
            .border(borderColor ?? Color.gray, width: borderWidth ?? 0.5)
            .foregroundColor(textColor ?? .primary)  // Use provided textColor or fall back to the primary color
    }
}




// CELL BUILDER - TEXT Editor BINDING
 struct TextEditorCellBuilder: View {
     var textBinding: Binding<String>
     var modified: Binding<Bool>?  // Optional binding flag for modification

     
     var width: CGFloat
     var height: CGFloat
     var color: Color
     var borderWidth: Double?
     var borderColor: Color?

     
     var body: some View {
         TextEditor(text: textBinding.onChange {
                     modified?.wrappedValue = true
                 })
             .frame(width: width, height: height)
             .background(color)
             .border(borderColor ?? Color.gray, width: borderWidth ?? 0.5)
//             .opacity(0.8)
     }
     
 }


// CELL BUILDER - TEXT FIELD BINDING
 struct TextFieldCellBuilder: View {
     var textBinding: Binding<String>

     var width: CGFloat
     var height: CGFloat
     var color: Color
     
     var modified: Binding<Bool>?  // Optional binding flag for modification
     
     var borderWidth: Double?
     var borderColor: Color?

     
     var body: some View {
         TextField( "", text: textBinding.onChange {
                     modified?.wrappedValue = true
                 })
         .multilineTextAlignment(.center)
             .frame(width: width, height: height, alignment: .center)
             .textFieldStyle(PlainTextFieldStyle())  // Remove default styling
             .background(color)
             .border(borderColor ?? Color.gray, width: borderWidth ?? 0.5)
//             .opacity(0.8)
     }
     
 }

// Helper function to trigger onChange event
extension Binding where Value: Equatable{
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if self.wrappedValue != newValue  {
                    self.wrappedValue = newValue
                    handler()
                }
            }
        )
    }
}



// UNIVERSAL - HEADER
struct SheetHeaderBuilder: View {
    var labels: [String]
    var widths: [CGFloat]?  // Optional
    var uniformWidth: CGFloat?  // Optional
    var height: CGFloat
    var color: Color
    var textColor: Color?
    var opacity: Double?
    var borderWidth: Double?
    var borderColor: Color?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(labels.indices, id: \.self) { index in
                
                // Use uniformWidth if available, otherwise fall back to width array
                let cellWidth = uniformWidth ?? (widths?[index] ?? 50)
                
                StaticTextCellBuilder( text: labels[index], width: cellWidth, height: height, color: color, textColor: textColor, opacity: opacity, borderWidth: borderWidth)
            }
        }
    }
}

=======
struct CellBuilders: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CellBuilders_Previews: PreviewProvider {
    static var previews: some View {
        CellBuilders()
    }
}
>>>>>>> main
