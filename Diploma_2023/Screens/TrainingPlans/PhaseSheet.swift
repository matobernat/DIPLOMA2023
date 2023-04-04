//
//  PhaseSheet.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//
import SwiftUI

struct PhaseSheet: View {

    var headerLabels = ["NAME", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
    var headerData = ["Add..", "Add..", "Add..", "Add.."]
    
    
    var sheetLabels = ["Exercise", "Tempo", "Rep", "Set","Rest", "Micro","Load", "Load","Load", "Load"]

    var sheetData = [
        ["Exercise1", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise2", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise3", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise4", "Add..", "Add..", "Add..", "Add..", "Add.."],
    ]
    


    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                
                Header(labels: headerLabels,data: headerData)
            
                Sheet(labels:sheetLabels ,data: sheetData)
                
            }
        }

    }
}



struct Sheet: View {
    var labels: [String]
    var data: [[String]]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,70,70,70,70,70,200,200,200,200,]
    
    var body: some View {
        Text("Hello")
        
        ScrollView(.horizontal){
            VStack(spacing: 0){
                // LABEL HEADER
                SheetRowBuilder(data: labels, width: width, height: height, color: Color.secondary)
                // TABLE
                SheetBuilder(data: data, width: width, height: height, color: Color.white)
            }
        }
    }

    private func columnHeader(_ title: String) -> some View {
        Text(title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .border(Color.gray, width: 1)
    }
}



struct SheetBuilder: View {
    var data: [[String]]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color
    @State var textFields: [[String]] = [["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."]
    ]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                SheetRowBuilder(data: data[index], textFields: $textFields[index], width: width, height: height, color: color)
            }
        }
    }
}


// This Struct may have some indexing error in the future
struct SheetRowBuilder: View {
    var data: [String]
    var textFields: Binding<[String]>?

    var width: [CGFloat]
    var height: CGFloat
    var color: Color



    var body: some View {
        HStack(spacing: 0) {
            
            // Text Cells with data
            ForEach(data.indices, id: \.self) { index in
                CellBuilder(content: data[index], text: nil, width: width[index], height: height, color: color)
            }
            
            // TextFields with Bindings
            if let textFieldsBinding = textFields {
                ForEach(textFieldsBinding.indices, id: \.self) { index in
                    CellBuilder(content: nil, text: textFieldsBinding[index], width: width[index + data.count], height: height, color: color)
                }
            }

        }
    }
}


struct Header: View {
    var labels: [String]
    var data: [String]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,300,300,300]

    var body: some View {
        ScrollView(.horizontal){
            VStack(spacing: 0){
                HeaderRowBuilder(data: labels,
                             width: width,
                             height: 50,
                             color: Color.gray.opacity(0.2))
                HeaderRowBuilder(data: data,
                             width: width,
                             height: height,
                             color: Color.white.opacity(0.2))
            }
        }


    }

    private func columnHeader(_ title: String) -> some View {
        Text(title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .border(Color.gray, width: 1)
    }
}

struct HeaderRowBuilder: View {
    var data: [String]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                CellBuilder(content: data[index], text: nil, width: width[index], height: height, color: color)
            }
        }
    }
}


struct CellBuilder: View {
    var content: String?
    var text: Binding<String>?

    
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        if let textBinding = text {
            CustomTextEditorCell(textBinding: textBinding,
                         width: width,
                         height: height,
                         color: color)
        } else if let content = content {
            Text(content)
                .frame(width: width, height: height)
                .background(color)
                .border(Color.gray, width: 1)
        } else {
            Text("Input error")
                .frame(width: width, height: height)
                .background(color)
                .border(Color.red, width: 5)
        }
    }
}




struct PhaseSheet_Previews: PreviewProvider {
    static var previews: some View {
        PhaseSheet()
    }
}

